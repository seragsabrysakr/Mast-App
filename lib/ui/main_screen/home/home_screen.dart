// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:mast/app/app_sized_box.dart';
import 'package:mast/app/extensions.dart';
import 'package:mast/app/state_renderer/request_builder.dart';
import 'package:mast/data/model/home/store_model.dart';
import 'package:mast/data/request/store_request.dart';
import 'package:mast/ui/componnents/app_show.dart';
import 'package:mast/ui/componnents/home_title.dart';
import 'package:mast/ui/main_screen/allstores/all_recent_stores.dart';
import 'package:mast/ui/main_screen/allstores/all_top_stores.dart';
import 'package:mast/ui/main_screen/home/store_cubit/get_stores_cubit.dart';
import 'package:mast/ui/main_screen/home/store_cubit/special_stores_cubit.dart';
import 'package:mast/ui/main_screen/home/store_cubit/top_stores_cubit.dart';
import 'package:mast/ui/main_screen/store_widgets/store_card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mast/ui/main_screen/store_widgets/store_slider.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  var request = StoreRequest(skip: 0, take: 10);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              GetStoresCubit.get(context).getStores(request: request);
              SpecialStoresCubit.get(context)
                  .getSpecialStores(request: request);
              TopStoresCubit.get(context).getTopStores(request: request);
            });
          },
          child: SingleChildScrollView(
            key: UniqueKey(),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Stack(
              children: [
                Column(
                  children: [
                    buildSpecialRequestBuilder(),
                    buildRecentRequestBuilder(),
                    buildTopRequestBuilder(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  RequestBuilder<GetStoresCubit> buildRecentRequestBuilder() {
    return RequestBuilder<GetStoresCubit>(
        maxContentHeight: 40.h,
        retry: (context, cubit) {},
        contentBuilder: (context, cubit) {
          List<StoreModel> stores = cubit.stores;

          return buildStoresList(
              stores: stores,
              title: 'أحدث المتاجر',
              context: context,
              rout: const AllRecentScreen());
        });
  }

  RequestBuilder<TopStoresCubit> buildTopRequestBuilder() {
    return RequestBuilder<TopStoresCubit>(
        maxContentHeight: 40.h,
        retry: (context, cubit) {},
        contentBuilder: (context, cubit) {
          List<StoreModel> stores = cubit.stores;

          return buildStoresList(
              stores: stores,
              title: 'الاعلي تقييما',
              context: context,
              rout: const AllTopScreen());
        });
  }

  RequestBuilder<SpecialStoresCubit> buildSpecialRequestBuilder() {
    return RequestBuilder<SpecialStoresCubit>(
        maxContentHeight: 30.h,
        retry: (context, cubit) {},
        contentBuilder: (context, cubit) {
          List<StoreModel> stores = cubit.stores;

          return Column(
            children: [
              AppSizedBox.h1,
              const HomeTitle(title: 'المتاجر المميزة'),
              AppSizedBox.h1,
              CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    aspectRatio: 1.4,
                    height: 30.h,
                    enlargeCenterPage: true,
                    enlargeStrategy: CenterPageEnlargeStrategy.height,
                  ),
                  items: stores.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: StoreSlider(store: i));
                      },
                    );
                  }).toList()),
              const Divider(
                color: Colors.yellow,
                height: 10.0,
                thickness: 4.0,
                indent: 20.0,
                endIndent: 20.0,
              ),
            ],
          );
        });
  }

  buildStoresList(
      {required List<StoreModel> stores,
      required String title,
      required BuildContext context,
      required Widget rout}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: double.infinity),
        Row(
          children: [
            HomeTitle(title: title),
            const Spacer(flex: 1),
            TextButton(
                onPressed: () {
                  AppShow.animationDialog(context, rout);
                },
                child: const Text(
                  'عرض الكل',
                  style: TextStyle(color: Colors.yellow),
                )),
            AppSizedBox.w2,
          ],
        ),
        AppSizedBox.h2,
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
              children: List.generate(
                  stores.length,
                  (index) => StoreCard(
                        store: stores[index],
                      ))),
        ),
        AppSizedBox.h2,
      ],
    );
  }
}
