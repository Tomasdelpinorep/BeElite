import 'package:be_elite/models/login/login_request.dart';
import 'package:be_elite/models/login/login_response.dart';

abstract class AuthRepository{
  Future<LoginResponse> login(LoginRequest loginRequest);
}