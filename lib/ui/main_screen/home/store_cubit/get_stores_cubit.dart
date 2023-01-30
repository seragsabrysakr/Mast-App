
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mast/app/state_renderer/state_renderer.dart';
import 'package:mast/app/state_renderer/state_renderer_impl.dart';
import 'package:mast/data/model/home/store_model.dart';
import 'package:mast/data/request/store_request.dart';
import 'package:mast/repository/home_repository.dart';

@injectable
class GetStoresCubit extends Cubit<FlowState> {
final HomeRepository homeRepository;
  GetStoresCubit(this.homeRepository) : super(LoadingState(
      stateRendererType: StateRendererType.popupLoadingState));
  List<StoreModel> stores = [];
  int currentPage = 1;
  static GetStoresCubit get(BuildContext context) =>
      context.read<GetStoresCubit>();

  void getStores({StoreRequest? request, int pageKey = 1}) async {
    if (pageKey == 1) {
      stores.clear();
    }
    var req = request?.copyWith(
      skip: stores.length,
    );
    emit(LoadingState(
        stateRendererType: StateRendererType.popupLoadingState));
    Future.delayed(const Duration(seconds: 0), () {
      homeRepository.viewStores(skip: req!.skip,
      take: req.take,
        title: req.title
      ).then((value) => value.fold((failure) {
        emit(
            ErrorState(StateRendererType.toastErrorState, failure.message));
        print("errorMessage: ${failure.message}");
      }, (data) {
        print("getStores: ${data.data!.length}");
        if (data.data!.isNotEmpty) {
          currentPage = pageKey;
          stores.addAll(data.data!);
          var isLastPage = stores.length < 10;

          emit(ContentState(data: data.data, isLastPage: isLastPage));
        } else {
          emit(EmptyState(''));
        }
      }));
    });
  }
}
