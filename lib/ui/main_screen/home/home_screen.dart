import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mast/app/app_sized_box.dart';
import 'package:mast/app/di/di.dart';
import 'package:mast/app/extensions.dart';
import 'package:mast/app/state_renderer/request_builder.dart';
import 'package:mast/app/state_renderer/state_renderer_impl.dart';
import 'package:mast/data/model/home/store_model.dart';
import 'package:mast/data/request/store_request.dart';
import 'package:mast/ui/componnents/home_title.dart';
import 'package:mast/ui/main_screen/home/store_cubit/get_stores_cubit.dart';
import 'package:mast/ui/main_screen/store_widgets/store_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => getIt<GetStoresCubit>()..getStores(
          request: StoreRequest(
            skip: 0,
            take: 10,
          ),
        ),
        child: RequestBuilder<GetStoresCubit>(
          maxContentHeight: 30.h,
          retry:(context, cubit){},
            loadingView: const Center(child: CircularProgressIndicator(color: Colors.yellow,)),
          contentBuilder: (context, cubit) {
            List<StoreModel> stores = cubit.stores;
            if(cubit.state is LoadingState){
              return const Center(child: CircularProgressIndicator(color: Colors.yellow,));
            }
            return buildSingle(stores);

          }
        ),
      ),
    );
  }

  buildSingle(List<StoreModel> stores) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
          ),
          AppSizedBox.h1,
          const HomeTitle(title: 'أحدث المتاجر'),
          AppSizedBox.h2,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(children: List.generate(stores.length, (index) => StoreCard(store:
            stores[index],))),
          ),
          AppSizedBox.h4,
          // const HomeTitle(title: 'الاعلي تقييما'),
          // AppSizedBox.h2,
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   physics: const BouncingScrollPhysics(),
          //   child: Row(children: List.generate(4, (index) => StoreCard())),
          // ),
          // AppSizedBox.h4,
          // const HomeTitle(title: 'أحدث المتاجر'),
          // AppSizedBox.h2,
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   physics: const BouncingScrollPhysics(),
          //   child: Row(children: List.generate(4, (index) => StoreCard())),
          // ),
          // AppSizedBox.h4,
        ],
      ),
    );
  }
}
