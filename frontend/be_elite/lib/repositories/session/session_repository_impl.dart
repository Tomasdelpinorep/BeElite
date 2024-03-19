import 'dart:convert';
import 'package:be_elite/models/Session/post_session_dto/post_session_dto.dart';
import 'package:be_elite/models/Session/session_card_dto/session_card_dto.dart';
import 'package:be_elite/models/Session/session_dto.dart';
import 'package:be_elite/repositories/session/session_repository.dart';
import 'package:be_elite/variables.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionRepositoryImpl extends SessionRepository {  
  final Client _client = Client();

  @override
  Future<SessionDto> saveNewSession(
    PostSessionDto newSession, String coachUsername, String programName, String weekName, int weekNumber) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await _client.post(
      Uri.parse('$urlChrome/$coachUsername/$programName/$weekName/$weekNumber/sessions/new'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('authToken')}'
      },
      body: jsonEncode(newSession.toJson())
    );

    if(response.statusCode == 201){
      return SessionDto.fromJson(json.decode(response.body));
    }else{
      throw Exception("There was an error creating new session.");
    }
  }

  @override
  Future<SessionCardDto> getSessionCardData(
    String coachUsername, String programName, String weekName, int weekNumber) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await _client.get(
      Uri.parse('$urlChrome/$coachUsername/$programName/$weekName/$weekNumber/sessions'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('authToken')}'
      },
    );

    if(response.statusCode == 200){
      return SessionCardDto.fromJson(json.decode(response.body));
    }else{
      throw Exception("There was an error fetching session data.");
    }
  }
  
  @override
  Future<PostSessionDto> getPostSessionDto(String coachUsername, String programName, String weekName, int weekNumber) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await _client.get(
      Uri.parse('$urlChrome/$coachUsername/$programName/$weekName/$weekNumber/sessions/edit'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('authToken')}'
      },
    );

    if(response.statusCode == 200){
      return PostSessionDto.fromJson(json.decode(response.body));
    }else{
      throw Exception("There was an error fetching session data.");
    }
  }
}
