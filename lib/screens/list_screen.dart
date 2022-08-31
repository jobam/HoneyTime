import 'package:flutter/material.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      // Here we take the value from the MyHomePage object that was created by
      // the App.build method, and use it to set our appbar title.
      title: Text('Timers'),
    ),
      body: ListView(
        children: getContent(),
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
              title: Text('Insert Training Session'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: descTxtCtrl,
                      decoration: InputDecoration(hintText: 'Description'),
                    ),
                    TextField(
                      controller: durationTxtCtrl,
                      keyboardType: TextInputType.number,
                      autocorrect: true,
                      decoration: InputDecoration(hintText: 'Duration'),
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      descTxtCtrl.text = '';
                      durationTxtCtrl.text = '';
                    },
                    child: Text('Cancel')),
                ElevatedButton(onPressed: saveSession, child: Text('Save')),
              ]);
        });
  }


}
