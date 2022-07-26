import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = MethodChannel('yen.flutter.dev/kotlin');
  final bool isPipMode = true;

  String _batteryLevel = '電池狀態未知';
  String _notificationInfo = '未發送';
  String _isNativeView = '未顯示';

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

  Future<void> _getNotfication() async {
    String notificationInfo;
    try {
      notificationInfo = await platform.invokeMethod('getNotfication',{'title':'測試', 'detail':'發送通知發送通知'});
    } on PlatformException catch (e) {
      notificationInfo = "Failed to get notfication: '${e.message}'.";
    }

    setState(() {
      _notificationInfo = notificationInfo;
    });
  }

  Future<void> _showNativeView() async {
    String isNativeView;
    try {
      isNativeView = await platform.invokeMethod('showNativeView');
    } on PlatformException catch (e) {
      isNativeView = "Failed to showNativeView: '${e.message}'.";
    }

    setState(() {
      _isNativeView = isNativeView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _getBatteryLevel,
                child: const Text('電池狀態'),
              ),
              Text(_batteryLevel),
              ElevatedButton(
                onPressed: _getNotfication,
                child: const Text('通知'),
              ),
              Text(_notificationInfo),
              ElevatedButton(
                onPressed: _showNativeView,
                child: const Text('顯示小視窗'),
              ),
              Text(_isNativeView)
            ],
          ),
        ),
      ),
    );
  }
}
