import 'dart:async';
import 'package:be_elite/models/Session/post_session_dto/post_session_dto.dart';
import 'package:be_elite/models/Session/session_card_dto/session_card_dto_page.dart';
import 'package:be_elite/models/Session/session_dto.dart';
import 'package:be_elite/repositories/session/session_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'session_event.dart';
part 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final SessionRepository sessionRepository;

  SessionBloc(this.sessionRepository) : super(SessionInitial()) {
    on<SaveNewSessionEvent>(_saveNewSession);
    on<SaveEditedSessionEvent>(_saveEditedSession);
    on<GetSessionCardDataEvent>(_getSessionCardData);
    on<GetPostSessionDtoEvent>(_getPostSessionDto);
    on<LoadNewSessionEvent>(_loadNewSession);
    on<DeleteSessionEvent>(_deleteSession);
  }

  FutureOr<void> _saveNewSession(
      SaveNewSessionEvent event, Emitter<SessionState> emit) async {
    emit(SessionLoadingState());

    try {
      final response = await sessionRepository.saveNewSession(
          event.newSession,
          event.coachUsername,
          event.programName,
          event.weekName,
          event.weekNumber);

      emit(SaveNewSessionSuccessState(response));
    } on Exception catch (e) {
      emit(SessionErrorState(e.toString()));
    }
  }

  FutureOr<void> _saveEditedSession(
      SaveEditedSessionEvent event, Emitter<SessionState> emit) async {
    emit(SessionLoadingState());

    try {
      final response = await sessionRepository.saveEditedSession(
          event.newSession,
          event.coachUsername,
          event.programName,
          event.weekName,
          event.weekNumber);

      emit(SaveEditedSessionSuccessState(response));
    } on Exception catch (e) {
      emit(SessionErrorState(e.toString()));
    }
  }

  FutureOr<void> _getSessionCardData(
      GetSessionCardDataEvent event, Emitter<SessionState> emit) async {
    emit(SessionLoadingState());

    try {
      final response = await sessionRepository
          .getSessionCardDataUpUntilToday(event.athleteUsername);

      if (response.sessionCardDtos == null ||
          response.sessionCardDtos!.isEmpty) {
        emit(GetSessionCardDataIsEmptyState(response));
      } else {
        emit(GetSessionCardDataSuccessState(response));
      }
    } on Exception catch (e) {
      emit(SessionErrorState(e.toString()));
    }
  }

  FutureOr<void> _getPostSessionDto(
      GetPostSessionDtoEvent event, Emitter<SessionState> emit) async {
    emit(SessionLoadingState());

    try {
      final response = await sessionRepository.getPostSessionDto(
          event.coachUsername,
          event.programName,
          event.weekName,
          event.weekNumber,
          event.sessionNumber);

      emit(GetPostSessionDtoSuccessState(response));
    } on Exception catch (e) {
      emit(SessionErrorState(e.toString()));
    }
  }

  FutureOr<void> _loadNewSession(
      LoadNewSessionEvent event, Emitter<SessionState> emit) {
    //Pretty stupid but it works to make the new session page not throw erros when trying to edit an existing session.
    //Prevents it from trying to load with no controllers.
    emit(LoadNewSessionSuccessState());
  }

  FutureOr<void> _deleteSession(
      DeleteSessionEvent event, Emitter<SessionState> emit) {
    emit(SessionLoadingState());

    try {
      sessionRepository.deleteSession(event.coachUsername, event.programName,
          event.weekName, event.weekNumber, event.sessionNumber);
      emit(DeleteSessionSuccessState());
    } on Exception catch (e) {
      emit(SessionErrorState(e.toString()));
    }
  }
}
