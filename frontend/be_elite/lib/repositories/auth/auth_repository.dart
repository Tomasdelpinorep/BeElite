import 'package:be_elite/models/Auth/login_request.dart';
import 'package:be_elite/models/Auth/login_response.dart';
import 'package:be_elite/models/Auth/register_request.dart';

abstract class AuthRepository{
  Future<LoginResponse> login(LoginRequest loginRequest);
  Future<LoginResponse> register(RegisterRequest registerRequest);
  Future<bool> checkToken();
}