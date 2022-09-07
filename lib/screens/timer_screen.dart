import 'package:flutter/material.dart';

import '../models/timer.dart';
import '../shared/menu_bottom.dart';

class TimerScreen extends StatefulWidget {
  final Timer timer;

  const TimerScreen({Key? key, required this.timer}) : super(key: key);

  @override
  State<TimerScreen> createState() => _TimerScreenState(timer);
}

class _TimerScreenState extends State<TimerScreen>
    with TickerProviderStateMixin {
  late AnimationController timerController;

  int currentExerciseNb = 1;
  int currentCycleNb = 1;

  bool isExercise = true;

  Timer timer;

  _TimerScreenState(this.timer) {}

  @override
  void initState() {
    timerController = AnimationController(
        vsync: this,
        duration: Duration(seconds: timer.exerciseTimeInSec),
        value: 100)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          timerEndHandler();
          setState(() {});
        }
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Timer'),
      ),
      bottomNavigationBar: const MenuBottom(),
      body: Container(
        height: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Flex(
                direction: Axis.vertical,
                children: [
                  SizedBox(
                      width: 200,
                      height: 200,
                      child: CircularProgressIndicator(
                        strokeWidth: 15,
                        value: timerController.value,
                        semanticsLabel: 'Circular progress indicator',
                      )),
                  Container(
                    transform: Matrix4.translationValues(0.0, -138.0, 0.0),
                    child: Text(
                      (timerController.value *
                              (timerController.duration?.inSeconds ?? 0.0))
                          .toStringAsFixed(0),
                      style: TextStyle(fontSize: 60, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ]
                // Padding(
                //   padding: const EdgeInsets.all(20.0),
                //   child: Center(
                //     child: Row(
                //       children: [
                //         Column(
                //           children: [
                //             Text('Cycle: ${currentCycleNb}'),
                //             Text('Exercice: ${currentExerciseNb}'),
                //           ],
                //         ),
                //         Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: <Widget>[
                //
                //           ],
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => startTimer(timer.exerciseTimeInSec),
        tooltip: 'Start',
        child: const Icon(Icons.play_arrow),
      ),
    );
  }

  void startTimer(int duration) {
    timerController.value = 100;
    timerController.duration = Duration(seconds: duration);
    timerController.reverse();
  }

  void timerEndHandler() {
    if (currentCycleNb <= timer.cycles) {
      if (isExercise && currentExerciseNb < timer.exercisesNb) {
        isExercise = false;
        startTimer(timer.pauseBetweenExercises);
        return;
      }
      if (isExercise && currentExerciseNb >= timer.exercisesNb) {
        isExercise = false;
        if (currentCycleNb < timer.cycles) {
          startTimer(timer.pauseBetweenCycles);
        }
        return;
      }
      if (!isExercise && currentExerciseNb < timer.exercisesNb) {
        isExercise = true;
        currentExerciseNb++;
        startTimer(timer.exerciseTimeInSec);
        return;
      }
      if (!isExercise && currentExerciseNb >= timer.exercisesNb) {
        currentCycleNb++;
        if (currentCycleNb <= timer.cycles) {
          isExercise = true;
          currentExerciseNb = 1;
          startTimer(timer.exerciseTimeInSec);
        }
      }
    }
  }
}
