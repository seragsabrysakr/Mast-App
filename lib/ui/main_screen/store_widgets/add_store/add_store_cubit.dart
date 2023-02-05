import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mast/app/state_renderer/state_renderer.dart';
import 'package:mast/app/state_renderer/state_renderer_impl.dart';
import 'package:mast/data/model/home/store_model.dart';
import 'package:mast/repository/home_repository.dart';

@injectable
class AddStoresCubit extends Cubit<FlowState> {
  final HomeRepository homeRepository;

  AddStoresCubit(this.homeRepository)
      : super(LoadingState(stateRendererType: StateRendererType.popupLoadingState));
  List<StoreModel> stores = [];
  int currentPage = 1;

  static AddStoresCubit get(BuildContext context) => context.read<AddStoresCubit>();

  void addStores({
    required File image,
    required String title,
    required String description,
    required String url,
    required String type,
  }) async {
    emit(LoadingState(stateRendererType: StateRendererType.popupLoadingState));
    Future.delayed(const Duration(seconds: 0), () {
      homeRepository
          .addStore(image: image, title: title, description: description, url: url, type: type)
          .then((value) => value.fold((failure) {
                emit(ErrorState(StateRendererType.toastErrorState, failure.message));
                print("errorMessage: ${failure.message}");
              }, (data) {
                stores = data.data!;
                emit(SuccessState(StateRendererType.toastSuccess,
                    message: "تم اضافة المتجر بنجاح"
                        " وسيتم مراجعته من قبل الادارة"));
              }));
    });
  }
}
