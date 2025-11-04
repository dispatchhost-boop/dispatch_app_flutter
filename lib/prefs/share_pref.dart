import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../const/debug_config.dart';

class MySharedPreferences {
  static SharedPreferences? _prefs;

  static Future<SharedPreferences?> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs;
  }

  static String getString(String key, [String? defValue]) {
    return _prefs?.getString(key) ?? defValue ?? "";
  }

  static setString(String key, String value) async {
    return _prefs?.setString(key, value);
  }

  static bool getBool(String key) {
    return _prefs!.getBool(key) ?? false;
  }

  static setBool(String key, bool value) async {
    return _prefs!.setBool(key, value);
  }

  static setInt(String key, int value) {
    return _prefs!.setInt(key, value);
  }

  static getInt(String key) {
    return _prefs!.getInt(key);
  }

  // 🌟 Store a Map as JSON string
  static Future<void> setMap(String key, Map<String, dynamic> value) async {
    String jsonString = jsonEncode(value); // Convert Map to String
    await _prefs?.setString(key, jsonString);
  }

  // 🌟 Retrieve a Map from JSON string
  static Map<String, dynamic> getMap(String key) {
    String? jsonString = _prefs?.getString(key);
    if (jsonString == null || jsonString.isEmpty) {
      return {}; // return empty map if nothing stored
    }
    return jsonDecode(jsonString);
  }


  static remove(String key) {
    return _prefs!.remove(key);
  }

  static removeAll() {
    return _prefs?.clear();
  }

  static Future<void> removeAllLoginCredentials() async {
    // await MyDataBaseHandler.instance.deleteDatabaseTable();
    // _clearCacheAndTemporaryFiles();
    //
    // final keys = _prefs?.getKeys() ?? {};
    // const retainedKeys = {IS_SELECTED_LANG, IS_LANG_SAVE};
    //
    // for (String key in keys) {
    //   if (!retainedKeys.contains(key)) {
    //     await _prefs?.remove(key);
    //   }
    // }

    DebugConfig.debugLog("Remaining keys after logout: ${_prefs?.getKeys()}");
  }

  static Future<void> _clearCacheAndTemporaryFiles() async {
    // try {
    //   Directory tempDir = await getTemporaryDirectory();
    //   if (tempDir.existsSync()) {
    //     tempDir.deleteSync(recursive: true);
    //   }
    //
    //   Directory appDir = await getApplicationSupportDirectory();
    //   if (appDir.existsSync()) {
    //     appDir.deleteSync(recursive: true);
    //   }
    //
    //   print("Cache and temporary files cleared.");
    // } catch (e) {
    //   print("Error clearing cache: $e");
    // }
  }
}