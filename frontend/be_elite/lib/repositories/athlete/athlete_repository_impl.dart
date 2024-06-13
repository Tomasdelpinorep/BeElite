import 'dart:async';
import 'dart:convert';
import 'package:be_elite/models/Athlete/athlete_details_dto/athlete_details_dto.dart';
import 'package:be_elite/models/Coach/user_dto.dart';
import 'package:be_elite/models/Program/invite_dto.dart';
import 'package:be_elite/models/Session/Athlete%20Sessions/athlete_session_dto.dart';
import 'package:be_elite/models/Session/Athlete%20Sessions/athlete_session_id.dart';
import 'package:be_elite/models/Session/Athlete%20Sessions/block.dart';
import 'package:be_elite/repositories/athlete/athlete_repository.dart';
import 'package:be_elite/variables.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AthleteRepositoryImpl extends AthleteRepository {
  final Client _client = Client();

  @override
  Future<List<UserDto>> getAthletesByProgram(
      String coachUsername, String programName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await _client.get(
      Uri.parse('$urlChrome/$coachUsername/$programName/athletes'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('authToken')}'
      },
    );

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed.map<UserDto>((json) => UserDto.fromJson(json)).toList();
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception(
          "There was an error geting athletes for program with name: $programName.");
    }
  }

  @override
  Future<AthleteDetailsDto> getAthleteDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await _client.get(
      Uri.parse("$urlChrome/athlete/${prefs.getString('username')}"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('authToken')}'
      },
    );

    if (response.statusCode == 200) {
      return AthleteDetailsDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get athlete details.');
    }
  }

  @override
  Future<List<AthleteSessionDto>> getUpcomingWorkotus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await _client.get(
      Uri.parse(
          '$urlChrome/athlete/${prefs.getString('username')}/upcomingWorkouts'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('authToken')}'
      },
    );

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed
          .map<AthleteSessionDto>((json) => AthleteSessionDto.fromJson(json))
          .toList();
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception("There was an error geting upcoming workouts.");
    }
  }

  @override
  Future<List<AthleteSessionDto>> getPreviousWorkotus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await _client.get(
      Uri.parse(
          '$urlChrome/athlete/${prefs.getString('username')}/previousWorkouts'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('authToken')}'
      },
    );

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed
          .map<AthleteSessionDto>((json) => AthleteSessionDto.fromJson(json))
          .toList();
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception("There was an error geting previous workouts.");
    }
  }

  @override
  Future<AthleteBlockDto> saveBlockDto(AthleteBlockDto block) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response =
        await _client.put(Uri.parse('$urlChrome/athlete/saveBlock'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${prefs.getString('authToken')}'
            },
            body: json.encode(block));

    if (response.statusCode == 200) {
      return AthleteBlockDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to save athlete block.');
    }
  }

  @override
  Future<AthleteBlockDto> changeBlockDoneStatus(AthleteBlockDto block) async {
    block.isCompleted = !block.isCompleted!;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response =
        await _client.put(Uri.parse('$urlChrome/athlete/saveBlock'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${prefs.getString('authToken')}'
            },
            body: json.encode(block));

    if (response.statusCode == 200) {
      return AthleteBlockDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to save athlete block.');
    }
  }

  @override
  Future<AthleteSessionDto> completeSession(AthleteSessionId id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response =
        await _client.put(Uri.parse('$urlChrome/athlete/session/setAsDone'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${prefs.getString('authToken')}'
            },
            body: json.encode(id));

    if (response.statusCode == 200) {
      return AthleteSessionDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to set session as done.');
    }
  }

  @override
  Future<AthleteSessionDto?> updateSession(AthleteSessionId id) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await _client.put(
      Uri.parse(
          '$urlChrome/athlete/session/update'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('authToken')}'
      },
      body: json.encode(id)
    );

    if (response.statusCode == 200) {
      return AthleteSessionDto.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception("There was an error updating the session.");
    }
  }

  @override
  Future<InviteDto> manageInvitation(InviteDto invite) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await _client.put(
      Uri.parse(
          '$urlChrome/athlete/invite'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('authToken')}'
      },
      body: json.encode(invite)
    );

    if (response.statusCode == 200) {
      return InviteDto.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      return InviteDto();
    } else {
      throw Exception("There was an error updating the session.");
    }
  }
}
