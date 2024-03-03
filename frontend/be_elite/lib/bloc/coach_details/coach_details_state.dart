part of 'coach_details_bloc.dart';

@immutable
sealed class CoachDetailsState {}

final class CoachDetailsInitial extends CoachDetailsState {}

final class CoachDetailsLoadingState extends CoachDetailsState{}

final class CoachDetailsErrorState extends CoachDetailsState{
  final String errorMessage;
  CoachDetailsErrorState(this.errorMessage);
}

final class CoachDetailsSuccessState extends CoachDetailsState{
  final CoachDetails coachDetails;
  CoachDetailsSuccessState(this.coachDetails);
}


