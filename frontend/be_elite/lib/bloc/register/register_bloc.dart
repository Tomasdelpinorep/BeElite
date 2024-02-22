import 'package:be_elite/models/auth/login_response.dart';
import 'package:be_elite/models/auth/register_request.dart';
import 'package:be_elite/repositories/auth/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBlocBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository authRepository;

  RegisterBlocBloc(this.authRepository) : super(RegisterInitial()) {
    on<DoRegisterEvent>(_doRegister);
  }

  void _doRegister(DoRegisterEvent event, Emitter<RegisterState> emitter) async{
    emitter(RegisterLoading());

    try{
      RegisterRequest registerRequest =
      RegisterRequest(name: event.name, username: event.username, email: event.email,
      password: event.password, verifyPassword: event.verifyPassword, isCoach: event.isCoach);

      final response = await authRepository.register(registerRequest);
      emitter(RegisterSuccess(response));
    }on Exception catch(e){
      emitter(RegisterError(e.toString()));
    }
  }
}
