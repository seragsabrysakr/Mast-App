import 'package:flutter/material.dart';
import 'package:mast/app/extensions.dart';
import 'package:mast/app/text_style.dart';

class StoreDescription extends StatelessWidget {
  final String description;
  final Color color;
  const StoreDescription(
      {Key? key, required this.description, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      maxLines: 3,
      style: AppTextStyle.getRegularStyle(
        color: color,
        fontSize: 13.sp,
      ),
    );
  }
}
