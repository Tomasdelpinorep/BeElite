part of 'week_bloc.dart';

@immutable
sealed class WeekEvent {}

class GetWeeksEvent extends WeekEvent {
  final String programName;
  GetWeeksEvent(this.programName);
}

class SaveNewWeekEvent extends WeekEvent {
  final PostWeekDto newWeek;
  SaveNewWeekEvent(this.newWeek);
}

class GetWeekNamesEvent extends WeekEvent {
  final String programName;
  GetWeekNamesEvent(this.programName);
}

class SaveEditedWeekEvent extends WeekEvent {
  final EditWeekDto editedWeek;
  SaveEditedWeekEvent(this.editedWeek);
}

class DeleteWeekEvent extends WeekEvent {
  final String coachUsername;
  final String programName;
  final String weekName;
  final int weekNumber;
  DeleteWeekEvent(
      this.coachUsername, this.programName, this.weekName, this.weekNumber);
}
