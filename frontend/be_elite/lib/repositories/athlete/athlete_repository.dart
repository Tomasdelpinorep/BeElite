import 'package:be_elite/models/Coach/user_dto.dart';

abstract class AthleteRepository{
  Future<List<UserDto>> getAthletesByProgram(String coachUsername, String programName);
}