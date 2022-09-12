import 'package:flutter/material.dart';
import 'package:honey_time/screens/list_screen.dart';
import 'package:honey_time/screens/timer_screen.dart';

import 'models/app_timer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Honey Time',
        theme: ThemeData(
          primarySwatch: Colors.blue
        ),
        routes: {
          '/': (context) => TimerScreen(timer:AppTimer.DEFAULT_TIMER),
          '/list': (context) => ListScreen(),
        },
        initialRoute: '/list');
  }
}
