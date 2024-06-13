part of 'athlete_bloc.dart';

@immutable
sealed class AthleteState {}

final class AthleteInitialState extends AthleteState {}

final class AthleteLoadingState extends AthleteState {}

final class AthleteErrorState extends AthleteState {
  final String errorMessage;
  AthleteErrorState(this.errorMessage);
}

final class GetAthletesByProgramSuccessState extends AthleteState {
  final List<UserDto> athletes;
  GetAthletesByProgramSuccessState(this.athletes);
}

final class GetAthletesByProgramEmptyState extends AthleteState {}

final class AthleteDetailsSuccessState extends AthleteState {
  final AthleteDetailsDto athleteDetails;
  AthleteDetailsSuccessState(this.athleteDetails);
}

final class GetUpcomingWorkoutsSuccessState extends AthleteState {
  final List<AthleteSessionDto> sessionList;
  GetUpcomingWorkoutsSuccessState(this.sessionList);
}

final class GetPreviousWorkoutsSuccessState extends AthleteState {
  final List<AthleteSessionDto> sessionList;
  GetPreviousWorkoutsSuccessState(this.sessionList);
}

final class AthleteBlockSaveSuccessState extends AthleteState {
  final AthleteBlockDto block;
  AthleteBlockSaveSuccessState(this.block);
}
final class UpdateAthleteSessionSuccessState extends AthleteState {
  final AthleteSessionDto? session;
  UpdateAthleteSessionSuccessState(this.session);
}
