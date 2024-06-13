part of 'program_bloc.dart';

@immutable
sealed class ProgramEvent {}

class GetProgramDtoEvent extends ProgramEvent {
  final String programName;
  GetProgramDtoEvent(this.programName);
}

class CreateNewProgramEvent extends ProgramEvent {
  final PostProgramDto program;
  CreateNewProgramEvent(this.program);
}

class GetProgramIdEvent extends ProgramEvent {
  final String programName;
  final String coachUsername;
  GetProgramIdEvent(this.programName, this.coachUsername);
}

class SendInviteEvent extends ProgramEvent {
  final PostInviteDto invite;
  SendInviteEvent(this.invite);
}

class GetInvitesSentEvent extends ProgramEvent {
  final String coachUsername;
  final String programName;
  GetInvitesSentEvent(this.coachUsername, this.programName);
}

class KickAthleteEvent extends ProgramEvent{
  final String coachUsername;
  final String programName;
  final String athleteUsername;
  KickAthleteEvent(this.coachUsername, this.programName, this.athleteUsername);
}
