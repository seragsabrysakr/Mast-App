import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mast/app/app_colors.dart';
import 'package:mast/app/text_style.dart';
import 'package:mast/ui/main_screen/home/home_screen.dart';
import 'package:mast/ui/main_screen/notification/all_stores.dart';
import 'package:mast/ui/main_screen/profile/profile_screen.dart';
import 'package:mast/ui/main_screen/setting/setting_screen.dart';

part 'main_screen_state.dart';

class MainScreenCubit extends Cubit<MainScreenState> {
  MainScreenCubit() : super(MainScreenInitial());
  static MainScreenCubit get(BuildContext context) =>
      context.read<MainScreenCubit>();

  int selectedIndex = 0;
  List<TabItem> tabItems = List.of([
    TabItem(
      Icons.home,
      "الرئيسية",
      AppColors.primaryColor,
      labelStyle: AppTextStyle.appBarTitleStyle,
      circleStrokeColor: Colors.black,
    ),
    TabItem(
      Icons.person,
      "الملف الشخصي",
      AppColors.primaryColor,
      labelStyle: AppTextStyle.appBarTitleStyle,
      circleStrokeColor: Colors.black,
    ),
    TabItem(
      Icons.notifications,
      "الاشعارات",
      AppColors.primaryColor,
      labelStyle: AppTextStyle.appBarTitleStyle,
      circleStrokeColor: Colors.black,
    ),
    TabItem(
      Icons.settings,
      "الاعدادات",
      AppColors.primaryColor,
      labelStyle: AppTextStyle.appBarTitleStyle,
      circleStrokeColor: Colors.black,
    ),
  ]);
  List<IconData> iconList = [
    Icons.home,
    Icons.person,
    Icons.menu,
    Icons.settings,
  ];
  List<Widget> screens = [
    HomeScreen(),
    const ProfileScreen(),
    const NotificationScreen(),
    const SettingScreen(),
  ];
  List<String> titles = [
    "الرئيسية",
    "الملف الشخصي",
    "كل المتاجر",
    "الاعدادات",
  ];

  changeIndex(int index) {
    selectedIndex = index;
    emit(ChangeIndexState());
  }
}
