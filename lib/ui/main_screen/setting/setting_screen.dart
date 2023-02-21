import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mast/app/app_colors.dart';
import 'package:mast/app/app_router.dart';
import 'package:mast/app/di/di.dart';
import 'package:mast/app/extensions.dart';
import 'package:mast/app/fuctions.dart';
import 'package:mast/app/state_renderer/request_builder.dart';
import 'package:mast/app/state_renderer/state_renderer_impl.dart';
import 'package:mast/data/storage/local/app_prefs.dart';
import 'package:mast/ui/auth/login/delete_cubit.dart';
import 'package:mast/ui/main_screen/main_screen.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool? notify = getIt<AppPreferences>().showNotification;
  bool login = getIt<AppPreferences>().isUserLogin == true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.h),
      child: Column(
        children: [
          buildNotifications(),
          buildLogOut(context),
          if (login) buildDelete(context),
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

  showDia(BuildContext context, DeleteCubit cubit) {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      headerAnimationLoop: false,
      animType: AnimType.bottomSlide,
      btnCancelText: 'الغاء',
      btnOkText: 'حذف',
      title: 'حذف الحساب',
      desc: 'هل انت متاكد من حذف الحساب؟',
      buttonsTextStyle: const TextStyle(color: Colors.black),
      showCloseIcon: true,
      btnCancelOnPress: () {
        Navigator.of(context, rootNavigator: false).pop();
      },
      btnOkOnPress: () {
        cubit.deleteAcount();
      },
    ).show();
  }

  buildDelete(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DeleteCubit>(),
      child: RequestBuilder<DeleteCubit>(
          retry: (context, cubit) {},
          listener: (context, cubit) {
            if (cubit is SuccessState) {
              WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.pushNamedAndRemoveUntil(
                  MainScreen.mainContext, AppRouter.loginScreen, (route) => false));
            }
          },
          contentBuilder: (context, cubit) {
            return Column(
              children: [
                SizedBox(
                  height: 2.h,
                ),
                InkWell(
                  onTap: () {
                    showDia(context, cubit);
                  },
                  child: Row(
                    children: [
                      Text(
                        ' حذف الحساب',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.grey.shade100,
                        radius: 4.w,
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 4.w,
                        ),
                      ),
                      SizedBox(
                        width: 3.w,
                      )
                    ],
                  ),
                ),
              ],
            );
          }),
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
                      getIt<AppPreferences>().showNotification = true;
                      // !getIt<AppPreferences>().showNotification;
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
    WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.pushNamedAndRemoveUntil(
        MainScreen.mainContext, AppRouter.loginScreen, (route) => false));
  }
}
