import 'dart:async';

import 'package:be_elite/models/Session/post_session_dto/post_session_dto.dart';
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
  }

  FutureOr<void> _saveNewSession(SaveNewSessionEvent event, Emitter<SessionState> emit) async{
    emit(SessionLoadingState());

    try{
      final response = await sessionRepository.saveNewSession( event.newSession, event.coachUsername, event.programName, event.weekName, event.weekNumber);

      emit(SaveNewSessionSuccessState(response));
    }on Exception catch(e){
      emit(SessionErrorState(e.toString()));
    }
  }
}
