import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _userAccelerometerValues = "";
  String _gyroscopeValues = "";
  double g_x = 0;
  double g_y = 0;
  double g_z = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text("デモページ"),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(_userAccelerometerValues),
            Text(_gyroscopeValues),
            Text("x: ${g_x.toStringAsFixed(2)}"),
            Text("y: ${g_y.toStringAsFixed(2)}"),
            Text("z: ${g_z.toStringAsFixed(2)}"),
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    userAccelerometerEventStream().listen(
      (UserAccelerometerEvent event) {
        setState(() {
          _userAccelerometerValues =
              "加速度センサー\n${event.x}\n${event.y}\n${event.z}";
        });
      },
    );
    gyroscopeEventStream().listen(
      (GyroscopeEvent event) {
        setState(() {
          g_x += event.x;
          g_y += event.y;
          g_z += event.z;
          _gyroscopeValues = "ジャイロセンサー\n${event.x}\n${event.y}\n${event.z}";
        });
      },
    );
  }
}
