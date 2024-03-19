part of 'program_bloc.dart';

@immutable
sealed class ProgramEvent {}

class GetProgramDtoEvent extends ProgramEvent{
  final String programName;
  GetProgramDtoEvent(this.programName);
}

class CreateNewProgramEvent extends ProgramEvent{
  final PostProgramDto program;
  CreateNewProgramEvent(this.program);
}

class GetProgramIdEvent extends ProgramEvent{
  final String programName;
  final String coachUsername;
  GetProgramIdEvent(this.programName, this.coachUsername);
}
