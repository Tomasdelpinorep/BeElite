part of 'session_bloc.dart';

@immutable
sealed class SessionState {}

final class SessionInitial extends SessionState {}

final class SessionLoadingState extends SessionState{}

final class SessionErrorState extends SessionState{
  final String errorMessage;
  SessionErrorState(this.errorMessage);
}

final class SaveNewSessionSuccessState extends SessionState{
  final SessionDto session;
  SaveNewSessionSuccessState(this.session);
}

final class GetSessionCardDataSuccessState extends SessionState{
  final SessionCardDto session;
  GetSessionCardDataSuccessState(this.session);
}

final class GetPostSessionDtoSuccessState extends SessionState{
  final PostSessionDto session;
  GetPostSessionDtoSuccessState(this.session);
}
