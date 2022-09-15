import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:wakelock/wakelock.dart';

import '../models/app_timer.dart';
import '../shared/menu_bottom.dart';

class TimerScreen extends StatefulWidget {
  final AppTimer timer;

  const TimerScreen({Key? key, required this.timer}) : super(key: key);

  @override
  State<TimerScreen> createState() => _TimerScreenState(timer);
}

class _TimerScreenState extends State<TimerScreen>
    with TickerProviderStateMixin {
  late AnimationController timerController;
  final AudioPlayer player = AudioPlayer();
  late Timer soundTriggerTimer;

  final int soundDuration = 3;
  int currentExerciseNb = 1;
  int currentCycleNb = 1;

  bool isExercise = true;

  AppTimer timer;

  Color backGroundColor = Colors.white;
  Color spinnerColor = Colors.blue;

  _TimerScreenState(this.timer) {}

  @override
  void initState() {
    player.setAsset('assets/audio/count_down.flac');

    timerController = AnimationController(
        vsync: this,
        duration: Duration(seconds: timer.exerciseTimeInSec),
        value: 1)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) async {
        if (status == AnimationStatus.dismissed) {
          await timerEndHandler();
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
        color: backGroundColor,
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
                            color: spinnerColor,
                          )),
                      Container(
                        transform: Matrix4.translationValues(0.0, -138.0, 0.0),
                        child: Text(
                          (timerController.value *
                                  (timerController.duration?.inSeconds ?? 0.0))
                              .toStringAsFixed(0),
                          style: TextStyle(fontSize: 60, color: spinnerColor),
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
                      style: TextStyle(fontSize: 20, color: spinnerColor),
                    ),
                    Text(
                      'Cycle : ${currentCycleNb} / ${timer.cycles}',
                      style: TextStyle(fontSize: 20, color: spinnerColor),
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
          await Wakelock.enable();
          currentCycleNb = 1;
          currentExerciseNb = 1;
          setExerciseColor();
          return await startTimer(timer.exerciseTimeInSec);
        },
        tooltip: 'Start',
        backgroundColor: spinnerColor,
        child: Icon(Icons.play_arrow, color: backGroundColor),
      ),
    );
  }

  Future startTimer(int duration) async {
    timerController.value = 100;
    timerController.duration = Duration(seconds: duration);
    timerController.reverse();
    soundTriggerTimer =
        Timer(Duration(seconds: (duration - soundDuration)), playSound);
  }

  Future playSound() async {
    await player.seek(const Duration(microseconds: 0));
    await player.play();
  }

  Future timerEndHandler() async {
    if (currentCycleNb <= timer.cycles) {
      if (isExercise && currentExerciseNb < timer.exercisesNb) {
        isExercise = false;
        await startTimer(timer.pauseBetweenExercises);
        setPauseColor();
        return;
      }
      if (isExercise && currentExerciseNb >= timer.exercisesNb) {
        isExercise = false;
        if (currentCycleNb < timer.cycles) {
          await startTimer(timer.pauseBetweenCycles);
          setPauseColor();
        }
        return;
      }
      if (!isExercise && currentExerciseNb < timer.exercisesNb) {
        isExercise = true;
        currentExerciseNb++;
        await startTimer(timer.exerciseTimeInSec);
        setExerciseColor();
        return;
      }
      if (!isExercise && currentExerciseNb >= timer.exercisesNb) {
        currentCycleNb++;
        if (currentCycleNb <= timer.cycles) {
          isExercise = true;
          currentExerciseNb = 1;
          await startTimer(timer.exerciseTimeInSec);
          setExerciseColor();
        }
      }
    }
  }

  void setExerciseColor() {
    backGroundColor = Colors.deepOrangeAccent;
    spinnerColor = Colors.white;
    setState(() {});
  }

  void setPauseColor() {
    backGroundColor = Colors.white;
    spinnerColor = Colors.blue;
    setState(() {});
  }
}
