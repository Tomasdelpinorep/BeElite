import 'package:be_elite/models/Coach/user_dto.dart';
import 'package:be_elite/models/Program/invite_dto.dart';
import 'package:be_elite/models/Program/program_dto.dart';

class AthleteDetailsDto {
  String? username;
  String? name;
  String? profilePicUrl;
  String? email;
  ProgramDto? program;
  UserDto? coach;
  int? completedSessions;
  List<InviteDto>? invites;

  AthleteDetailsDto({
    this.username,
    this.name,
    this.profilePicUrl,
    this.email,
    this.program,
    this.coach,
    this.completedSessions,
    this.invites,
  });

  factory AthleteDetailsDto.fromJson(Map<String, dynamic> json) {
    return AthleteDetailsDto(
      username: json['username'] as String?,
      name: json['name'] as String?,
      profilePicUrl: json['profilePicUrl'] as String?,
      email: json['email'] as String?,
      program: json['program'] == null
          ? null
          : ProgramDto.fromJson(json['program'] as Map<String, dynamic>),
      coach: json['coach'] == null
          ? null
          : UserDto.fromJson(json['coach'] as Map<String, dynamic>),
      completedSessions: json['completed_sessions'] as int?,
      invites: (json['invites'] as List<dynamic>?)
          ?.map((e) => InviteDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'username': username,
        'name': name,
        'profilePicUrl': profilePicUrl,
        'email': email,
        'program': program?.toJson(),
        'coach': coach?.toJson(),
        'completed_sessions': completedSessions,
        'invites': invites?.map((e) => e.toJson()).toList(),
      };
}
