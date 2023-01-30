import 'package:flutter/material.dart';
import 'package:mast/app/app_colors.dart';
import 'package:mast/app/extensions.dart';
import 'package:mast/app/text_style.dart';

class CustomButton extends StatelessWidget {
  final double width;
  final String text;
  final VoidCallback? onTap;
  final double radius;
  final double height;
  final double fontsize;
  final FontWeight fontweight;
  final Color butcolor;
  final Color borderColor;
  final Widget? icon;
  final Color txtcolor;
  const CustomButton(
      {required this.text,
      this.height = 6.4,
      this.width = 80,
      this.butcolor = AppColors.primaryColor,
      this.fontsize = 13,
      required this.onTap,
      this.radius = 15,
      Key? key,
      this.txtcolor = Colors.white,
      this.fontweight = FontWeight.w600,
      this.icon,
      this.borderColor = AppColors.primaryColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height.h,
      width: width.w,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(width: .01.w, color: borderColor),
        borderRadius: BorderRadius.circular(radius.h),
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(butcolor),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              side: BorderSide(color: borderColor, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(radius.h)),
            ),
          ),
          padding:
              MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
          elevation: MaterialStateProperty.resolveWith<double>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return 0;
            }
            if (states.contains(MaterialState.focused)) {
              return 0;
            }
            if (states.contains(MaterialState.hovered)) {
              return 0;
            }
            return 0;
          }),
        ),
        onPressed: onTap,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                text,
                style: AppTextStyle.getBoldStyle(
                  color: txtcolor,
                  fontSize: fontsize,
                ),
              ),
              if (icon != null) ...[
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 3.w, top: .5.h),
                  child: icon,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
