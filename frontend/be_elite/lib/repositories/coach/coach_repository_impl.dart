import 'dart:convert';

import 'package:be_elite/models/Week/week_dto.dart';
import 'package:be_elite/repositories/coach/coach_repository.dart';
import 'package:be_elite/variables.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoachRepositoryImpl extends CoachRepository {
  final Client _client = Client();

  @override
  Future<WeekDto> getWeeks(
      String authToken, String coachUsername, String programName) async {
    final response = await _client.get(
      Uri.parse('$urlChrome/coach/$coachUsername/$programName/weeks'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken'
      },
    );

    if (response.statusCode == 200) {
      return WeekDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get week data.');
    }
  }

  @override
  Future<List<String>> getWeekNames(String programName) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await _client.get(
      Uri.parse('$urlChrome/coach/${prefs.getString('username')}/$programName/weeks/names'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('authToken')}'
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> decodedData = json.decode(response.body);
      List<String> weekNames = List<String>.from(decodedData);
      return weekNames;
    } else {
      throw Exception('Failed to get week data.');
    }
  }
  }
