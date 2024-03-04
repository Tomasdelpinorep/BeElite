import 'dart:convert';

import 'package:be_elite/models/Coach/coach_details.dart';
import 'package:be_elite/repositories/user/user_repository.dart';
import 'package:http/http.dart';

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
}
