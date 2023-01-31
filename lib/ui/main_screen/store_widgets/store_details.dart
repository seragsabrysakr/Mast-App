import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mast/app/app_colors.dart';
import 'package:mast/app/app_sized_box.dart';
import 'package:mast/app/extensions.dart';
import 'package:mast/app/text_style.dart';
import 'package:mast/data/model/home/store_model.dart';
import 'package:mast/ui/componnents/app_show.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class StoreDetails extends StatelessWidget {
  final StoreModel store;

  const StoreDetails({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          centerTitle: true,
          title: Text(
            store.title ?? '',
            style: AppTextStyle.getBoldStyle(color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppShow.buildImage(height: 30.h, width: 100.w, img: store.image ?? ''),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        buildChip('اسم المتجر'),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            store.title ?? '',
                            style: AppTextStyle.getRegularStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        buildChip('نوع المتجر'),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            store.type ?? '',
                            style: AppTextStyle.getRegularStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                buildChip('الوصف'),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Text(
                    store.description ?? '',
                    textAlign: TextAlign.justify,
                    style: AppTextStyle.getRegularStyle(color: Colors.grey),
                  ),
                ),
                AppSizedBox.h1,

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        buildChip('التقييم'),
                        AppSizedBox.h1,
                        RatingBarIndicator(
                          rating: store.avgRating?.toDouble() ?? 0,
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.yellow,
                          ),
                          unratedColor: Colors.grey,
                          itemCount: 5,
                          itemSize: 15.sp,
                          direction: Axis.horizontal,
                        ),
                        AppSizedBox.h1,
                        Text(
                          '(${int.parse(store.ratingCount.toString())})',
                          style: AppTextStyle.getRegularStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                AppSizedBox.h1,
                SizedBox(
                  height: ((store.ratings?.length??0) * 8.2).h,
                  child: ListView.separated(
                    itemBuilder: (context, index) => buildRate(store.ratings?[index]),
                    separatorBuilder: (context, index) => AppSizedBox.h1,
                    itemCount: store.ratings?.length ?? 0,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildChip('زيارة صفحة المتجر'),
                    TextButton(
                        onPressed: ()async {
                          await _launchInBrowser(store.url ?? '');
                        },
                        child: Text(
                          'اضغط هنا',
                          style: AppTextStyle.getRegularStyle(color: Colors.blue),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Container buildRate(Rating? ratings) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: 90.w,
      height: 8.h,
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Text(
            ratings?.comment ?? '',
            textAlign: TextAlign.justify,
            style: AppTextStyle.getRegularStyle(color: Colors.grey),
          ),
          RatingBarIndicator(
            rating: double.parse(ratings?.rating?.toString() ?? '0.0') ?? 0,
            itemBuilder: (context, index) => const Icon(
              Icons.star,
              color: Colors.yellow,
            ),
            unratedColor: Colors.grey,
            itemCount: 5,
            itemSize: 15.sp,
            direction: Axis.horizontal,
          ),
        ],
      ),
    );
  }

  Chip buildChip(String title) {
    return Chip(
        backgroundColor: AppColors.primaryColor,
        label: Text(
          title,
          style: AppTextStyle.getRegularStyle(color: Colors.black),
        ));
  }
  Future<void> _launchInBrowser(String url) async {
    final UrlLauncherPlatform launcher = UrlLauncherPlatform.instance;
    if (await launcher.canLaunch(url)) {
      await launcher.launch(
        url,
        useSafariVC: false,
        useWebView: false,
        enableJavaScript: false,
        enableDomStorage: false,
        universalLinksOnly: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw Exception('Could not launch $url');
    }
  }

}
