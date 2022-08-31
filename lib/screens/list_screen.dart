import 'package:flutter/material.dart';
import 'package:honey_time/data/storeManager.dart';
import 'package:uuid/uuid.dart';

import '../models/timer.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  TextEditingController txtCycles = TextEditingController();
  TextEditingController txtExercicesNb = TextEditingController();
  TextEditingController txtExerciceTimeInSec = TextEditingController();
  TextEditingController txtPauseBetweenExercices = TextEditingController();
  TextEditingController txtPauseBetweenCycles = TextEditingController();
  StoreManager storeManager = StoreManager();
  List<Timer> timers = [];

  @override
  void initState() {
    storeManager.Init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Timers'),
      ),
      body: ListView(
        children: [Container()],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => {showSessionDialog(context)},
      ),
    );
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
                      controller: txtExerciceTimeInSec,
                      decoration:
                          InputDecoration(hintText: 'Exercice Time in sec'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: txtExercicesNb,
                      decoration:
                          InputDecoration(hintText: 'Number of Exercices'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: txtPauseBetweenExercices,
                      decoration: InputDecoration(
                          hintText: 'Pause between exercices in sec'),
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
                ElevatedButton(onPressed: saveSession, child: Text('Save')),
              ]);
        });
  }

  Future saveSession() async {
    var uuid = Uuid();
    DateTime now = DateTime.now();
    Timer newTimer = Timer(
        uuid.v4(),
        int.tryParse(txtCycles.text) ?? 0,
        int.tryParse(txtExercicesNb.text) ?? 0,
        int.tryParse(txtExerciceTimeInSec.text) ?? 0,
        int.tryParse(txtPauseBetweenExercices.text) ?? 0,
        int.tryParse(txtPauseBetweenCycles.text) ?? 0);
    await storeManager.write(newTimer).then((value) => updateScreen());

    txtPauseBetweenCycles.clear();
    clearControls();
    Navigator.pop(context);
  }

  void updateScreen() {
    timers = storeManager.getList();
    setState(() {});
  }

  void clearControls() {
    txtPauseBetweenExercices.clear();
    txtPauseBetweenCycles.clear();
    txtCycles.clear();
    txtExercicesNb.clear();
    txtExerciceTimeInSec.clear();
  }
}
