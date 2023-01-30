import 'package:flutter/material.dart';
import 'package:mast/data/model/auth/user_model.dart';
import 'package:mast/ui/auth/login/login_screen.dart';
import 'package:mast/ui/auth/otp/otp_screen.dart';
import 'package:mast/ui/auth/register/register_screen.dart';
import 'package:mast/ui/auth/splash_screen.dart';

import '../ui/main_screen/main_screen.dart';

class AppRouter {
  static const String splashScreen = "SplashScreen";
  static const String mainScreen = "mainScreen";
  static const String loginScreen = "loginScreen";
  static const String registerScreen = "RegisterScreen";
  static const String profileScreen = "ProfileScreen";
  static const String phoneVerificationScreen = "phoneVerificationScreen";

  static Route<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case mainScreen:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case registerScreen:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case phoneVerificationScreen:
        final user = settings.arguments as UserModel;
        return MaterialPageRoute(
            builder: (_) => PhoneVerificationScreen(user: user));

      default:
        return MaterialPageRoute(
            builder: (_) => const Center(
                  child: Text("Page Not Found"),
                ));
    }
  }
}
