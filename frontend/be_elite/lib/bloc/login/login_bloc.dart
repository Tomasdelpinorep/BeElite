import 'package:be_elite/models/auth/login_request.dart';
import 'package:be_elite/models/auth/login_response.dart';
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
  }

  void _doLogin(DoLoginEvent event, Emitter<LoginState> emitter)async{
    emitter(DoLoginLoading());

    try{
      final LoginRequest loginRequest =
      LoginRequest(username: event.username, password: event.password);

      final response = await authRepository.login(loginRequest);
      _saveAuthTokenAndRole(response.token!, response.role!);

      emitter(DoLoginSuccess(response));
      return;
    }on Exception catch(e){
      emitter(DoLoginError(e.toString()));
    }
  }

  Future<void> _saveAuthTokenAndRole(String token, String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
    await prefs.setString('userRole', role);
  }
}
