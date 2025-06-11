import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gyro_race/views/start_screen.dart';

void main() {
  runApp(const MainApp());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StartScreen()
    );
  }
}
