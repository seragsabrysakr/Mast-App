import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:mast/app/notification/app_firebase.dart';

import 'app/bloc_observer.dart';
import 'app/di/di.dart';
import 'my_app.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await AppFirebase.initializeFireBase();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Future.delayed(const Duration(milliseconds: 500), () {
    FlutterNativeSplash.remove();
  });

  Bloc.observer = MyBlocObserver();
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) =>  MyApp(), // Wrap your app
    ),
  );
}
