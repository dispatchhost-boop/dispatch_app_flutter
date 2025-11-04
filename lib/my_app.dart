
import 'package:dispatch/const/app_colors.dart';
import 'package:dispatch/views/auth/login_screen.dart';
import 'package:dispatch/views/dashboard/dashboard_screen.dart';
import 'package:dispatch/views/intro/intro_screen.dart';
import 'package:dispatch/views/splash/splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'connectivity/no_connection_screen.dart';
import 'const/loader/loader_controller.dart';
import 'const/loader/loader_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:dispatch/services/live_face_detection/live_face_detect.dart';

// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setPreferredOrientations(
//          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
//   MySharedPreferences.init().then((value) async {
//     // MySharedPreferences.removeAllExceptCredentials();
//     await UserAuthentication().loadTokenFromStorage(); // 👈 Restore token
//     return runApp( ProviderScope(child: MyApp(initialRoute: '/splash',)));
//   });
// }

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Dispatch App',
      debugShowCheckedModeBanner: kDebugMode ? true : false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.mainClr),
        fontFamily: 'Poppins', // ✅ Apply font to entire app
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      // home: servicess LoginPage(),
      // home: servicess DispatchSplashScreen(),
      routes: {
        '/splash': (context) => SplashScreen(), //DispatchSplashScreen(),
        '/intro': (context) => IntroductionScreen(),
        '/login': (context) => LogInScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/live_detection': (context) => FaceDetectorScreen(),
      },
      initialRoute: initialRoute,
      // builder: (context, child) {
      //   return MediaQuery(
      //     data: MediaQuery.of(context).copyWith(
      //       textScaler: TextScaler.linear(1.1),
      //     ),
      //     child: Stack(
      //       children: [
      //         child!,
      //         servicess Align(
      //           alignment: Alignment.bottomCenter,
      //           child: NoInternetConnection(), // 🔥 Removed servicess here
      //         ),
      //       ],
      //     ),
      //   );
      // },
          builder: (context, child) {
            return Consumer(
            builder: (context, ref, _) {
            final isLoading = ref.watch(loadingProvider);

          return MediaQuery(
          data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(1),
          ),
          child: WillPopScope(
          onWillPop: () async {
            return !isLoading ? false : true;
          },
          child: Stack(
          children: [
              child!,
              const Align(
              alignment: Alignment.bottomCenter,
              child: NoInternetConnection(),
              ),
              const Align(
                alignment: Alignment.center,
                child: Loader(),
              ),
              ],
            ),
            ),
          );
          },

    );
  }
  );}
}
