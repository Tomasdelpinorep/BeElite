part of 'program_bloc.dart';

@immutable
sealed class ProgramState {}

final class ProgramInitial extends ProgramState {}

final class ProgramErrorState extends ProgramState{
  final String errorMessage;
  ProgramErrorState(this.errorMessage);
}

final class GetProgramDtoSuccessState extends ProgramState{
  final ProgramDto programDto;
  GetProgramDtoSuccessState(this.programDto);
}
