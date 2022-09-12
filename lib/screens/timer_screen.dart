import 'package:audioplayers/audioplayers.dart';
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

  final int soundDuration = 3;
  int currentExerciseNb = 1;
  int currentCycleNb = 1;

  bool isExercise = true;
  bool isSoundPlaying = false;

  Timer timer;

  _TimerScreenState(this.timer) {}

  @override
  void initState() {
    timerController = AnimationController(
        vsync: this,
        duration: Duration(seconds: timer.exerciseTimeInSec),
        value: 1)
      ..addListener(() {
        var threeSecsValue = soundDuration /
            (timerController.duration?.inSeconds ?? soundDuration);
        if (!isSoundPlaying &&
            timerController.value.toStringAsPrecision(1) ==
                threeSecsValue.toString()) {
          playSound();
        }
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
        title: const Text('Timer'),
      ),
      bottomNavigationBar: const MenuBottom(),
      body: Container(
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
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
                ]),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      'Exercise : ${currentExerciseNb} / ${timer.exercisesNb}',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      'Cycle : ${currentCycleNb} / ${timer.cycles}',
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          currentCycleNb = 1;
          currentExerciseNb = 1;
          return await startTimer(timer.exerciseTimeInSec);
        },
        tooltip: 'Start',
        child: const Icon(Icons.play_arrow),
      ),
    );
  }

  Future startTimer(int duration) async {
    isSoundPlaying = false;
    if (duration == soundDuration) {
      playSound();
    }
    timerController.value = 100;
    timerController.duration = Duration(seconds: duration);
    timerController.reverse();
  }

  Future playSound() async {
    isSoundPlaying = true;
    AudioPlayer player = AudioPlayer();
    await player.setSource(AssetSource('audio/count_down.wav'));
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
