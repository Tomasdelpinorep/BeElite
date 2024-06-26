import 'dart:async';

import 'package:be_elite/models/Week/edit_week_dto.dart';
import 'package:be_elite/models/Week/post_week_dto.dart';
import 'package:be_elite/models/Week/week_dto.dart';

abstract class CoachRepository {
  FutureOr<WeekDto?> getWeeks(
      String authToken, String coachUsername, String programName);

  Future<List<String>> getWeekNames(String programName);

  Future<WeekDto> saveNewWeek(PostWeekDto newWeek);

  Future<WeekDto> saveEditedWeek(EditWeekDto editedWeek);

  Future<void> deleteWeek(String coachUsername, String programName,
      String weekName, int weekNumber);
}
