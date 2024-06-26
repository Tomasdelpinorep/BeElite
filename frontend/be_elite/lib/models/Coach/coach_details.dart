import 'package:be_elite/models/Coach/user_dto.dart';
import 'package:be_elite/models/Program/program_dto.dart';

class CoachDetails {
  String? id;
  String? username;
  String? name;
  String? email;
  String? profilePicUrl;
  DateTime? createdAt;
  List<UserDto>? athletes;
  List<ProgramDto>? programs;

  CoachDetails({
    this.id,
    this.username,
    this.name,
    this.email,
    this.profilePicUrl,
    this.createdAt,
    this.athletes,
    this.programs,
  });

  factory CoachDetails.fromJson(Map<String, dynamic> json) => CoachDetails(
        id: json['id'] as String?,
        username: json['username'] as String?,
        name: json['name'] as String?,
        email: json['email'] as String?,
        profilePicUrl: json['profilePicUrl'] as String?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        athletes: (json['athletes'] as List<dynamic>?)
            ?.map((e) => UserDto.fromJson(e as Map<String, dynamic>))
            .toList(),
        programs: (json['programs'] as List<dynamic>?)
            ?.map((e) => ProgramDto.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'name': name,
        'email': email,
        'profilePicUrl': profilePicUrl,
        'createdAt': createdAt?.toIso8601String(),
        'athletes': athletes?.map((e) => e.toJson()).toList(),
        'programs': programs?.map((e) => e.toJson()).toList(),
      };
}
