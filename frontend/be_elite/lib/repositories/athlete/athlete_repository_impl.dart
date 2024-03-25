import 'dart:convert';
import 'package:be_elite/models/Coach/user_dto.dart';
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
    }else if(response.statusCode == 404){
      return [];
    } else {
      throw Exception(
          "There was an error geting athletes for program with name: $programName.");
    }
  }
}
