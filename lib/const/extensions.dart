import 'package:flutter/cupertino.dart';

import 'app_strings.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }

  String? isValidPassword(String v){
    if (v.isEmpty) {
      return AppStrings.required;
    }
    // Perform custom password validation here
    if (v.length < 8 ||
        !v.contains(RegExp(r'[A-Z]')) ||
        !v.contains(RegExp(r'[a-z]')) ||
        !v.contains(RegExp(r'[0-9]')) ||
        !v.contains(RegExp(r'[!@#\$%^&*()<>?/|}{~:]'))) {
      return "Password must be at least 8 characters and include at least one uppercase letter, one lowercase letter, one number, and one special character.";
    }

    return null; // Password is valid.
  }
}