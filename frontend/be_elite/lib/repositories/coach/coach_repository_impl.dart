import 'dart:async';
import 'dart:convert';
import 'package:be_elite/models/Week/edit_week_dto.dart';
import 'package:be_elite/models/Week/post_week_dto.dart';
import 'package:be_elite/models/Week/week_dto.dart';
import 'package:be_elite/repositories/coach/coach_repository.dart';
import 'package:be_elite/variables.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoachRepositoryImpl extends CoachRepository {
  final Client _client = Client();

  @override
  FutureOr<WeekDto?> getWeeks(
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
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to get week data.');
    }
  }

  @override
  Future<List<String>> getWeekNames(String programName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await _client.get(
      Uri.parse(
          '$urlChrome/coach/${prefs.getString('username')}/$programName/weeks/names'),
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

  @override
  Future<WeekDto> saveNewWeek(PostWeekDto newWeek) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await _client.post(
        //changed here, might break something
        Uri.parse('$urlChrome/coach/${prefs.getString('username')}/weeks/new'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${prefs.getString('authToken')}'
        },
        body: jsonEncode(newWeek.toJson()));

    if (response.statusCode == 201) {
      return WeekDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('There was an error saving new week.');
    }
  }

  @override
  Future<WeekDto> saveEditedWeek(EditWeekDto editedWeek) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await _client.put(
        Uri.parse('$urlChrome/coach/${prefs.getString('username')}/weeks/edit'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${prefs.getString('authToken')}'
        },
        body: jsonEncode(editedWeek.toJson()));

    if (response.statusCode == 200) {
      return WeekDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('There was an error saving the week.');
    }
  }

  @override
  Future<void> deleteWeek(String coachUsername, String programName,
      String weekName, int weekNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await _client.delete(
      Uri.parse(
          '$urlChrome/coach/${prefs.getString('username')}/$programName/weeks/$weekName/$weekNumber'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('authToken')}'
      },
    );

    if (response.statusCode != 204) {
      throw Exception('There was an error deleting the week.');
    }
  }
}
