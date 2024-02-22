part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent {}

class DoRegisterEvent extends RegisterEvent{
  final String name;
  final String username;
  final String email;
  final String password;
  final String verifyPassword;
  final bool isCoach;

  DoRegisterEvent(this.name, this.username, this.email, this.password, this.verifyPassword, this.isCoach);

}
