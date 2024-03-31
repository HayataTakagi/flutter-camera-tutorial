import 'dart:math';

import 'package:aeyrium_sensor/aeyrium_sensor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  double pitch = 0;
  double pitch_ = 0;
  double roll = 0;
  double roll_ = 0;

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
            Text(
                "ジャイロ累積値\nx: ${g_x.toStringAsFixed(2)}\ny: ${g_y.toStringAsFixed(2)}\nz: ${g_z.toStringAsFixed(2)}"),
            Text(
                "pitch: ${pitch.toStringAsFixed(2)}\npitch_: ${pitch_.round()}\nroll: ${roll.toStringAsFixed(2)}\nroll_: ${roll_.round()}"),
            Container(
              transform: Matrix4.rotationZ(roll),
              transformAlignment: Alignment.center,
              child: Container(
                  width: 2000,
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.green)),
                  )),
            )
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
              "加速度センサー\nx:${event.x}\ny:${event.y}\nz:${event.z}";
        });
      },
    );
    gyroscopeEventStream().listen(
      (GyroscopeEvent event) {
        setState(() {
          g_x += event.x;
          g_y += event.y;
          g_z += event.z;
          _gyroscopeValues =
              "ジャイロセンサー\nx:${event.x}\ny:${event.y}\nz:${event.z}";
        });
      },
    );
    AeyriumSensor.sensorEvents?.listen((SensorEvent event) {
      //do something with the event , values expressed in radians
      // print("Pitch ${event.pitch} and Roll ${event.roll}");
      setState(() {
        pitch = event.pitch;
        pitch_ = event.pitch * 180 / pi;
        roll = event.roll;
        roll_ = event.roll * 180 / pi;
      });
    });
  }
}
