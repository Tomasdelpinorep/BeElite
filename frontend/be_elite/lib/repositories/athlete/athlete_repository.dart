import 'package:be_elite/models/Athlete/athlete_details_dto/athlete_details_dto.dart';
import 'package:be_elite/models/Coach/user_dto.dart';
import 'package:be_elite/models/Session/Athlete%20Sessions/athlete_session_dto.dart';
import 'package:be_elite/models/Session/Athlete%20Sessions/athlete_session_id.dart';
import 'package:be_elite/models/Session/Athlete%20Sessions/block.dart';

abstract class AthleteRepository {
  Future<List<UserDto>> getAthletesByProgram(
      String coachUsername, String programName);
  Future<AthleteDetailsDto> getAthleteDetails();
  Future<List<AthleteSessionDto>> getUpcomingWorkotus();
  Future<List<AthleteSessionDto>> getPreviousWorkotus();
  Future<AthleteBlockDto> saveBlockDto(AthleteBlockDto block);
  Future<AthleteBlockDto> changeBlockDoneStatus(AthleteBlockDto block);
  Future<AthleteSessionDto?> updateSession(AthleteSessionId id);
  Future<AthleteSessionDto?> completeSession(AthleteSessionId id);
}
