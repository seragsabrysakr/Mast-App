import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import '../../data/storage/local/app_prefs.dart';
import '../../my_app.dart';
import '../di/di.dart';

class DateTimeHelper {

  static getDateWithMonthNameFromDate(DateTime date) {
    String l = getIt<AppPreferences>().lang;
    return DateFormat('dd MMMM yyyy', l).format(date);
  }


  static getDayNameFromDate(DateTime date) {
    String lang = getIt<AppPreferences>().lang;
    initializeDateFormatting("ar",null).then((_){});
    return DateFormat('EEEE', lang).format(date);
  }

  static getMonthNameFromDate(DateTime date) {
    String l = getIt<AppPreferences>().lang;
    return DateFormat('MMMM', l).format(date);
  }

  static String getDateWithMonthNameAndDayNameFromDate(DateTime date) {
    String l = getIt<AppPreferences>().lang;
    return DateFormat('EEEE, dd MMMM, yyyy', l).format(date);
  }

  static String formateDate(DateTime date) {
    // return DateFormat('yyyy-MM-dd').format(date);
    return DateFormat('dd-MM-yyyy').format(date);

  }

  static String getTimeFromDatetime(DateTime date) {
    //  String lang = getIt<AppPreferences>().getLanguage();
    // initializeDateFormatting("ar",null).then((_){});
    return DateFormat.Hm().format(date);
  }


  static timeSubstring(String time) {
    return time.substring(0, 5);
  }

  static getTimeType(String type) {
    String _type = type.toLowerCase();
    if (_type == "am") {
      return MyApp.tr.am;
    }
    return MyApp.tr.pm;
  }

  static getTimeTypeFromHour(int hour) {
    if (hour < 12) {
      return MyApp.tr.am;
    }
    return MyApp.tr.pm;
  }
}