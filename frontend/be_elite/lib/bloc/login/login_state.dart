part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class DoLoginLoading extends LoginState {}

final class DoLoginSuccess extends LoginState {
  final LoginResponse userLogin;
  DoLoginSuccess(this.userLogin);
}

final class DoLoginError extends LoginState {
  final String errorMessage;
  DoLoginError(this.errorMessage);
}

final class CheckTokenSuccess extends LoginState {
  final bool isValid;
  final String? role;
  CheckTokenSuccess(this.isValid, this.role);
}

final class CheckTokenError extends LoginState {
  final String errorMessage;
  CheckTokenError(this.errorMessage);
}
