part of 'week_bloc.dart';

@immutable
sealed class WeekState {}

final class WeekInitial extends WeekState {}

final class WeekLoadingState extends WeekState {}

final class WeekErrorState extends WeekState {
  final String errorMessage;
  WeekErrorState(this.errorMessage);
}

final class WeekSuccessState extends WeekState {
  final WeekDto week;
  WeekSuccessState(this.week);
}
