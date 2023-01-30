import 'package:flutter/material.dart';
import 'package:mast/app/app_sized_box.dart';
import 'package:mast/ui/componnents/home_title.dart';
import 'package:mast/ui/main_screen/store_widgets/store_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSizedBox.h1,
            const HomeTitle(title: 'المتاجر المميزة'),
            AppSizedBox.h2,
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(children: List.generate(4, (index) => StoreCard())),
            ),
            AppSizedBox.h4,
            const HomeTitle(title: 'الاعلي تقييما'),
            AppSizedBox.h2,
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(children: List.generate(4, (index) => StoreCard())),
            ),
            AppSizedBox.h4,
            const HomeTitle(title: 'أحدث المتاجر'),
            AppSizedBox.h2,
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(children: List.generate(4, (index) => StoreCard())),
            ),
            AppSizedBox.h4,
          ],
        ),
      ),
    );
  }
}
