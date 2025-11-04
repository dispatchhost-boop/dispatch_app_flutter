import 'package:flutter/foundation.dart';

class DebugConfig{

  static void debugLog(String message) {
    if (kDebugMode) {
      print('🔧 DEBUG: $message');
    }
  }

  // /// Executes a function only in debug mode
  // static void runIfDebug(void Function() callback) {
  //   if (kDebugMode) {
  //     callback();
  //   }
  // }

  static void logObject(Object object) {
    if (kDebugMode) {
      print('🧩 OBJECT: $object');
    }
  }
}