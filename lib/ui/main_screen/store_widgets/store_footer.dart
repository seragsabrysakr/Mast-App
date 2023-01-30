import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mast/app/app_sized_box.dart';
import 'package:mast/app/extensions.dart';
import 'package:mast/ui/componnents/custom_button.dart';

class StoreFooter extends StatelessWidget {
  const StoreFooter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppSizedBox.h2,
        RatingBarIndicator(
          rating: 3,
          itemBuilder: (context, index) => const Icon(
            Icons.star,
            color: Colors.yellow,
          ),
          unratedColor: Colors.grey,
          itemCount: 5,
          itemSize: 15.sp,
          direction: Axis.horizontal,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomButton(
              width: 20,
              height: 5,
              txtcolor: Colors.black,
              text: 'تفاصيل ',
              onTap: () {},
            ),
            CustomButton(
              width: 20,
              height: 5,
              txtcolor: Colors.black,
              text: 'أضف تقييما',
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}
