// ignore_for_file: must_be_immutable, unnecessary_getters_setters

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_card/image_card.dart';
import 'package:mast/app/app_sized_box.dart';
import 'package:mast/app/extensions.dart';
import 'package:mast/data/model/home/store_model.dart';
import 'package:mast/ui/componnents/custom_button.dart';
import 'package:mast/ui/main_screen/store_widgets/store_details.dart';
import 'package:mast/ui/main_screen/store_widgets/store_title.dart';

import '../../componnents/app_show.dart';

class StoreSlider extends StatefulWidget {
  StoreModel _store;

  StoreSlider({Key? key, required StoreModel store})
      : _store = store,
        super(key: key);

  @override
  State<StoreSlider> createState() => _StoreSliderState();
}

class _StoreSliderState extends State<StoreSlider> {
  StoreModel get store => widget._store;

  set store(StoreModel value) {
    widget._store = value;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        AppShow.animationDialog(context, StoreDetails(store: store));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: TransparentImageCard(
          width: 80.w,
          contentMarginTop: 5.h,
          imageProvider: Image.network(store.image ?? '').image,
          title: Center(
              child: StoreTitle(title: store.title ?? '', color: Colors.white)),
          description: const SizedBox(),
          footer: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppSizedBox.h1,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      width: 25,
                      height: 5,
                      radius: 1,
                      txtcolor: Colors.black,
                      text: store.type ?? '',
                      onTap: () {
                        // AppShow.animationDialog(context, StoreDetails(store: store));
                      },
                    ),
                  ],
                ),
                AppSizedBox.h1,
                Center(
                  child: RatingBarIndicator(
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
                ),
              ]),
        ),
      ),
    );
  }
}
