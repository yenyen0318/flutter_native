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
  final TextEditingController _notficationTitle = TextEditingController();
  final TextEditingController _notficationDetail = TextEditingController();

  String _batteryLevel = '';
  String _notificationInfo = '';
  String _isNativeView = '';
  String _exceptionInfo = '';

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = '$result %';
    } catch (e) {
      batteryLevel = "Failed to get battery level: '$e'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  Future<void> _getNotfication() async {
    String notificationInfo;
    try {
      FocusScope.of(context).requestFocus(FocusNode()); //remove focus
      notificationInfo = await platform.invokeMethod('getNotfication',
          {'title': _notficationTitle.text, 'detail': _notficationDetail.text});
    } catch (e) {
      notificationInfo = "Failed to get notfication: '$e'.";
    }

    setState(() {
      _notificationInfo = notificationInfo;
    });
  }

  Future<void> _showNativeView() async {
    String isNativeView;
    try {
      isNativeView = await platform.invokeMethod('showNativeView');
    } catch (e) {
      isNativeView = "Failed to showNativeView: '$e'.";
    }

    setState(() {
      _isNativeView = isNativeView;
    });
  }

  Future<void> _getException() async {
    String exceptionInfo;
    try {
      exceptionInfo = await platform.invokeMethod('getException');
    } on PlatformException catch (e) {
      exceptionInfo = "Failed PlatformException: '${e.message}'.";
    } catch (e) {
      exceptionInfo = "Failed Exception: '$e'.";
    }

    setState(() {
      _exceptionInfo = exceptionInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(title: const Text('原生溝通測試')),
        body: Center(
          child: ListView(
            padding: EdgeInsets.all(10),
            children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                          Icon(
                            Icons.battery_full,
                            color: Colors.grey,
                          ),
                          Text(_batteryLevel),
                        ]),
                        
                        ElevatedButton(
                          onPressed: _getBatteryLevel,
                          child: const Text('電池狀態'),
                        ),
                      ]),
                ),
              ),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            label: Text("標題"),
                            suffixIcon: IconButton(
                              onPressed: _notficationTitle.clear,
                              icon: Icon(Icons.clear),
                            ),
                          ),
                          controller: _notficationTitle,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        TextField(
                          decoration: InputDecoration(
                            label: Text("內容"),
                            suffixIcon: IconButton(
                              onPressed: _notficationDetail.clear,
                              icon: Icon(
                                Icons.clear,
                              ),
                            ),
                          ),
                          controller: _notficationDetail,
                        ),
                        Text(_notificationInfo),
                        ElevatedButton(
                          onPressed: _getNotfication,
                          child: const Text('發送通知'),
                        ),
                      ]),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(child: Text(_exceptionInfo)),
                        ElevatedButton(
                          onPressed: _getException,
                          child: const Text('原生端找不到func'),
                        ),
                      ]),
                ),
              ),
              ElevatedButton(
                onPressed: _showNativeView,
                child: const Text('顯示子母畫面'),
              ),
              Text(_isNativeView),
            ],
          ),
        ),
      ),
    );
  }
}
