// ignore_for_file: must_be_immutable, unnecessary_getters_setters

import 'package:flutter/material.dart';
import 'package:image_card/image_card.dart';
import 'package:mast/app/extensions.dart';
import 'package:mast/data/model/home/store_model.dart';
import 'package:mast/ui/main_screen/store_widgets/store_description.dart';
import 'package:mast/ui/main_screen/store_widgets/store_footer.dart';
import 'package:mast/ui/main_screen/store_widgets/store_title.dart';

class StoreCard extends StatefulWidget {
  StoreModel _store;

  StoreCard({Key? key, required StoreModel store})
      : _store = store,
        super(key: key);

  @override
  State<StoreCard> createState() => _StoreCardState();
}

class _StoreCardState extends State<StoreCard> {
  StoreModel get store => widget._store;

  set store(StoreModel value) {
    widget._store = value;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: TransparentImageCard(
        width: 80.w,
        height: 40.h,
        contentMarginTop: 7.h,
        imageProvider: Image.network(store.image ?? '').image,
        title: StoreTitle(title: store.title ?? '', color: Colors.white),
        description: SizedBox(
          height: 10.h,
          child: StoreDescription(description: store.description ?? '', color: Colors.white),
        ),
        footer: StoreFooter(
          store: store,
        ),
      ),
    );
  }
}
