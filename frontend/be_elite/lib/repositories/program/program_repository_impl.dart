import 'dart:convert';
import 'package:be_elite/models/Program/invite_dto.dart';
import 'package:be_elite/models/Program/post_invite_dto.dart';
import 'package:be_elite/models/Program/post_program_dto.dart';
import 'package:be_elite/models/Program/program_dto.dart';
import 'package:be_elite/repositories/program/program_repository.dart';
import 'package:be_elite/variables.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgramRepositoryImpl implements ProgramRepository {
  final Client _client = Client();

  @override
  Future<ProgramDto> getProgramDto(String programName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await _client.get(
      Uri.parse(
          '$urlChrome/coach/${prefs.getString('username')}/$programName/dto'),
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
  Future<PostProgramDto> createNewProgram(PostProgramDto program) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await _client.post(Uri.parse('$urlChrome/coach/program'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${prefs.getString('authToken')}'
        },
        body: jsonEncode(program.toJson()));

    if (response.statusCode == 201) {
      return PostProgramDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error creating new program.');
    }
  }

  @override
  Future<void> sendInvite(PostInviteDto invite) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await _client.post(Uri.parse('$urlChrome/coach/invite'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${prefs.getString('authToken')}'
        },
        body: jsonEncode(invite.toJson()));

    if (response.statusCode == 404) {
      throw Exception('No athlete matching that username was found.');
    }
  }

  @override
  Future<List<InviteDto>> getSentInvites(
      String coachUsername, String programName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(programName.isEmpty) return [];

    final response = await _client.get(
      Uri.parse('$urlChrome/coach/$coachUsername/$programName/invites'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('authToken')}'
      },
    );

    if (response.statusCode == 200) {
      // Decode the JSON response into a List<dynamic>
      List<dynamic> jsonResponse = json.decode(response.body);

      // Map each dynamic item to InviteDto and convert to List<InviteDto>
      List<InviteDto> invites =
          jsonResponse.map((item) => InviteDto.fromJson(item)).toList();

      return invites;
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('Error fetching invites: ${response.statusCode}');
    }
  }
  
  @override
  Future<void> kickAthlete(String coachUsername, String programName, String athleteUsername) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await _client.delete(
      Uri.parse('$urlChrome/coach/${coachUsername}/${programName}/kick/$athleteUsername'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('authToken')}'
      },
    );

    if (response.statusCode != 204) {
      throw Exception('There was an error kicking the athlete.');
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
