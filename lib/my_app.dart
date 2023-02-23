import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mast/app/app_colors.dart';
import 'package:mast/data/request/store_request.dart';
import 'package:mast/ui/main_screen/home/store_cubit/get_stores_cubit.dart';
import 'package:mast/ui/main_screen/home/store_cubit/notification_cubit.dart';

import 'app/app_router.dart';
import 'app/di/di.dart';
import 'cubit/app_cubit.dart';
import 'ui/main_screen/home/store_cubit/special_stores_cubit.dart';
import 'ui/main_screen/home/store_cubit/top_stores_cubit.dart';

class MyApp extends StatelessWidget {
  static late bool isDark;
  static late AppLocalizations tr;
  static late BuildContext appContext;
  MyApp({Key? key}) : super(key: key);
  var request = StoreRequest(skip: 0, take: 10);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AppCubit>()),
        BlocProvider(create: (context) => getIt<GetStoresCubit>()),
        BlocProvider(create: (context) => getIt<NotificationCubit>()),
        BlocProvider(
          create: (context) => getIt<GetStoresCubit>()..getStores(request: request),
        ),
        BlocProvider(
          create: (context) => getIt<SpecialStoresCubit>()..getSpecialStores(request: request),
        ),
        BlocProvider(
          create: (context) => getIt<TopStoresCubit>()..getTopStores(request: request),
        ),
      ],
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, local) {
          var cubit = context.read<AppCubit>();
          _systemOverLay();
          return MaterialApp(
            theme: ThemeData(useMaterial3: true, primarySwatch: Colors.green),
            useInheritedMediaQuery: true,
            debugShowCheckedModeBanner: false,
            // theme: Styles.themeData(false),
            onGenerateTitle: (context) {
              appContext = context;
              isDark = cubit.isDark;
              tr = AppLocalizations.of(context)!;
              return 'Mast';
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
