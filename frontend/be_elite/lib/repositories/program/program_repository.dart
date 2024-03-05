import 'package:be_elite/models/Coach/program_dto.dart';

abstract class ProgramRepository{
  Future<ProgramDto> getProgramDto(String programName);
}