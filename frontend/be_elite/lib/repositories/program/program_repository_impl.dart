import 'dart:convert';

import 'package:be_elite/models/Coach/program_dto.dart';
import 'package:be_elite/repositories/program/program_repository.dart';
import 'package:be_elite/variables.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgramRepositoryImpl implements ProgramRepository{
  final Client _client = Client();
  
  @override
  Future<ProgramDto> getProgramDto(String programName) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await _client.get(
      Uri.parse('$urlChrome/coach/${prefs.getString('username')}/$programName/dto'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('authToken')}'
      },
    );

    if (response.statusCode == 200) {
      return ProgramDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get program dto.');
    }
  }
  
}