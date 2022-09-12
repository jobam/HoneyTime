import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_timer.dart';

class StoreManager {
  static late SharedPreferences prefs;

  Future init() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future write(AppTimer timer) async {
    prefs.setString(timer.id, json.encode(timer.toJson()));
  }

  AppTimer get(String id) {
    return AppTimer.fromJson(json.decode(prefs.getString(id) ?? ''));
  }

  List<AppTimer> getList() {
    List<AppTimer> timers = [];
    Set<String> keys = prefs.getKeys();

    keys.forEach((key) {
      AppTimer session =
      AppTimer.fromJson(json.decode(prefs.getString(key) ?? ''));
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
