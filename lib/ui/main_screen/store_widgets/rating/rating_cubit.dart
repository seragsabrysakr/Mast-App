import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mast/app/state_renderer/state_renderer.dart';
import 'package:mast/app/state_renderer/state_renderer_impl.dart';
import 'package:mast/data/storage/local/app_prefs.dart';
import 'package:mast/repository/home_repository.dart';

@injectable
class RatingCubit extends Cubit<FlowState> {
  final HomeRepository _homeRepository;
  final AppPreferences _appPreferences;

  RatingCubit(this._homeRepository, this._appPreferences) : super(ContentState());

  static RatingCubit get(BuildContext context) => context.read<RatingCubit>();

  addRating({
    required String comment,
    required String shopRating,
    required String shopId,
  }) async {
    emit(LoadingState(stateRendererType: StateRendererType.popupLoadingState));
    _homeRepository
        .addRating(comment: comment, shopRating: shopRating, shopId: shopId)
        .then((value) => value.fold((error) {
              emit(ErrorState(StateRendererType.toastErrorState, error.message));
            }, (data) {
              emit(SuccessState(StateRendererType.toastSuccess,
                  message: 'تم اضافة التقييم بنجاح '
                      'وسيتم عرضه فور مراجعته'
                      ''));
            }));
  }
}
