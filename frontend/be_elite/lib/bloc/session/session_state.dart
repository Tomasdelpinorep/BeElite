part of 'session_bloc.dart';

@immutable
sealed class SessionState {}

final class SessionInitial extends SessionState {}

final class SessionLoadingState extends SessionState{}

final class SessionErrorState extends SessionState{
  final String errorMessage;
  SessionErrorState(this.errorMessage);
}

final class saveNewSessionSuccessState{
  
}
