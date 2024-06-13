import 'dart:async';
import 'package:be_elite/models/Athlete/athlete_details_dto/athlete_details_dto.dart';
import 'package:be_elite/models/Coach/user_dto.dart';
import 'package:be_elite/models/Session/Athlete%20Sessions/athlete_session_dto.dart';
import 'package:be_elite/models/Session/Athlete%20Sessions/athlete_session_id.dart';
import 'package:be_elite/models/Session/Athlete%20Sessions/block.dart';
import 'package:be_elite/repositories/athlete/athlete_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'athlete_event.dart';
part 'athlete_state.dart';

class AthleteBloc extends Bloc<AthleteEvent, AthleteState> {
  AthleteRepository athleteRepository;

  AthleteBloc(this.athleteRepository) : super(AthleteInitialState()) {
    on<GetAthletesByProgramEvent>(_getAthletesByProgram);
    on<GetAthleteDetailsEvent>(_getAthleteDetails);
    on<GetUpcomingWorkoutsEvent>(_getUpcomingWorkouts);
    on<GetPreviousWorkoutsEvent>(_getPreviousWorkouts);
    on<SaveAthleteBlockEvent>(_saveAthleteBlock);
    on<ChangeBlockDoneStatusEvent>(_changeBlockDoneStatus);
    on<UpdateAthleteSessionEvent>(_updateSession);
    on<CompleteSessionEvent>(_completeSession);
  }

  FutureOr<void> _getAthletesByProgram(
      GetAthletesByProgramEvent event, Emitter<AthleteState> emit) async {
    emit(AthleteLoadingState());

    try {
      final List<UserDto> response = await athleteRepository
          .getAthletesByProgram(event.coachUsername, event.programName);
      if (response.isEmpty) {
        emit(GetAthletesByProgramEmptyState());
      } else {
        emit(GetAthletesByProgramSuccessState(response));
      }
    } on Exception catch (e) {
      emit(AthleteErrorState(e.toString()));
    }
  }

  FutureOr<void> _getAthleteDetails(
      GetAthleteDetailsEvent event, Emitter<AthleteState> emit) async {
    emit(AthleteLoadingState());

    try {
      final response = await athleteRepository.getAthleteDetails();

      emit(AthleteDetailsSuccessState(response));
    } on Exception catch (e) {
      emit(AthleteErrorState(e.toString()));
    }
  }

  FutureOr<void> _getUpcomingWorkouts(
      GetUpcomingWorkoutsEvent event, Emitter<AthleteState> emit) async {
    emit(AthleteLoadingState());

    try {
      final response = await athleteRepository.getUpcomingWorkotus();
      emit(GetUpcomingWorkoutsSuccessState(response));
    } on Exception catch (e) {
      emit(AthleteErrorState(e.toString()));
    }
  }

  FutureOr<void> _getPreviousWorkouts(
      GetPreviousWorkoutsEvent event, Emitter<AthleteState> emit) async {
    emit(AthleteLoadingState());

    try {
      final response = await athleteRepository.getPreviousWorkotus();
      emit(GetPreviousWorkoutsSuccessState(response));
    } on Exception catch (e) {
      emit(AthleteErrorState(e.toString()));
    }
  }

  FutureOr<void> _saveAthleteBlock(SaveAthleteBlockEvent event, Emitter<AthleteState> emit) async {

    try {
      final response = await athleteRepository.saveBlockDto(event.block);
      emit(AthleteBlockSaveSuccessState(response));
    } on Exception catch (e) {
      emit(AthleteErrorState(e.toString()));
    }
  }

  FutureOr<void> _updateSession(UpdateAthleteSessionEvent event, Emitter<AthleteState> emit) async {
    emit(AthleteLoadingState());

    try {
      final AthleteSessionDto? response = await athleteRepository.updateSession(event.id);
        emit(UpdateAthleteSessionSuccessState(response));
    } on Exception catch (e) {
      emit(AthleteErrorState(e.toString()));
    }
  }

  FutureOr<void> _changeBlockDoneStatus(ChangeBlockDoneStatusEvent event, Emitter<AthleteState> emit) async{
    try {
      final response = await athleteRepository.changeBlockDoneStatus(event.block);
      emit(AthleteBlockSaveSuccessState(response));
    } on Exception catch (e) {
      emit(AthleteErrorState(e.toString()));
    }
  }

  FutureOr<void> _completeSession(CompleteSessionEvent event, Emitter<AthleteState> emit) async{
    try {
      final response = await athleteRepository.completeSession(event.id);
      emit(UpdateAthleteSessionSuccessState(response));
    } on Exception catch (e) {
      emit(AthleteErrorState(e.toString()));
    }
  }
}
