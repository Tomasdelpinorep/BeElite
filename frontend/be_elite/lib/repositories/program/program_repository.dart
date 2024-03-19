import 'package:be_elite/models/Coach/program_dto.dart';
import 'package:be_elite/models/Program/post_program_dto.dart';

abstract class ProgramRepository{
  Future<ProgramDto> getProgramDto(String programName);
  Future<PostProgramDto> createNewProgram(PostProgramDto program);
  // Future<String> getProgramId(String programName, String coachUsername);
}