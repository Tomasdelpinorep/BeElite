import 'package:be_elite/models/Auth/login_response.dart';
import 'package:be_elite/models/Auth/register_request.dart';
import 'package:be_elite/repositories/auth/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository authRepository;

  RegisterBloc(this.authRepository) : super(RegisterInitial()) {
    on<DoRegisterEvent>(_doRegister);
  }

  void _doRegister(
      DoRegisterEvent event, Emitter<RegisterState> emitter) async {
    emitter(RegisterLoading());

    try {
      RegisterRequest registerRequest = RegisterRequest(
          name: event.name,
          username: event.username,
          email: event.email,
          password: event.password,
          verifyPassword: event.verifyPassword,
          userType: event.userType);

      final response = await authRepository.register(registerRequest);
      _saveAuthInfo(response.token!, response.role!, response.username!);
      emitter(RegisterSuccess(response));
    } on Exception catch (e) {
      emitter(RegisterError(e.toString()));
    }
  }

  Future<void> _saveAuthInfo(String token, String role, String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
    await prefs.setString('role', role);
    await prefs.setString('username', username);
  }
}
