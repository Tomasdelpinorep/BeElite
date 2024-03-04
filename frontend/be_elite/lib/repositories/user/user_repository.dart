import 'package:be_elite/models/Coach/coach_details.dart';

abstract class UserRepository {
  Future<CoachDetails> getCoachDetails(String coachUsername, String authToken);
}
