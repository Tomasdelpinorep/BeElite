import 'dart:async';

import 'package:be_elite/models/Coach/user_dto.dart';
import 'package:be_elite/repositories/athlete/athlete_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'athlete_event.dart';
part 'athlete_state.dart';

class AthleteBloc extends Bloc<AthleteEvent, AthleteState> {
  AthleteRepository athleteRepository;

  AthleteBloc(this.athleteRepository) : super(AthleteInitialState()) {
    on<GetAthletesByProgramEvent>(_getAthletesByProgram);
  }
  

  FutureOr<void> _getAthletesByProgram(GetAthletesByProgramEvent event, Emitter<AthleteState> emit) async{
    emit(AthleteLoadingState());

    try{
      final List<UserDto> response = await athleteRepository.getAthletesByProgram(event.coachUsername, event.programName);
      if(response.isEmpty){
        emit(GetAthletesByProgramEmptyState());
      }else{
        emit(GetAthletesByProgramSuccessState(response));
      }
    }on Exception catch(e){
      emit(AthleteErrorState(e.toString()));
    }
  }
}
