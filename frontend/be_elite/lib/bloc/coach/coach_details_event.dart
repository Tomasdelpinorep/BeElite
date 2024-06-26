part of 'coach_details_bloc.dart';

@immutable
sealed class CoachDetailsEvent {}

class GetCoachDetailsEvent extends CoachDetailsEvent {}

class GetProfileScreenStatsEvent extends CoachDetailsEvent {
  final String coachUsername;
  GetProfileScreenStatsEvent(this.coachUsername);
}
