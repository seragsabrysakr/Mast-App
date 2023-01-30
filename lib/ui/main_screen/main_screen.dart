import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mast/app/app_colors.dart';
import 'package:mast/app/app_router.dart';
import 'package:mast/app/extensions.dart';
import 'package:mast/app/text_style.dart';
import 'package:mast/ui/main_screen/cubit/main_screen_cubit.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class MainScreen extends StatefulWidget {
  static late BuildContext mainContext;
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late PersistentTabController _controller;

  @override
  void initState() {
    _controller = PersistentTabController(initialIndex: 0);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MainScreen.mainContext = context;
    return BlocProvider(
        create: (context) => MainScreenCubit(),
        child: BlocConsumer<MainScreenCubit, MainScreenState>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = MainScreenCubit.get(context);
            List<PersistentBottomNavBarItem> items = List.generate(
              cubit.iconList.length,
              (index) => PersistentBottomNavBarItem(
                // textStyle: AppTextStyle.getBoldStyle(color: Colors.black),
                icon: Icon(cubit.iconList[index]),
                title: cubit.titles[index],
                activeColorPrimary: Colors.yellow,
                inactiveColorPrimary: CupertinoColors.systemGrey,
                routeAndNavigatorSettings: const RouteAndNavigatorSettings(
                  onGenerateRoute: AppRouter.generatedRoute,
                ),
              ),
            );
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.yellow,
                  centerTitle: true,
                  toolbarHeight: 6.h,
                  title: Text(
                    cubit.titles[cubit.selectedIndex],
                    style: AppTextStyle.getBoldStyle(
                        color: AppColors.blackColor, fontSize: 12.sp),
                  ),
                ),
                body: PersistentTabView(
                  context,
                  controller: _controller,
                  screens: cubit.screens,
                  items: items,
                  onItemSelected: (index) {
                    setState(() {
                      cubit.selectedIndex = index;
                    });
                  },
                  confineInSafeArea: true,
                  backgroundColor: Colors.white, // Default is Colors.white.
                  handleAndroidBackButtonPress: true, // Default is true.
                  resizeToAvoidBottomInset:
                      true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
                  stateManagement: true, // Default is true.
                  hideNavigationBarWhenKeyboardShows:
                      true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
                  decoration: NavBarDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    colorBehindNavBar: Colors.white,
                  ),
                  popAllScreensOnTapOfSelectedTab: true,
                  popActionScreens: PopActionScreensType.all,
                  itemAnimationProperties: const ItemAnimationProperties(
                    // Navigation Bar's items animation properties.
                    duration: Duration(milliseconds: 100),
                    curve: Curves.ease,
                  ),
                  screenTransitionAnimation: const ScreenTransitionAnimation(
                    // Screen transition animation on change of selected tab.
                    animateTabTransition: true,
                    curve: Curves.ease,
                    duration: Duration(milliseconds: 100),
                  ),
                  navBarStyle: NavBarStyle
                      .neumorphic, // Choose the nav bar style with this property.
                ));
          },
        ));
  }
}
