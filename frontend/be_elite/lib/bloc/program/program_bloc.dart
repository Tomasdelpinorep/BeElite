import 'dart:async';

import 'package:be_elite/models/Coach/program_dto.dart';
import 'package:be_elite/models/Program/post_program_dto.dart';
import 'package:be_elite/repositories/program/program_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'program_event.dart';
part 'program_state.dart';

class ProgramBloc extends Bloc<ProgramEvent, ProgramState> {
  final ProgramRepository programRepository;

  ProgramBloc(this.programRepository) : super(ProgramInitial()) {
    on<GetProgramDtoEvent>(_getProgramDto);
    on<CreateNewProgramEvent>(_createNewProgram);
  }

  FutureOr<void> _getProgramDto(GetProgramDtoEvent event, Emitter<ProgramState> emit) async{
    try{
      final response = await programRepository.getProgramDto(event.programName);

      emit(GetProgramDtoSuccessState(response));
    }on Exception catch(e){
      emit(ProgramErrorState(e.toString()));
    }
  }

  FutureOr<void> _createNewProgram(CreateNewProgramEvent event, Emitter<ProgramState> emit) async{
    emit(ProgramLoadingState());

    try{
      final response = await programRepository.createNewProgram(event.program);

      emit(CreateProgramSuccessState(response));
    }on Exception catch(e){
      emit(ProgramErrorState(e.toString()));
    }
  }
}