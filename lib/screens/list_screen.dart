import 'package:flutter/material.dart';
import 'package:honey_time/data/storeManager.dart';
import 'package:honey_time/screens/timer_screen.dart';
import 'package:honey_time/shared/menu_bottom.dart';
import 'package:uuid/uuid.dart';

import '../models/app_timer.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  TextEditingController txtCycles = TextEditingController();
  TextEditingController txtexercisesNb = TextEditingController();
  TextEditingController txtexerciseTimeInSec = TextEditingController();
  TextEditingController txtPauseBetweenexercises = TextEditingController();
  TextEditingController txtPauseBetweenCycles = TextEditingController();
  StoreManager storeManager = StoreManager();
  List<AppTimer> timers = [];

  @override
  void initState() {
    storeManager.init().then((value) => updateScreen());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('Timers'),
      ),
      bottomNavigationBar: const MenuBottom(),
      body: ListView(
        children: getContent(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => {showSessionDialog(context)},
      ),
    );
  }

  List<Widget> getContent() {
    List<Widget> tiles = [];
    timers.forEach((timer) {
      tiles.add(Dismissible(
        key: UniqueKey(),
        onDismissed: (_) =>
            storeManager.delete(timer.id).then((_) => updateScreen()),
        child: ListTile(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TimerScreen(timer: timer),
                )),
            title: Text(
                "exercises: ${timer.exercisesNb} x ${timer.exerciseTimeInSec} / ${timer.pauseBetweenExercises}"),
            subtitle:
                Text("cycles: ${timer.cycles} / ${timer.pauseBetweenCycles}")),
      ));
    });
    return tiles;
  }

  Future<dynamic> showSessionDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Insert new Timer'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: txtexerciseTimeInSec,
                      decoration:
                          InputDecoration(hintText: 'exercise Time in sec'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: txtexercisesNb,
                      decoration:
                          InputDecoration(hintText: 'Number of exercises'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: txtPauseBetweenexercises,
                      decoration: InputDecoration(
                          hintText: 'Pause between exercises in sec'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: txtCycles,
                      decoration: InputDecoration(hintText: 'Number of Cycles'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: txtPauseBetweenCycles,
                      decoration: InputDecoration(
                          hintText: 'Pause between cycles in sec'),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      clearControls();
                    },
                    child: Text('Cancel')),
                ElevatedButton(onPressed: saveTimer, child: Text('Save')),
              ]);
        });
  }

  Future saveTimer() async {
    var uuid = Uuid();
    AppTimer newTimer = AppTimer(
        uuid.v4(),
        int.tryParse(txtCycles.text) ?? 0,
        int.tryParse(txtexercisesNb.text) ?? 0,
        int.tryParse(txtexerciseTimeInSec.text) ?? 0,
        int.tryParse(txtPauseBetweenexercises.text) ?? 0,
        int.tryParse(txtPauseBetweenCycles.text) ?? 0);
    await storeManager.write(newTimer).then((value) => updateScreen());

    clearControls();
    Navigator.pop(context);
  }

  void updateScreen() {
    timers = storeManager.getList();
    setState(() {});
  }

  void clearControls() {
    txtPauseBetweenexercises.clear();
    txtPauseBetweenCycles.clear();
    txtCycles.clear();
    txtexercisesNb.clear();
    txtexerciseTimeInSec.clear();
  }
}
