import 'package:be_elite/models/auth/login_request.dart';
import 'package:be_elite/models/auth/login_response.dart';
import 'package:be_elite/models/auth/register_request.dart';

abstract class AuthRepository{
  Future<LoginResponse> login(LoginRequest loginRequest);
  Future<LoginResponse> register(RegisterRequest registerRequest);
}