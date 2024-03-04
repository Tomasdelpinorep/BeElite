part of 'week_bloc.dart';

@immutable
sealed class WeekEvent {}

class GetWeeksEvent extends WeekEvent {
  final String programName;
  GetWeeksEvent(this.programName);
}
