import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mast/app/app_sized_box.dart';
import 'package:mast/app/extensions.dart';
import 'package:mast/data/model/home/store_model.dart';

class StoreFooter extends StatelessWidget {
  final StoreModel store;

  StoreFooter({
    Key? key,
    required this.store,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppSizedBox.h2,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppSizedBox.w2,
            RatingBarIndicator(
              rating: store.avgRating ?? 0.0,
              itemBuilder: (context, index) => const Icon(
                Icons.star,
                color: Colors.yellow,
              ),
              unratedColor: Colors.grey,
              itemCount: 5,
              itemSize: 15.sp,
              direction: Axis.horizontal,
            ),
            AppSizedBox.w2
          ],
        ),
      ],
    );
  }
}
