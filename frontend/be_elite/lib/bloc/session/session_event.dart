part of 'session_bloc.dart';

@immutable
sealed class SessionEvent {}

class SaveNewSessionEvent extends SessionEvent{
  final PostSessionDto newSession;
  final String weekName;
  final int weekNumber;
  final String programName;
  final String coachUsername;
  SaveNewSessionEvent(this.newSession, this.weekName, this.weekNumber, this.programName, this.coachUsername);
}
