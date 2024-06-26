import 'dart:async';

import 'package:be_elite/models/Auth/login_request.dart';
import 'package:be_elite/models/Auth/login_response.dart';
import 'package:be_elite/repositories/auth/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc(this.authRepository) : super(LoginInitial()) {
    on<DoLoginEvent>(_doLogin);
    on<CheckTokenEvent>(_checkToken);
  }

  void _doLogin(DoLoginEvent event, Emitter<LoginState> emitter) async {
    emitter(DoLoginLoading());

    try {
      final LoginRequest loginRequest =
          LoginRequest(username: event.username, password: event.password);

      final response = await authRepository.login(loginRequest);
      _saveAuthInfo(response.token!, response.role!, response.username!);

      emitter(DoLoginSuccess(response));
      return;
    } on Exception catch (e) {
      emitter(DoLoginError(e.toString()));
    }
  }

  Future<void> _saveAuthInfo(String token, String role, String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
    await prefs.setString('role', role);
    await prefs.setString('username', username);
  }

  Future<FutureOr<void>> _checkToken(
      CheckTokenEvent event, Emitter<LoginState> emitter) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString('role');

    try {
      final response = await authRepository.checkToken();
      emitter(CheckTokenSuccess(response, role));
    } on Exception catch (e) {
      emitter(CheckTokenError(e.toString()));
    }
  }
}
