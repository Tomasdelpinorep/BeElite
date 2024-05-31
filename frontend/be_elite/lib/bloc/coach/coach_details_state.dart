part of 'coach_details_bloc.dart';

@immutable
sealed class CoachDetailsState {}

final class CoachDetailsInitial extends CoachDetailsState {}

final class CoachDetailsLoadingState extends CoachDetailsState {}

final class CoachDetailsErrorState extends CoachDetailsState {
  final String errorMessage;
  CoachDetailsErrorState(this.errorMessage);
}

final class CoachDetailsSuccessState extends CoachDetailsState {
  final CoachDetails coachDetails;
  CoachDetailsSuccessState(this.coachDetails);
}

final class GetProfileStatsSuccessState extends CoachDetailsState{
  final UserDto oldestAthlete;
  final int totalSessionsCompleted;
  GetProfileStatsSuccessState(this.oldestAthlete, this.totalSessionsCompleted);
}

final class GetProfileStatsErrorState extends CoachDetailsState{
  final String errorMessage;
  GetProfileStatsErrorState(this.errorMessage);
}
