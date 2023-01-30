import 'package:flutter/material.dart';
import 'package:image_card/image_card.dart';
import 'package:mast/app/extensions.dart';
import 'package:mast/ui/main_screen/store_widgets/store_description.dart';
import 'package:mast/ui/main_screen/store_widgets/store_footer.dart';
import 'package:mast/ui/main_screen/store_widgets/store_title.dart';

class StoreCard extends StatefulWidget {
  const StoreCard({Key? key}) : super(key: key);

  @override
  State<StoreCard> createState() => _StoreCardState();
}

class _StoreCardState extends State<StoreCard> {
  final img = Image.network('https://picsum.photos/250?image=9');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: TransparentImageCard(
        width: 80.w,
        height: 35.h,
        contentMarginTop: 6.h,
        imageProvider: img.image,
        title: const StoreTitle(title: 'اسم المتجر', color: Colors.white),
        description: const StoreDescription(
            description:
                'هنالك العديد من الأنواع المتوفرة لنصوص لوريم إيبسوم، ولكن الغالبية تم تعديلها بشكل ما عبر إدخال بعض النوادر أو الكلمات العشوائية إلى النص. إن كنت تريد أن تستخدم نص لوريم إيبسوم ما، عليك أن تتحقق أولاً أن ليس هناك أي كلمات أو عبارات محرجة أو غير لائقة مخبأة في هذا النص.',
            color: Colors.white),
        footer: const StoreFooter(),
      ),
    );
  }
}
