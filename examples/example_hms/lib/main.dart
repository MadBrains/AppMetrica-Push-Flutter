import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:appmetrica_push_huawei/appmetrica_push_huawei.dart';
import 'package:flutter/material.dart';
import 'package:huawei_analytics/huawei_analytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HMSAnalytics analytics = await HMSAnalytics.getInstance();
  await analytics.setAnalyticsEnabled(true);
  await analytics.enableLog();
  await analytics.enableLogger();
  print(await analytics.getAAID());

  await AppMetrica.activate(
      AppMetricaConfig('5dc43bd4-aecc-4163-b421-4e2c1cc4395b'));

  AppmetricaPushHuawei.instance.onMessage
      .listen((String data) => print('onMessage: $data'));
  AppmetricaPushHuawei.instance.onMessageOpenedApp
      .listen((String data) => print('onMessageOpenedApp: $data'));
  AppmetricaPushHuawei.instance.tokenStream
      .listen((Map<String, String?> data) => print('tokenStream: $data'));

  await AppmetricaPushHuawei.instance.activate();

  await AppmetricaPushHuawei.instance.requestPermission(PermissionOptions(
    alert: true,
    badge: true,
    sound: true,
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final Future<String> requestAppMetricaDeviceID =
      AppMetrica.requestAppMetricaDeviceID();
  late final Future<Map<String, String?>?> getTokens =
      AppmetricaPushHuawei.instance.getTokens();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('AppMetrica DeviceID:'),
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 8),
              child: FutureBuilder<String>(
                future: requestAppMetricaDeviceID,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (!snapshot.hasData || snapshot.hasError) {
                    return Text(snapshot.error?.toString() ?? 'null');
                  }

                  print('DeviceID: ${snapshot.data.toString()}');

                  return SelectableText(snapshot.data.toString());
                },
              ),
            ),
            const Text('Token:'),
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 8),
              child: FutureBuilder<Map<String, String?>?>(
                future: getTokens,
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, String?>?> snapshot) {
                  print('Token: ${snapshot.data.toString()}');
                  print('Token error: ${snapshot.error.toString()}');
                  print('Token stackTrace: ${snapshot.stackTrace.toString()}');

                  if (!snapshot.hasData || snapshot.hasError) {
                    return Text(snapshot.error?.toString() ?? 'null');
                  }
                  return SelectableText(snapshot.data.toString());
                },
              ),
            ),
            const Text('Token stream:'),
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 8),
              child: StreamBuilder<Map<String, String?>>(
                stream: AppmetricaPushHuawei.instance.tokenStream,
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, String?>> snapshot) {
                  print('Token stream: ${snapshot.data.toString()}');
                  print('Token stream error: ${snapshot.error.toString()}');
                  print(
                      'Token stream stackTrace: ${snapshot.stackTrace.toString()}');

                  if (!snapshot.hasData || snapshot.hasError) {
                    return Text(snapshot.error?.toString() ?? 'null');
                  }
                  return SelectableText(snapshot.data.toString());
                },
              ),
            ),
            const Text('onMessage stream:'),
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 8),
              child: StreamBuilder<String>(
                stream: AppmetricaPushHuawei.instance.onMessage,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (!snapshot.hasData || snapshot.hasError) {
                    return Text(snapshot.error?.toString() ?? 'null');
                  }
                  return SelectableText(snapshot.data.toString());
                },
              ),
            ),
            const Text('onMessageOpenedApp stream:'),
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 8),
              child: StreamBuilder<String>(
                stream: AppmetricaPushHuawei.instance.onMessageOpenedApp,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (!snapshot.hasData || snapshot.hasError) {
                    return Text(snapshot.error?.toString() ?? 'null');
                  }
                  return SelectableText(snapshot.data.toString());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
