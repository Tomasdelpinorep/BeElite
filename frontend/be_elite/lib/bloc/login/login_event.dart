part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class DoLoginEvent extends LoginEvent{
  final String password;
  final String username;

  DoLoginEvent({required this.password, required this.username});
}

class CheckTokenEvent extends LoginEvent {}