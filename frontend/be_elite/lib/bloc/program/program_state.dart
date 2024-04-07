part of 'program_bloc.dart';

@immutable
sealed class ProgramState {}

final class ProgramInitial extends ProgramState {}

final class ProgramLoadingState extends ProgramState{}

final class ProgramErrorState extends ProgramState{
  final String errorMessage;
  ProgramErrorState(this.errorMessage);
}

final class GetProgramDtoSuccessState extends ProgramState{
  final ProgramDto programDto;
  GetProgramDtoSuccessState(this.programDto);
}

final class CreateProgramSuccessState extends ProgramState{
  final PostProgramDto program;
  CreateProgramSuccessState(this.program);
}

final class SendInviteSuccessState extends ProgramState{}

final class GetInvitesSentSuccessState extends ProgramState{
  final List<InviteDto> invites;
  GetInvitesSentSuccessState(this.invites);
}

