part of 'athlete_bloc.dart';

@immutable
sealed class AthleteEvent {}

class GetAthletesByProgramEvent extends AthleteEvent {
  final String programName;
  final String coachUsername;
  GetAthletesByProgramEvent(this.programName, this.coachUsername);
}

class GetAthleteDetailsEvent extends AthleteEvent {
  GetAthleteDetailsEvent();
}

class GetUpcomingWorkoutsEvent extends AthleteEvent {
  GetUpcomingWorkoutsEvent();
}

class GetPreviousWorkoutsEvent extends AthleteEvent {
  GetPreviousWorkoutsEvent();
}

class SaveAthleteBlockEvent extends AthleteEvent {
  final AthleteBlockDto block;
  SaveAthleteBlockEvent(this.block);
}

class ChangeBlockDoneStatusEvent extends AthleteEvent {
  final AthleteBlockDto block;
  ChangeBlockDoneStatusEvent(this.block);
}

class UpdateAthleteSessionEvent extends AthleteEvent{
  final AthleteSessionId id;
  UpdateAthleteSessionEvent(this.id);
}

class CompleteSessionEvent extends AthleteEvent{
  final AthleteSessionId id;
  CompleteSessionEvent(this.id);
}

class ManageInviteEvent extends AthleteEvent{
  final InviteDto invite;
  ManageInviteEvent(this.invite);
}