import 'dart:convert';

import 'package:fitness_tracker/data/model/user_goals_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static SharedPreferencesService? _instance;
  static late SharedPreferences _preferences;

  SharedPreferencesService._();

  // Using a singleton pattern
  static Future<SharedPreferencesService> getInstance() async {
    _instance ??= SharedPreferencesService._();

    _preferences = await SharedPreferences.getInstance();

    return _instance!;
  }

  UserGoalsModel? getData(String key) {
    // Retrieve data from shared preferences
    String? data = _preferences.getString(key);
    UserGoalsModel? value;

    if (data != null) {
      value = UserGoalsModel.fromJson(jsonDecode(data));
    }

    return value;
  }

  void saveData(String key, UserGoalsModel value) {
      _preferences.setString(key, jsonEncode(value.toJson()));
  }
}