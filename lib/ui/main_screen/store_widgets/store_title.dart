import 'package:flutter/material.dart';
import 'package:mast/app/extensions.dart';
import 'package:mast/app/text_style.dart';

class StoreTitle extends StatelessWidget {
  final String title;
  final Color color;
  const StoreTitle({Key? key, required this.title, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyle.getBoldStyle(color: color, fontSize: 15.sp),
    );
  }
}
