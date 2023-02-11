import 'package:mast/my_app.dart';

class Validations {
  static String? emailValidation(String? value) {
    String pattern = r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return MyApp.tr.emailEmptyValidation;
    }
    if (value.contains(' ')) {
      return MyApp.tr.removeMailSpace;
    }
    if (!regex.hasMatch(value)) {
      return MyApp.tr.emailValidation;
    } else {
      return null;
    }
  }

  static String? descriptionValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجي ادخال الوصف';
    } else {
      return null;
    }
  }

  static String? urlValidation(String value) {
    String pattern =
        r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'يرجي ادخال رابط المتجر';
    } else if (!regExp.hasMatch(value)) {
      return 'رابط المتجر غير صحيح';
    }
    return null;
  }

  static bool isEmailValid(String? email) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email ?? '');
  }

  static bool isPhoneValid(String? input) =>
      RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$').hasMatch(input ?? '');

  static String? passwordValidation(String? value) {
    // RegExp regex =
    // RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    RegExp regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    if (value == null || value.isEmpty) {
      return MyApp.tr.passwordEmptyValidation;
    } else if (value.length < 8) {
      return ' كلمة المرور يجب ان تكون اكثر من 8 احرف او ارقام';
    } else {
      return null;
    }
  }

  static String? userNameValidation(String? value) {
    if (value == null || value.isEmpty) {
      return MyApp.tr.userNameEmptyValidation;
    }
    if (value.length < 4) {
      return MyApp.tr.userNameValidation;
    } else {
      return null;
    }
  }

  static String? startPointValidation(String? value) {
    if (value == null || value.isEmpty) {
      return MyApp.tr.addStartPoint;
    } else {
      return null;
    }
  }

  static String? mobileValidation(String? value) {
    if (value == null || value.isEmpty) return MyApp.tr.phoneEmptyValidation;
    if (!value.startsWith('0')) {
      return MyApp.tr.phoneValidation;
    }

    if (value.length != 11) {
      return MyApp.tr.phoneValidation;
    } else {
      return null;
    }
  }

  static String? confirmValidation(String? value, String input) {
    if (value == null || value.isEmpty) {
      return MyApp.tr.confirmPasswordEmptyValidation;
    }
    if (value != input) {
      return MyApp.tr.confirmPasswordValidation;
    } else {
      return null;
    }
  }
}
