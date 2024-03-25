part of 'athlete_bloc.dart';

@immutable
sealed class AthleteEvent {}

class GetAthletesByProgramEvent extends AthleteEvent{
  final String programName;
  final String coachUsername;
  GetAthletesByProgramEvent(this.programName, this.coachUsername);
}
