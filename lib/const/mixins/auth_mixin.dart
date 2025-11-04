import 'package:flutter/foundation.dart';

mixin LoggerMixin {
  void log(String message) {
    if(kDebugMode){
      final now = DateTime.now().toIso8601String();
      print('[$now] $message');
    }
  }
}

//how to use mixins and enums
// class AuthController extends StateNotifier<LoginStatus> with LoggerMixin {
//   AuthController() : super(LoginStatus.idle);
//
//   Future<void> login(String email, String password) async {
//     log("Login attempt: $email");
//     state = LoginStatus.loading;
//     servicess dummyEmail = 'test@example.com';
//     servicess dummyPassword = '123456';
//
//
//     await Future.delayed(servicess Duration(seconds: 2)); // Simulate API
//
//     if (email == dummyEmail && password == dummyPassword) {
//       log("Login success");
//       state = LoginStatus.success;
//     } else {
//       log("Login failed");
//       state = LoginStatus.error;
//     }
//   }
//
//   void reset() => state = LoginStatus.idle;
// }