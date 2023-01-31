import 'package:flutter/material.dart';
import 'package:mast/app/app_assets.dart';
import 'package:mast/app/extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
class AppShow{
 static Future<Object?> animationDialog(BuildContext context, Widget screen) {
    return showGeneralDialog(
      context: context,
      barrierLabel: "withdraw",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, a1, a2) {
        return screen;
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
          Tween(begin: const Offset(0, 1), end: Offset.zero).animate(anim1),
          child: child,
        );
      },
    );
  }
  static ClipRRect buildImage(
      {required String img, double? height, double? width, String? placeHolder,BoxFit? fit}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(1.h),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1.h),
        ),
        height: height,
        width: width,
        child: CachedNetworkImage(
          color: Colors.grey.shade300,
          imageBuilder: (context, imageProvider) => Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1.h),
              border: Border.all(color: Colors.grey.shade200),
              image: DecorationImage(image: imageProvider, fit:fit?? BoxFit.cover),
            ),
          ),
          imageUrl: img,
          placeholder: (context, url) => Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade100,
                  blurRadius: 8,
                  offset: const Offset(2, 5), // Shadow position
                ),
              ],
              borderRadius: BorderRadius.circular(1.h),
              image: DecorationImage(
                  image: AssetImage(placeHolder ?? AppAssets.appLogo),
                  fit:fit?? BoxFit.contain),
            ),
            height: height,
            width: width,
          ),
          errorWidget: (context, url, error) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1.h),
              image: DecorationImage(
                  image: AssetImage(placeHolder ?? AppAssets.appLogo),
                  fit:fit?? BoxFit.contain),
            ),
            height: height,
            width: width,
          ),
        ),
      ),
    );
  }
}