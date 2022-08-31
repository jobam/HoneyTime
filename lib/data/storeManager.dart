import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/timer.dart';

class StoreManager {
  static late SharedPreferences prefs;

  Future init() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future write(Timer timer) async {
    prefs.setString(timer.id, json.encode(timer.toJson()));
  }

  Timer get(String id) {
    return Timer.fromJson(json.decode(prefs.getString(id) ?? ''));
  }

  List<Timer> getList() {
    List<Timer> timers = [];
    Set<String> keys = prefs.getKeys();

    keys.forEach((key) {
      Timer session =
      Timer.fromJson(json.decode(prefs.getString(key) ?? ''));
      if (session.id != "") {
        timers.add(session);
      }
    });

    return timers;
  }

  Future delete(String id) async{
    await prefs.remove(id);
  }
}
