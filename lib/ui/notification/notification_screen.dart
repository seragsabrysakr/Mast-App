import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_card/image_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mast/app/app_colors.dart';
import 'package:mast/app/app_sized_box.dart';
import 'package:mast/app/di/di.dart';
import 'package:mast/app/extensions.dart';
import 'package:mast/app/state_renderer/state_renderer.dart';
import 'package:mast/app/state_renderer/state_renderer_impl.dart';
import 'package:mast/app/text_style.dart';
import 'package:mast/data/model/home/notification_server_model.dart';
import 'package:mast/data/model/home/store_model.dart';
import 'package:mast/data/request/store_request.dart';
import 'package:mast/ui/componnents/app_show.dart';
import 'package:mast/ui/componnents/custom_button.dart';
import 'package:mast/ui/main_screen/allstores/serach.dart';
import 'package:mast/ui/main_screen/home/store_cubit/notification_cubit.dart';
import 'package:mast/ui/main_screen/store_widgets/rating/rating_view.dart';
import 'package:mast/ui/main_screen/store_widgets/store_details.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late final cubit = getIt<NotificationCubit>();
  final PagingController<int, NotificationServerModel> _pagingController =
      PagingController(firstPageKey: 1);
  StoreRequest request = StoreRequest();
  int pageSize = 10;
  var searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    request = request.copyWith(take: pageSize, title: searchController.text);
    _pagingController.addPageRequestListener((pageKey) {
      cubit.view(request: request, pageKey: pageKey);
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
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.blackColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: AppColors.primaryColor,
          elevation: 0,
          title: Text(
            'الاشعارات',
            style: AppTextStyle.getRegularStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: AppSizedBox.h2),
            SliverFillRemaining(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: getAllRequestBuilder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getAllRequestBuilder() {
    return BlocListener<NotificationCubit, FlowState>(
      listener: (context, state) {
        var cubit = NotificationCubit.get(context);
        if (state is ContentState) {
          var response = state.data as List<NotificationServerModel>;
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
    return PagedListView<int, NotificationServerModel>(
      pagingController: _pagingController,
      physics: const BouncingScrollPhysics(),
      builderDelegate: PagedChildBuilderDelegate<NotificationServerModel>(
        itemBuilder: (context, item, index) => notificationItem(item),
        noItemsFoundIndicatorBuilder: (context) => emptyView(context),
        firstPageProgressIndicatorBuilder: (context) => loadingIndicator(),
        newPageProgressIndicatorBuilder: (context) => loadingIndicator(),
        firstPageErrorIndicatorBuilder: (context) =>
            errorIndicator(_pagingController),
        newPageErrorIndicatorBuilder: (context) =>
            errorIndicator(_pagingController),
      ),
    );
  }

  StateRenderer emptyView(BuildContext context) {
    return StateRenderer(
      message: 'لا يوجد اشعارات',
      stateRendererType: StateRendererType.fullScreenErrorState,
      retryActionFunction: () {
        setState(() {
          request = StoreRequest(
            title: searchController.text,
            take: pageSize,
          );
        });
        _pagingController.refresh();
        FocusScope.of(context).unfocus();
      },
      maxContentHeight: null,
    );
  }

  notificationItem(NotificationServerModel item) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: 90.w,
      margin: EdgeInsets.symmetric(horizontal: 3.w,vertical: 1.h),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 2.w),
            child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title ?? '',
                  style: AppTextStyle.getBoldStyle(color: Colors.black),
                ),
                Text(
                  item.description ?? '',
                  textAlign: TextAlign.justify,
                  style: AppTextStyle.getRegularStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          ClipOval(
            child: CircleAvatar(
                radius: 4.h,
                child: AppShow.buildImage(
                    img: item.image ?? '', width: 40.w, height: 12.6.h)),
          ),
        ],
      ),
    );
  }

  storeTitle(StoreModel item) {
    return Center(
      child: Text(
        item.title ?? '',
        style: AppTextStyle.getBoldStyle(color: Colors.black, fontSize: 12.sp),
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

  Widget search() {
    return SliverAppBar(
      leading: const SizedBox(),
      flexibleSpace: buildSearchWidget(
        context,
      ),
      pinned: true,
      collapsedHeight: 10.h,
    );
  }

  Padding buildSearchWidget(
    BuildContext context,
  ) {
    return Padding(
      padding: EdgeInsets.only(left: 6.w, right: 6.w),
      child: Focus(
        child: CustomSearch(
          onSubmit: (String text) {
            setState(() {
              request = StoreRequest(
                title: searchController.text,
                take: pageSize,
              );
            });
            _pagingController.refresh();
            FocusScope.of(context).unfocus();
          },
          search: () {
            setState(() {
              request = StoreRequest(
                title: searchController.text,
                take: pageSize,
              );
            });
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
