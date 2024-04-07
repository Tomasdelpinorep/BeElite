import 'dart:convert';

import 'package:be_elite/models/Coach/program_dto.dart';
import 'package:be_elite/models/Program/invite_dto.dart';
import 'package:be_elite/models/Program/post_program_dto.dart';
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

  @override
  Future<PostProgramDto> createNewProgram(PostProgramDto program) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await _client.post(
      Uri.parse('$urlChrome/coach/program'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('authToken')}'
      },
      body: jsonEncode(program.toJson())
    );

    if(response.statusCode == 201){
      return PostProgramDto.fromJson(json.decode(response.body));
    }else{
      throw Exception('Error creating new program.');
    }
  }

  @override
  Future<void> sendInvite(InviteDto invite) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await _client.post(
      Uri.parse('$urlChrome/coach/program'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('authToken')}'
      },
      body: jsonEncode(invite.toJson())
    );

    if(response.statusCode != 201){
      throw Exception('Error sending invite.');
    }
  }
  
  // @override
  // Future<String> getProgramId(String programName, String coachUsername) async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   final response = await _client.get(
  //     Uri.parse('$urlChrome/coach/$coachUsername/$programName/id'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer ${prefs.getString('authToken')}'
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     return json.decode(response.body);
  //   } else {
  //     throw Exception('Failed to get program dto.');
  //   }
  // }
  
}