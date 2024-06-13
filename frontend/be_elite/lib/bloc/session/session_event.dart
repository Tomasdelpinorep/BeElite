part of 'session_bloc.dart';

@immutable
sealed class SessionEvent {}

class SaveNewSessionEvent extends SessionEvent {
  final PostSessionDto newSession;
  final String weekName;
  final int weekNumber;
  final String programName;
  final String coachUsername;
  SaveNewSessionEvent(this.newSession, this.weekName, this.weekNumber,
      this.programName, this.coachUsername);
}

class SaveEditedSessionEvent extends SessionEvent {
  final PostSessionDto newSession;
  final String weekName;
  final int weekNumber;
  final String programName;
  final String coachUsername;
  SaveEditedSessionEvent(this.newSession, this.weekName, this.weekNumber,
      this.programName, this.coachUsername);
}

class GetSessionCardDataEvent extends SessionEvent {
  final String athleteUsername;
  GetSessionCardDataEvent(this.athleteUsername);
}

class GetPostSessionDtoEvent extends SessionEvent {
  final String coachUsername;
  final String weekName;
  final String programName;
  final int weekNumber;
  final int sessionNumber;
  GetPostSessionDtoEvent(this.coachUsername, this.weekName, this.programName,
      this.weekNumber, this.sessionNumber);
}

class LoadNewSessionEvent extends SessionEvent {}

class DeleteSessionEvent extends SessionEvent {
  final String coachUsername;
  final String weekName;
  final String programName;
  final int weekNumber;
  final int sessionNumber;
  DeleteSessionEvent(this.coachUsername, this.weekName, this.programName,
      this.weekNumber, this.sessionNumber);
}
