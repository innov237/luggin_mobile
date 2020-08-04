import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class PreferenceStorage {
  // static const String STORAGE_KEY = 'USERDATA';

  static Future<bool> saveDataToPreferences(key, value) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    return sharedPreferences.setString(key, value);
  }

  static Future<String> getDataFormPreferences(key) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    return sharedPreferences.getString(key);
  }

  static Future<bool> cleanReferences(key) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.remove(key);
    return true;
  }
}
