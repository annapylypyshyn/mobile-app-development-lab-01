import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  Future<void> saveJson(String key, Object value) async {
    final prefs = await SharedPreferences.getInstance();

    final jsonString = jsonEncode(value);

    await prefs.setString(key, jsonString);
  }

  Future<dynamic> readJson(String key) async {
    final prefs = await SharedPreferences.getInstance();

    final jsonString = prefs.getString(key);

    if (jsonString == null) {
      return null;
    }

    return jsonDecode(jsonString);
  }

  Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(key);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();
  }
}
