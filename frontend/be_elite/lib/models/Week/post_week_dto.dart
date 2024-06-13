import 'package:be_elite/models/Program/program_dto.dart';

class PostWeekDto {
  String? weekName;
  String? description;
  String? createdAt;
  ProgramDto? program;
  List<String>? span;

  PostWeekDto({
    this.weekName,
    this.description,
    this.createdAt,
    this.program,
    this.span,
  });

  factory PostWeekDto.fromJson(Map<String, dynamic> json) => PostWeekDto(
        weekName: json['week_name'] as String?,
        description: json['description'] as String?,
        createdAt: json['created_at'] as String?,
        program: json['program'] == null
            ? null
            : ProgramDto.fromJson(json['program'] as Map<String, dynamic>),
        span: json['span'] as List<String>?,
      );

  Map<String, dynamic> toJson() => {
        'week_name': weekName,
        'description': description,
        'created_at': createdAt,
        'program': program?.toJson(),
        'span': span,
      };
}
