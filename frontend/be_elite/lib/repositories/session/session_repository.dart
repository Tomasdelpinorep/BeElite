import 'package:be_elite/models/Session/post_session_dto/post_session_dto.dart';
import 'package:be_elite/models/Session/session_card_dto/session_card_dto.dart';
import 'package:be_elite/models/Session/session_dto.dart';

abstract class SessionRepository{
  Future<SessionDto> saveNewSession(
    PostSessionDto newSession, String coachUsername, String programName, String weekName, int weekNumber);

  Future<SessionCardDto> getSessionCardData(String coachUsername, String programName, String weekName, int weekNumber);

  Future<PostSessionDto> getPostSessionDto(String coachUsername, String programName, String weekName, int weekNumber);
}