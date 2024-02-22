part of 'register_bloc.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState{}

final class RegisterError extends RegisterState{
  final String errorMessage;
  RegisterError(this.errorMessage);
}

final class RegisterSuccess extends RegisterState{
  final LoginResponse loginResponse;
  RegisterSuccess(this.loginResponse);
}
