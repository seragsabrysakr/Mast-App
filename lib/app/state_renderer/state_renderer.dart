import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../extensions.dart';
import '../app_assets.dart';
import '../app_colors.dart';
import '../text_style.dart';
import '../../my_app.dart';

enum StateRendererType {
  // POPUP STATES (DIALOG)
  popupLoadingState,
  popupErrorState,
  popupSuccess,
  toastErrorState,
  toastSuccess,
  // FULL SCREEN STATED (FULL SCREEN)
  fullScreenLoadingState,
  fullScreenSuccessState,
  fullScreenErrorState,
  fullScreenEmptyState,
  // general
  contentState
}

class StateRenderer extends StatelessWidget {
  StateRendererType stateRendererType;
  String message;
  String title;
  Function retryActionFunction;
  double? maxContentHeight;
  bool? isSliver;

  StateRenderer(
      {Key? key, required this.stateRendererType,
        this.message = "loading",
        this.title = "",
        required this.maxContentHeight,
        required this.retryActionFunction,
         this.isSliver = false,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var widget = Container(
        constraints: BoxConstraints(
          maxHeight: maxContentHeight ?? 100.h,
        ),
        child: _getStateWidget(context));
    return isSliver!
        ? SliverToBoxAdapter(
            child: widget,
          )
        : widget;
  }

  Widget _getStateWidget(BuildContext context) {
    switch (stateRendererType) {
      case StateRendererType.popupLoadingState:
        return _getPopUpLoadingDialog(
            context, [_getAnimatedImage(JsonAssets.loading)]);
      case StateRendererType.popupErrorState:
        return _getPopUpDialog(context, [
          _getAnimatedImage(JsonAssets.error),
          _getMessage(message),
          _getRetryButton(MyApp.tr.ok, context)
        ]);
      case StateRendererType.fullScreenLoadingState:
        return _getItemsColumn(
            [_getAnimatedImage(JsonAssets.loading), _getMessage(message)]);
      case StateRendererType.fullScreenErrorState:
        return _getItemsColumn([
          _getAnimatedImage(JsonAssets.error),
          _getMessage(message),
          _getRetryButton(MyApp.tr.retry, context)
        ]);
      case StateRendererType.fullScreenEmptyState:
        return _getItemsColumn(
            [_getAnimatedImage(JsonAssets.empty), _getMessage(message)]);
      case StateRendererType.contentState:
        return Container();
      case StateRendererType.popupSuccess:
        return _getPopUpDialog(context, [
          _getAnimatedImage(JsonAssets.success),
          _getMessage(title),
          _getMessage(message),
          _getRetryButton(MyApp.tr.ok, context)
        ]);
      default:
        return Container();
    }
  }

  Widget _getPopUpDialog(BuildContext context, List<Widget> children) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0)),
      elevation: 1.5,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(2.h),
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [BoxShadow(color: Colors.black26)]),
        child: _getDialogContent(context, children),
      ),
    );
  }

  Widget _getPopUpLoadingDialog(BuildContext context, List<Widget> children) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child:  Container(
        child: Lottie.asset(JsonAssets.loading,
            width: 20.h, height: 20.h),
      ),
    );
  }

  Widget _getDialogContent(BuildContext context, List<Widget> children) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  Widget _getItemsColumn(List<Widget> children) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }


  Widget _getAnimatedImage(String animationName) {
    return SizedBox(
        height: 12.h,
        width: 12.h,
        child: Lottie.asset(animationName));
  }


  static Widget defaultLoading() {
    return SizedBox(
        height: 15.h,
        width: 15.h,
        child: Lottie.asset(JsonAssets.loading));
  }

  Widget _getMessage(String message) {
    return Center(
      child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
              message,
              style: AppTextStyle.normal)
      ),
    );
  }

  Widget _getRetryButton(String buttonTitle, BuildContext context) {
    return Center(
      child: ElevatedButton(
          onPressed: () {
            if (stateRendererType ==
                StateRendererType.fullScreenErrorState) {
              // call retry function
              retryActionFunction.call();
            } else {
              // popup error state
              Navigator.of(context).pop();
            }
          },
          child: Text(buttonTitle)),
    );
  }
}
