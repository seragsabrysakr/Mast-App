import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mast/app/app_colors.dart';
import 'package:mast/app/app_sized_box.dart';
import 'package:mast/app/di/di.dart';
import 'package:mast/app/extensions.dart';
import 'package:mast/app/state_renderer/request_builder.dart';
import 'package:mast/app/state_renderer/state_renderer.dart';
import 'package:mast/app/state_renderer/state_renderer_impl.dart';
import 'package:mast/data/model/home/store_model.dart';
import 'package:mast/data/request/store_request.dart';
import 'package:mast/ui/main_screen/home/store_cubit/get_stores_cubit.dart';
import 'package:mast/ui/main_screen/notification/serach.dart';
import 'package:mast/ui/main_screen/store_widgets/store_card.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late final cubit = getIt<GetStoresCubit>();
  final PagingController<int, StoreModel> _pagingController =
  PagingController(firstPageKey: 1);
  StoreRequest request = StoreRequest();
  int pageSize = 10;
  var searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    request = request.copyWith(take: pageSize,title: searchController.text);
    _pagingController.addPageRequestListener((pageKey) {
      cubit.getStores(
          request: request, pageKey: pageKey);
    });
  }

  @override
  void dispose() {
    cubit.close();
    _pagingController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child:
      CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: AppSizedBox.h2),
          search(),
          SliverFillRemaining(
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: 4.w),
              child: getAllRequestBuilder(),
            ),
          ),

        ],
      ),
    );
  }
  getAllRequestBuilder() {
    return BlocListener<GetStoresCubit, FlowState>(
      listener: (context, state) {
        var cubit = GetStoresCubit.get(context);
        if (state is ContentState) {
          var response = state.data as List<StoreModel>;
          if (state.isLastPage) {
            _pagingController.appendLastPage(response);
          } else {
            _pagingController.appendPage(response, cubit.currentPage + 1);
          }
        }
        if (state is ErrorState) {
          _pagingController.error = state.message;
        }
        if (state is EmptyState) {
          _pagingController.appendLastPage([]);
        }
      },
      child: restaurantGrid(),
    );
  }
  Widget restaurantGrid() {
    return PagedGridView<int, StoreModel>(
      showNewPageProgressIndicatorAsGridChild: true,
      showNewPageErrorIndicatorAsGridChild: true,
      showNoMoreItemsIndicatorAsGridChild: true,
      pagingController: _pagingController,
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 1.3,
          crossAxisSpacing: 6.w,
          mainAxisSpacing: 5.w),
      builderDelegate: PagedChildBuilderDelegate<StoreModel>(
        itemBuilder: (context, item, index) => StoreCard(store: item),
        noItemsFoundIndicatorBuilder: (context) => StateRenderer(
          message: 'لا يوجد متاجر',
          stateRendererType: StateRendererType.fullScreenErrorState,
          retryActionFunction: () {
            setState(() {
              request= StoreRequest(
                title: searchController.text,
                take: pageSize,
              );
            });
            _pagingController.refresh();
            FocusScope.of(context).unfocus();

          },
          maxContentHeight: null,
        ),

        firstPageProgressIndicatorBuilder: (context) => loadingIndicator( ),
        newPageProgressIndicatorBuilder: (context) => loadingIndicator( ),
        firstPageErrorIndicatorBuilder: (context) =>
            errorIndicator(_pagingController),
        newPageErrorIndicatorBuilder: (context) =>
            errorIndicator(_pagingController),
      ),
    );
  }
  errorIndicator(PagingController controller) {
    return StateRenderer(
      message: controller.error,
      stateRendererType: StateRendererType.fullScreenErrorState,
      retryActionFunction: () {
        controller.retryLastFailedRequest();
      },
      maxContentHeight: null,
    );
  }

  Widget loadingIndicator() {
    return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryColor,
        ));
  }
  Widget search(){
    return SliverAppBar(
      leading: const SizedBox(),
      flexibleSpace: buildSearchWidget(context,),
      pinned: true,
      collapsedHeight: 10.h,
    );
  }
  Padding buildSearchWidget(BuildContext context,) {
    return Padding(
      padding: EdgeInsets.only(left: 6.w, right: 6.w),
      child: Focus(
        child: CustomSearch(
          onSubmit: (String text) {
          setState(() {
            request= StoreRequest(
              title: searchController.text,
              take: pageSize,
            );
          });
          _pagingController.refresh();
          FocusScope.of(context).unfocus();

          },
          search: () {
            setState(() {
              request= StoreRequest(
                title: searchController.text,
                take: pageSize,
              );            });
            _pagingController.refresh();
            FocusScope.of(context).unfocus();

          },
          controller: searchController,
          onSearchTextChanged: (String text) {},
        ),
      ),
    );
  }
}
