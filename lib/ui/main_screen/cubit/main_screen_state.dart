part of 'main_screen_cubit.dart';

abstract class MainScreenState extends Equatable {
  const MainScreenState();

  @override
  List<Object> get props => [];
}

class MainScreenInitial extends MainScreenState {}
class ChangeIndexState extends MainScreenState {}
