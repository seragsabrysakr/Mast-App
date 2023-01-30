import 'package:flutter/material.dart';
import 'package:mast/app/extensions.dart';
import 'package:mast/app/text_style.dart';

class HomeTitle extends StatelessWidget {
  final String title;
  const HomeTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Text(
        title,
        style: AppTextStyle.getBoldStyle(color: Colors.black, fontSize: 15.sp),
      ),
    );
  }
}
