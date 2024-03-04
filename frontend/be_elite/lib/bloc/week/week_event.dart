part of 'week_bloc.dart';

@immutable
sealed class WeekEvent {}

class GetWeeksEvent extends WeekEvent {
  final String programName;
  GetWeeksEvent(this.programName);
}

class SaveNewWeekEvent extends WeekEvent{
  final PostWeekDto newWeek;
  SaveNewWeekEvent(this.newWeek);
}

class GetWeekNamesEvent extends WeekEvent{
  final String programName;
  GetWeekNamesEvent(this.programName);
}
