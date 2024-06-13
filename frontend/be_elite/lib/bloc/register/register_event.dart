part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent {}

class DoRegisterEvent extends RegisterEvent {
  final String name;
  final String username;
  final String email;
  final String password;
  final String verifyPassword;
  final String userType;

  DoRegisterEvent(
      {required this.name,
      required this.username,
      required this.email,
      required this.password,
      required this.verifyPassword,
      required this.userType});
}
