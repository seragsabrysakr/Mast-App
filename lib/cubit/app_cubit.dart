import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mast/app/di/module/dio_module.dart';
import 'package:mast/data/storage/local/app_prefs.dart';

import '../app/constants.dart';
import '../app/di/di.dart';

part 'app_state.dart';

@injectable
class AppCubit extends Cubit<AppState> {
  final AppPreferences appPreferences;
  late Locale locale;
  late bool isDark;

  AppCubit(this.appPreferences) : super(AppInitial()) {
    isDark = appPreferences.isDarkMode;
    locale = Locale(appPreferences.lang);
  }

  static AppCubit get(BuildContext context) => context.read<AppCubit>();

  bool get isArSelected => locale.languageCode == Constants.arLanguage;

  void changeLang(String lang) {
    locale = Locale(lang);
    appPreferences.lang = lang;
    getIt<Dio>().updateHeader(appPreferences);
    appPreferences.isLanguageSelected = true;
    emit(ChangeLanguage());
  }

  void changeTheme({bool? isDark}) {
    this.isDark = isDark ?? !this.isDark;
    appPreferences.isDarkMode = this.isDark;
    emit(ChangeTheme());
  }
}
