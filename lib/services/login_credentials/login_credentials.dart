import 'package:dispatch/const/debug_config.dart';
import 'package:dispatch/services/login_credentials/user_authentications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../../views/auth/login_screen.dart';

class LoginCredentials {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Save token
  Future<void> saveToken(String token) async {
    await _storage.write(key: "access_token", value: token);
  }

  // Read token
  Future<String> getToken() async {
    String? t = await _storage.read(key: "access_token");
    return t ?? '';
  }

  // Delete token
  Future<void> deleteToken() async {
    await _storage.delete(key: "access_token");
  }

  Future<void> userLogout() async {
    // final tokenBefore = await LoginCredentials().getToken();
    // DebugConfig.debugLog('Token before logout $tokenBefore');
    await LoginCredentials().deleteToken();
    await UserAuthentication().loadTokenFromStorage();
    // final tokenAfter = await LoginCredentials().getToken();
    // DebugConfig.debugLog('Token after logout $tokenAfter');
    Get.offAll(() => LogInScreen());//ZC1vcmRlciIsImVzaG9wLWludGVncmF0aW9uIiwiYWx
  }

}
