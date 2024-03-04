import 'package:be_elite/models/Week/week_dto.dart';

abstract class CoachRepository {
  Future<WeekDto> getWeeks(
      String authToken, String coachUsername, String programName);
}
