import 'package:be_elite/models/Program/program_dto.dart';

class EditWeekDto {
  // ignore: non_constant_identifier_names
  String? week_name;
  // ignore: non_constant_identifier_names
  String? original_name;
  String? description;
  // ignore: non_constant_identifier_names
  String? created_at;
  ProgramDto? program;
  // ignore: non_constant_identifier_names
  int? week_number;

  EditWeekDto(
      {
      // ignore: non_constant_identifier_names
      this.week_name,
      // ignore: non_constant_identifier_names
      this.original_name,
      this.description,
      // ignore: non_constant_identifier_names
      this.created_at,
      this.program,
      // ignore: non_constant_identifier_names
      this.week_number});

  factory EditWeekDto.fromJson(Map<String, dynamic> json) => EditWeekDto(
      week_name: json['week_name'] as String?,
      original_name: json['original_name'] as String?,
      description: json['description'] as String?,
      created_at: json['created_at'] as String?,
      program: json['program'] == null
          ? null
          : ProgramDto.fromJson(json['program'] as Map<String, dynamic>),
      week_number: json['week_number']);

  Map<String, dynamic> toJson() => {
        'week_name': week_name,
        'original_name': original_name,
        'description': description,
        'created_at': created_at,
        'program': program?.toJson(),
        'week_number': week_number,
      };
}
