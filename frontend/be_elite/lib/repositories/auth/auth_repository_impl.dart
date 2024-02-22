import 'dart:convert';

import 'package:be_elite/models/auth/login_request.dart';
import 'package:be_elite/models/auth/login_response.dart';
import 'package:be_elite/models/auth/register_request.dart';
import 'package:be_elite/repositories/auth/auth_repository.dart';
import 'package:http/http.dart';

class AuthRepositoryImpl extends AuthRepository {
  final Client _client = Client();


  @override
  Future<LoginResponse> login(LoginRequest loginRequest) async{
    final response = await _client.post(
      Uri.parse("http://localhost:8080/auth/login"),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(loginRequest.toJson()),
    );

    if (response.statusCode == 201){
      return LoginResponse.fromJson(json.decode(response.body));
    }else{
      throw Exception('Login failed.');
    }
  }

  @override
  Future<LoginResponse> register(RegisterRequest registerRequest) async{
    Uri uri;
    registerRequest.isCoach! ? 
    uri =  Uri.parse("http://localhost:8080/auth/register") : 
    uri = Uri.parse("http://localhost:8080/auth/register");

    final response = await _client.post(
      uri,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(registerRequest.toJson()),
    );

    if(response.statusCode == 201){
      return LoginResponse.fromJson(json.decode(response.body));
    }else{
      throw Exception('Register failed');
    }
  }
}