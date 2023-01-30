import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mast/data/model/auth/user_model.dart';

import '../../../app/constants.dart';

@injectable
class AppPreferences {
  final String _isDarkMode = 'isDarkMode';
  final String _lang = 'lang';
  final String _isLogin = 'isLogin';
  final String _userData = 'userData';
  final String _token = 'token';
  final String _showNotification = 'showNotification';
  final String _firebaseToken = 'firebaseToken';

  final String _isLanguageSelected = 'isLanguageSelected';

  final SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);

  Future<bool> _putData(String key, dynamic value) async {
    if (value is String) return await _sharedPreferences.setString(key, value);
    if (value is int) return await _sharedPreferences.setInt(key, value);
    return await _sharedPreferences.setBool(key, value);
  }

  dynamic _getData(String key, dynamic def) {
    var value = _sharedPreferences.get(key);
    return value ?? def;
  }

  Future<bool> remove(String key) async {
    return await _sharedPreferences.remove(key);
  }

  bool get showNotification => _getData(_showNotification, true);

  set showNotification(bool value) {
    _putData(_showNotification, value);
  }

// language
  String get lang => _getData(_lang, Constants.defaultLanguage);

  set lang(String value) {
    _putData(_lang, value);
  }

//theme
  bool get isDarkMode => _getData(_isDarkMode, false);

  set isDarkMode(bool value) {
    _putData(_isDarkMode, value);
  }

//language selected
  bool get isLanguageSelected => _getData(_isLanguageSelected, false);

  set isLanguageSelected(bool value) {
    _putData(_isLanguageSelected, value);
  }

  String get token => _getData(_token, '');

  set token(String value) {
    _putData(_token, value);
  }

//is user login
  bool get isUserLogin => _getData(_isLogin, false);

  set isUserLogin(bool value) {
    _putData(_isLogin, value);
  }

//user data
  UserModel? get userDataModel {
    String data = _getData(_userData, "");
    if (data.isEmpty) return null;
    return UserModel.fromJson(jsonDecode(_getData(_userData, null)));
  }

  set userDataModel(UserModel? user) {
    _putData(_userData, jsonEncode(user));
  }

  //fireBase token
  String get firebaseToken => _getData(_firebaseToken, "");

  set firebaseToken(String value) {
    _putData(_firebaseToken, value);
  }
}
