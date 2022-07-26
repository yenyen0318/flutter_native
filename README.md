# Flutter - 與原生平台進行溝通
## 程式畫面
| 電池電量 | 通知 | 子母畫面 |
| -------- | -------- | -------- |
| ![](https://i.imgur.com/TlFJUz9.jpg)     | ![](https://i.imgur.com/7kC9zy1.jpg)     | ![](https://i.imgur.com/w1nTIlx.jpg)     |
## 相關func介紹
### MethodChannel
Flutter與原生端可相互呼叫屬於雙向溝通，呼叫後可以返回對應結果。此方式為最常用的方式，另外原生端調用需要在主線程中執行。

main.dart
```dart
//建立與原生端的溝通頻道
static const platform = MethodChannel('samples.flutter.dev/battery');

//電池狀態
String _batteryLevel = 'Unknown battery level.';

//向原生端取得電池狀態
Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
}
```
`samples.flutter.dev/battery` 可以想成MethodChannel的名稱，原生端也需要使用對應的接口，`getBatteryLevel`則是這一個頻道底下的func，如下:

* Andoiid(Kotlin)
\android\app\src\main\kotlin\MainActivity.kt
```kotlin
class MainActivity : FlutterActivity() {
    //頻道名稱
    private val CHANNEL = "samples.flutter.dev/battery"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            //頻道底下的func
            if (call.method == "getBatteryLevel") {
              //略
            } else {
              result.notImplemented()
            }
          }
    }
}
```

#### 屬性
* invokeMethod: 
    ```dart
    final int result = await platform.invokeMethod('sendData',{'name':'老萌', 'age':18});
    ```
    * 第一個參數是 func名稱
    * 第二個參數是 該func要帶入的參數

### BasicMessageChannel
嘗用於對指定消息進行編碼和解碼，也是屬於雙向溝通可由任一方進行主動呼叫。

### EventChannel
常用於狀態的監聽(例如:網絡變化、傳感器數據等)，是由Native端主動發送數據給Flutter。

## 相關套件
1. [pigeon](https://pub.flutter-io.cn/packages/pigeon)
2. [quick_actions](https://pub.flutter-io.cn/packages/quick_actions)

## 補充說明
若有修改原生系統的程式碼要記得重新編譯，不可以只用hotReload或是hotRestart。

## 參考資料
1. https://docs.flutter.dev/development/platform-integration/platform-channels
2. https://github.com/flutter/flutter/tree/main/examples/platform_channel

###### tags: `flutter`
