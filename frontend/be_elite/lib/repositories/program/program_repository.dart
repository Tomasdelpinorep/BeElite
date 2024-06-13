import 'package:be_elite/models/Program/invite_dto.dart';
import 'package:be_elite/models/Program/post_invite_dto.dart';
import 'package:be_elite/models/Program/post_program_dto.dart';
import 'package:be_elite/models/Program/program_dto.dart';

abstract class ProgramRepository {
  Future<ProgramDto> getProgramDto(String programName);
  Future<PostProgramDto> createNewProgram(PostProgramDto program);
  // Future<String> getProgramId(String programName, String coachUsername);
  Future<void> sendInvite(PostInviteDto invite);
  Future<List<InviteDto>> getSentInvites(String coachUsername, String programName);
  Future<void> kickAthlete(String coachUsername, String programUsername, String athleteUsername);
}
