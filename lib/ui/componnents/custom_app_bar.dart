// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:mast/app/app_colors.dart';
import 'package:mast/app/extensions.dart';
import 'package:mast/app/text_style.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  List<Widget>? actions;
  Widget? leading;

  CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      toolbarHeight: 6.h,
      title: Text(
        title,
        style: AppTextStyle.getBoldStyle(color: AppColors.blackColor, fontSize: 12.sp),
      ),
      actions: actions ?? [],
      leading: leading,
    );
  }
}
