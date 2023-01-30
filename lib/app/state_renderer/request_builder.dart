import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mast/app/state_renderer/state_renderer_impl.dart';

class RequestBuilder<B extends StateStreamable<FlowState>>
    extends StatelessWidget {
  final Widget Function(BuildContext, B) contentBuilder;
  final Function(BuildContext, B)? retry;
  final Widget? loadingView;
  final Widget? errorView;
  final Widget? emptyView;
  final Widget? successView;
  final double? maxContentHeight;
  final bool? isSliver;
  final Function(BuildContext, B)? listener;
  final bool preventDefaultListener;
  const RequestBuilder({
    Key? key,
    required this.contentBuilder,
    required this.retry,
    this.loadingView,
    this.errorView,
    this.emptyView,
    this.successView,
    this.maxContentHeight,
    this.isSliver = false,
    this.listener,
    this.preventDefaultListener = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<B, FlowState>(
      listener: (context, state) async {
        if (!preventDefaultListener) state.flowStateListener(context);
        if (listener != null) listener!(context, context.read<B>());
      },
      builder: (context, state) {
        return state.flowStateBuilder(context,
            screenContent: Builder(builder: (context) {
          return contentBuilder.call(context, context.read<B>());
        }), retry: () {
          retry?.call(context, context.read<B>());
        },
            loadingView: loadingView,
            errorView: errorView,
            emptyView: emptyView,
            successView: successView,
            maxContentHeight: maxContentHeight,
            isSliver: isSliver);
      },
    );
  }
}

extension OnWidget on Widget {
  Widget requestBuilder<B extends StateStreamable<FlowState>>({
    Function(BuildContext, B)? retry,
    Widget? loadingView,
    Widget? errorView,
    Widget? emptyView,
    Widget? successView,
    double? maxContentHeight,
    bool? isSliver = false,
    Function(BuildContext, B)? listener,
    bool preventDefaultListener = false,
  }) {
    return RequestBuilder<B>(
      listener: listener,
      contentBuilder: (a, c) => this,
      retry: retry,
      loadingView: loadingView,
      errorView: errorView,
      emptyView: emptyView,
      successView: successView,
      maxContentHeight: maxContentHeight,
      isSliver: isSliver,
    );
  }
}
