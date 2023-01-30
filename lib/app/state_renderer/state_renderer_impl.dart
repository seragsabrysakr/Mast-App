import 'package:equatable/equatable.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:mast/app/app_colors.dart';
import 'package:mast/app/extensions.dart';
import 'package:mast/app/text_style.dart';

import '../../../app/constants.dart';
import '../../my_app.dart';
import 'state_renderer.dart';

abstract class FlowState extends Equatable {
  StateRendererType getStateRendererType();

  String getMessage();
}
// loading state (POPUP,FULL SCREEN)

class InitialState extends FlowState {
  @override
  String getMessage() {
    return "";
  }

  @override
  StateRendererType getStateRendererType() => StateRendererType.contentState;

  @override
  List<Object?> get props => [];
}

class LoadingState extends FlowState {
  final StateRendererType stateRendererType;
  final String? message;

  LoadingState({required this.stateRendererType, this.message});

  @override
  String getMessage() => message ?? MyApp.tr.loading;

  @override
  StateRendererType getStateRendererType() => stateRendererType;

  @override
  List<Object?> get props => [stateRendererType, message];
}

// error state (POPUP,FULL SCREEN)
class ErrorState extends FlowState {
  final StateRendererType stateRendererType;
  final String message;

  ErrorState(this.stateRendererType, this.message);

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => stateRendererType;

  @override
  List<Object?> get props => [stateRendererType, message];
}

// content state

class ContentState<T> extends FlowState {
  final int? randomInt;
  final T? data;
  final bool isLastPage;

  ContentState({this.data, this.randomInt, this.isLastPage = false});

  @override
  String getMessage() => Constants.empty;

  @override
  StateRendererType getStateRendererType() => StateRendererType.contentState;

  @override
  List<Object?> get props => [randomInt, data];
}

// EMPTY STATE

class EmptyState extends FlowState {
  final String? message;

  EmptyState(this.message);

  @override
  String getMessage() => message ?? "";

  @override
  StateRendererType getStateRendererType() =>
      StateRendererType.fullScreenEmptyState;

  @override
  List<Object?> get props => [message];
}

class SuccessState extends FlowState {
  final StateRendererType stateRendererType;
  final String? message;

  SuccessState(this.stateRendererType, {this.message});

  @override
  String getMessage() => message ?? "";

  @override
  StateRendererType getStateRendererType() => StateRendererType.toastSuccess;

  @override
  List<Object?> get props => [stateRendererType, message];
}

extension FlowStateExtension on FlowState {
  Widget flowStateBuilder(
    BuildContext context, {
    required Widget screenContent,
    required Function retry,
    Widget? loadingView,
    Widget? errorView,
    Widget? emptyView,
    Widget? successView,
    double? maxContentHeight,
    bool? isSliver = false,
  }) {
    switch (runtimeType) {
      case InitialState:
        Widget w = const Center();
        if (isSliver!) {
          w = SliverToBoxAdapter(
            child: w,
          );
        }
        return w;

      case LoadingState:
        {
          if (getStateRendererType() ==
              StateRendererType.fullScreenLoadingState) {
            // full screen loading state
            return loadingView ??
                StateRenderer(
                    message: getMessage(),
                    stateRendererType: getStateRendererType(),
                    retryActionFunction: retry,
                    maxContentHeight: maxContentHeight,
                    isSliver: isSliver);
          } else {
            // show content ui of the screen
            return screenContent;
          }
        }
      case ErrorState:
        {
          if (getStateRendererType() ==
              StateRendererType.fullScreenErrorState) {
            // full screen error state
            return errorView ??
                StateRenderer(
                    message: getMessage(),
                    stateRendererType: getStateRendererType(),
                    retryActionFunction: retry,
                    maxContentHeight: maxContentHeight,
                    isSliver: isSliver);
          } else {
            return screenContent;
          }
        }
      case EmptyState:
        {
          return emptyView ??
              StateRenderer(
                  stateRendererType: getStateRendererType(),
                  message: getMessage(),
                  retryActionFunction: () {},
                  maxContentHeight: maxContentHeight,
                  isSliver: isSliver);
        }
      case ContentState:
        {
          return screenContent;
        }
      case SuccessState:
        {
          // i should check if we are showing loading popup to remove it before showing success popup
          if (getStateRendererType() ==
              StateRendererType.fullScreenLoadingState) {
            // full screen success state
            return successView ??
                StateRenderer(
                    message: getMessage(),
                    stateRendererType: getStateRendererType(),
                    retryActionFunction: retry,
                    maxContentHeight: maxContentHeight,
                    isSliver: isSliver);
          } else {
            return screenContent;
          }
        }
      default:
        {
          return screenContent;
        }
    }
  }

  void flowStateListener(
    BuildContext context, {
    Function? retry,
    double? maxContentHeight,
  }) {
    dismissDialog(context);
    switch (runtimeType) {
      case LoadingState:
        {
          if (getStateRendererType() == StateRendererType.popupLoadingState) {
            // show popup loading
            showPopup(context, getStateRendererType(), getMessage(),
                dismis: false, maxContentHeight: maxContentHeight);
          }
        }
        break;
      case ErrorState:
        {
          if (getStateRendererType() == StateRendererType.popupErrorState) {
            // show popup error
            showPopup(context, getStateRendererType(), getMessage(),
                maxContentHeight: maxContentHeight);
          } else if (getStateRendererType() ==
              StateRendererType.toastErrorState) {
            showErrorToast(context, getStateRendererType(), getMessage());
          }
        }
        break;
      case EmptyState:
        {}
        break;
      case ContentState:
        {}
        break;
      case SuccessState:
        {
          // i should check if we are showing loading popup to remove it before showing success popup
          if (getStateRendererType() == StateRendererType.popupSuccess) {
            // show popup error
            showPopup(context, StateRendererType.popupSuccess, getMessage(),
                title: MyApp.tr.success, maxContentHeight: maxContentHeight);
          } else if (getStateRendererType() == StateRendererType.toastSuccess) {
            showSuccessToast(
                context, StateRendererType.toastSuccess, getMessage(),
                title: MyApp.tr.success);
          }
        }
        break;
    }
  }

  bool _checkIfDialogShowing(BuildContext context) =>
      ModalRoute.of(context)?.isCurrent != true;

  dismissDialog(BuildContext context) {
    if (_isCurrentDialogShowing) {
      _isCurrentDialogShowing = false;
      Navigator.of(context, rootNavigator: true).pop(true);
    }
  }

  showPopup(
    BuildContext context,
    StateRendererType stateRendererType,
    String message, {
    String title = Constants.empty,
    bool dismis = true,
    double? maxContentHeight,
  }) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _isCurrentDialogShowing = true;
      await showDialog(
          barrierColor: Colors.black.withOpacity(0.5),
          barrierDismissible: dismis,
          context: context,
          builder: (BuildContext context) => StateRenderer(
              stateRendererType: stateRendererType,
              message: message,
              title: title,
              retryActionFunction: () {},
              maxContentHeight: maxContentHeight));
      _isCurrentDialogShowing = false;
    });
  }

  showErrorToast(
      BuildContext context, StateRendererType stateRendererType, String message,
      {String title = Constants.empty}) {
    WidgetsBinding.instance.addPostFrameCallback((_) => popDialog(
        context: context,
        title: MyApp.tr.error,
        content: message,
        boxColor: AppColors.errorColor));
  }

  showSuccessToast(
      BuildContext context, StateRendererType stateRendererType, String message,
      {String title = Constants.empty}) {
    WidgetsBinding.instance.addPostFrameCallback((_) => popDialog(
        context: context,
        title: MyApp.tr.success,
        content: message,
        boxColor: AppColors.primaryColor));
  }
}

Future<Object?> popDialog({
  required context,
  required String title,
  required String content,
  required Color boxColor,
}) {
  return showFlash(
      context: context,
      persistent: true,
      transitionDuration: const Duration(milliseconds: 400),
      duration: const Duration(seconds: 2),
      builder: (context, controller) {
        return Flash(
            behavior: FlashBehavior.floating,
            position: FlashPosition.bottom,
            horizontalDismissDirection: HorizontalDismissDirection.horizontal,
            boxShadows: kElevationToShadow[4],
            margin: EdgeInsets.only(bottom: 5.h),
            backgroundColor: boxColor,
            borderRadius: BorderRadius.circular(2.h),
            controller: controller,
            onTap: () => controller.dismiss(),
            child: Padding(
              padding: EdgeInsets.only(top: 1.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80.w,
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(2.h),
                            topRight: Radius.circular(2.h))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 2.h,
                        ),
                        Row(
                          children: [
                            Text(
                              title,
                              style: AppTextStyle.getBoldStyle(
                                  color: boxColor, fontSize: 12.sp),
                            ),
                            const Spacer(
                              flex: 1,
                            ),
                            InkWell(
                              onTap: () {
                                controller.dismiss();
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 1.w, vertical: 1.h),
                                child: Icon(
                                  Icons.clear,
                                  color: Colors.grey.shade300,
                                  size: 4.w,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.grey.shade100,
                          thickness: 1.sp,
                        ),
                        Text(
                          content,
                          maxLines: 2,
                          style: AppTextStyle.getRegularStyle(
                              color: AppColors.tabBarSubTitleColor,
                              fontSize: 11.sp),
                        ),
                        SizedBox(
                          height: 2.h,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ));
      });
}

bool _isCurrentDialogShowing = false;
