class AppAssets {
  static const String iconsPath = "assets/icons/";
  static const String imagesPath = "assets/images/";
  static const String splashScreen = "assets/splash.png";

  /// SVG icons
  static String icHomeSearch = "${iconsPath}search.svg";
  static String icEmail = "${iconsPath}email.svg";
  static String icDelete = "${iconsPath}delete.svg";
  static String icAt = "${iconsPath}at.svg";
  static String icHome = "${iconsPath}home.svg";
  static String icLanguage = "${iconsPath}language.svg";
  static String icProfile = "${iconsPath}profile.svg";
  static String icNotification = "${iconsPath}notification.svg";
  static String icCall = "${iconsPath}call.svg";
  static String icCamera = "${iconsPath}camera.svg";
  static String icTime = "${iconsPath}time.svg";
  static String icCalender = "${iconsPath}calender.svg";
  static String icNext = "${iconsPath}next.svg";
  static String icBack = "${iconsPath}back.svg";
  static String icPassword = "${iconsPath}password.svg";
  static String imResetPassword = "${imagesPath}reset_password.svg";
  static String imChangeUniversity = "${imagesPath}university.svg";
  static String imMap = "${imagesPath}map.svg";
  static String imEmail = "${imagesPath}email.svg";
  static String imOtp = "${imagesPath}otp.svg";
  static String callCenter = "${iconsPath}call_center.svg";

  /// App Images
  static String largeAppbarBg = "${imagesPath}large_appbar_bg.png";
  static String appLogo = "${iconsPath}app_icon.png";

  /// example to how make assets aware of app brightness
  // static String get homeHeaderBg =>
  //     MyApp.isDark ? '${imagesPath}updateprofile.png' : "${imagesPath}background2.png";
}

class JsonAssets {
  static const String jsonPath = "assets/json";
  static const String splash = "$jsonPath/splash.json";
  static const String loading = "$jsonPath/loading.json";
  static const String error = "$jsonPath/error.json";
  static const String empty = "$jsonPath/empty.json";
  static const String success = "$jsonPath/success.json";
}
