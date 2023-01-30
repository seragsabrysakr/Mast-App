import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mast/app/app_assets.dart';
import 'package:mast/app/app_router.dart';
import 'package:mast/app/di/di.dart';
import 'package:mast/data/storage/local/app_prefs.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String id = 'SplashScreen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String getInitialRoute() {
    var appPref = getIt<AppPreferences>();
    if (!appPref.isUserLogin) {
      return AppRouter.loginScreen;
    }

    print(appPref.token);
    return AppRouter.mainScreen;
  }

  void startApp() {
    String initialRoute = getInitialRoute();
    Navigator.of(context).pushNamedAndRemoveUntil(initialRoute, (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    Timer(const Duration(milliseconds: 1500), () {
      startApp();
    });

    super.initState();
  }

  bool lottieAnimate = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          AppAssets.splashScreen,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
