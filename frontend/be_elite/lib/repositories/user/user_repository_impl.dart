import 'dart:convert';

import 'package:be_elite/models/Coach/coach_details.dart';
import 'package:be_elite/models/Coach/user_dto.dart';
import 'package:be_elite/repositories/user/user_repository.dart';
import 'package:be_elite/variables.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepositoryImpl extends UserRepository {
  final Client _client = Client();

  @override
  Future<CoachDetails> getCoachDetails(
      String coachUsername, String authToken) async {
    final response = await _client.get(
      Uri.parse("http://localhost:8080/coach/$coachUsername"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken'
      },
    );

    if (response.statusCode == 200) {
      return CoachDetails.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get coach details.');
    }
  }

  @override
  Future<UserDto> getOldestAthleteInProgram(String coachUsername) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await _client.get(
      Uri.parse('$urlChrome/$coachUsername/oldestAthlete'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('authToken')}'
      },
    );

    if(response.statusCode == 200){
      return UserDto.fromJson(json.decode(response.body));
    }else{
      throw Exception("Error getting athlete from program.");
    }
  }
  
  @override
  Future<int> getTotalNumberOfSessionsCompleted(String coachUsername) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await _client.get(
      Uri.parse('$urlChrome/coach/$coachUsername/totalSessionsCompleted'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('authToken')}'
      },
    );

    if(response.statusCode == 200){
      return json.decode(response.body);
    }else{
      throw Exception("Error getting number of completed sessions.");
    }
  }
}
