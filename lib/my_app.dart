import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mast/app/app_colors.dart';

import 'app/app_router.dart';
import 'app/di/di.dart';
import 'cubit/app_cubit.dart';

class MyApp extends StatelessWidget {
  static late bool isDark;
  static late AppLocalizations tr;
  static late BuildContext appContext;
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AppCubit>()),
      ],
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, local) {
          var cubit = context.read<AppCubit>();
          _systemOverLay();
          return MaterialApp(
            theme: ThemeData(primarySwatch: Colors.green),
            useInheritedMediaQuery: true,
            debugShowCheckedModeBanner: false,
            // theme: Styles.themeData(false),
            onGenerateTitle: (context) {
              appContext = context;
              isDark = cubit.isDark;
              tr = AppLocalizations.of(context)!;
              return tr.appTitle;
            },
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: cubit.locale,
            onGenerateRoute: AppRouter.generatedRoute,
            initialRoute: AppRouter.splashScreen,
          );
        },
      ),
    );
  }

  void _systemOverLay() {
    return SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        // navigation bar color
        statusBarColor: AppColors.stateBarColor,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark // status bar color
        ));
  }
}
