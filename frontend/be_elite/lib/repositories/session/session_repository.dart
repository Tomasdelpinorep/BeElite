import 'package:be_elite/models/Session/post_session_dto/post_session_dto.dart';
import 'package:be_elite/models/Session/post_session_dto/session_card_dto/session_card_dto_page.dart';
import 'package:be_elite/models/Session/session_dto.dart';

abstract class SessionRepository{
  Future<SessionDto> saveNewSession(
    PostSessionDto newSession, String coachUsername, String programName, String weekName, int weekNumber);
  
  Future<SessionDto> saveEditedSession(
    PostSessionDto editedSession, String coachUsername, String programName, String weekName, int weekNumber);

  Future<SessionCardDtoPage> getSessionCardDataUpUntilToday(String athleteUsername);

  Future<PostSessionDto> getPostSessionDto(String coachUsername, String programName, String weekName, int weekNumber, int sessionNumber);

  Future<void> deleteSession(String coachUsername, String programName, String weekName, int weekNumber, int sessionNumber);
}