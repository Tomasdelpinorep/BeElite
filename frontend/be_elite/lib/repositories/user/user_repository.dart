import 'package:be_elite/models/Coach/coach_details.dart';
import 'package:be_elite/models/Coach/user_dto.dart';

abstract class UserRepository {
  Future<CoachDetails> getCoachDetails(String coachUsername, String authToken);
  Future<UserDto> getOldestAthleteInProgram(String coachUsername);
  Future<int> getTotalNumberOfSessionsCompleted(String coachUsername);
}
