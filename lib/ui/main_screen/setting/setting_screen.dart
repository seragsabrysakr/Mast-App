import 'package:flutter/material.dart';
import 'package:mast/app/app_colors.dart';
import 'package:mast/app/app_router.dart';
import 'package:mast/app/di/di.dart';
import 'package:mast/app/extensions.dart';
import 'package:mast/app/fuctions.dart';
import 'package:mast/data/storage/local/app_prefs.dart';
import 'package:mast/ui/main_screen/main_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool? notify = getIt<AppPreferences>().showNotification;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.h),
      child: Column(
        children: [
          buildNotifications(),
          buildLogOut(context),
        ],
      ),
    );
  }

  Column buildLogOut(BuildContext context) {
    bool login = getIt<AppPreferences>().isUserLogin == true;
    return Column(
      children: [
        SizedBox(
          height: 2.h,
        ),
        InkWell(
          onTap: () {
            _logout(context);
          },
          child: Row(
            children: [
              Text(
                login ? 'تسجيل الخروج' : 'تسجيل الدخول',
                style: TextStyle(
                  color: !login ? Colors.black : Colors.red,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(
                flex: 1,
              ),
              login
                  ? CircleAvatar(
                      backgroundColor: Colors.grey.shade100,
                      radius: 4.w,
                      child: Icon(
                        Icons.logout,
                        color: Colors.red,
                        size: 4.w,
                      ),
                    )
                  : Icon(
                      Icons.arrow_forward_ios,
                      size: 12.sp,
                    ),
              SizedBox(
                width: 3.w,
              )
            ],
          ),
        ),
      ],
    );
  }

  Column buildNotifications() {
    return Column(
      children: [
        SizedBox(
          height: 2.h,
        ),
        Row(
          children: [
            Text(
              'الاشعارات',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(
              flex: 1,
            ),
            Transform.scale(
              scale: .8,
              child: Checkbox(
                  activeColor: AppColors.primaryColor,
                  value: notify,
                  onChanged: (val) {
                    setState(() {
                      notify = val;
                      getIt<AppPreferences>().showNotification =
                          !getIt<AppPreferences>().showNotification;
                    });
                  }),
            )
          ],
        ),
      ],
    );
  }

  _logout(context) {
    getIt<AppPreferences>().isUserLogin = false;
    getIt<AppPreferences>().remove('token');
    dPrint(getIt<AppPreferences>().token);
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        Navigator.pushNamedAndRemoveUntil(
            MainScreen.mainContext, AppRouter.loginScreen, (route) => false));
  }
}
