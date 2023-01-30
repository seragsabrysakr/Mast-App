import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mast/app/app_sized_box.dart';
import 'package:mast/app/extensions.dart';
import 'package:mast/data/model/home/store_model.dart';
import 'package:mast/ui/componnents/app_show.dart';
import 'package:mast/ui/componnents/custom_button.dart';
import 'package:mast/ui/main_screen/store_widgets/store_details.dart';

class StoreFooter extends StatelessWidget {
   final StoreModel store;
  const StoreFooter({
    Key? key, required this.store,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppSizedBox.h2,
        RatingBarIndicator(
          rating: 0,
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
              onTap: () {
                AppShow.animationDialog(context, StoreDetails(store: store));
              },
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
