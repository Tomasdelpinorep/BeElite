import 'dart:convert';

import 'package:be_elite/models/Auth/login_request.dart';
import 'package:be_elite/models/Auth/login_response.dart';
import 'package:be_elite/models/Auth/register_request.dart';
import 'package:be_elite/repositories/auth/auth_repository.dart';
import 'package:be_elite/variables.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl extends AuthRepository {
  final Client _client = Client();

  @override
  Future<LoginResponse> login(LoginRequest loginRequest) async {
    final response = await _client.post(
      Uri.parse("${urlChrome}/auth/login"),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(loginRequest.toJson()),
    );

    if (response.statusCode == 201) {
      return LoginResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Login failed.');
    }
  }

  @override
  Future<LoginResponse> register(RegisterRequest registerRequest) async {
    Uri uri;
    uri = Uri.parse("$urlChrome/auth/register");

    final response = await _client.post(
      uri,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(registerRequest.toJson()),
    );

    if (response.statusCode == 201) {
      return LoginResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Register failed');
    }
  }

  @override
  Future<bool> checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await _client.post(
        Uri.parse("$urlChrome/auth/validateToken"),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: prefs.getString('authToken'));

    if (response.statusCode == 202) {
      return true;
    } else {
      return false;
    }
  }
}
