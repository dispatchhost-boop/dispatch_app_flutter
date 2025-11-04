import 'package:dispatch/prefs/share_pref.dart';
import 'package:dispatch/services/flavor_config.dart';
import 'package:dispatch/services/login_credentials/user_authentications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'my_app.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  FlavorConfig(
    flavor: Flavor.DEV,
    values: FlavorValues(baseUrl: "http://192.168.1.62:8008/"),
  );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  MySharedPreferences.init().then((value) async {
    // MySharedPreferences.removeAllExceptCredentials();
    await UserAuthentication().loadTokenFromStorage(); // 👈 Restore token
    return runApp( ProviderScope(child: MyApp(initialRoute: '/splash',)));
  });
}