import 'package:be_elite/models/Coach/program_dto.dart';


class PostWeekDto {
	String? weekName;
	String? description;
	String? createdAt;
	ProgramDto? program;

	PostWeekDto({
		this.weekName, 
		this.description, 
		this.createdAt, 
		this.program, 
	});

	factory PostWeekDto.fromJson(Map<String, dynamic> json) => PostWeekDto(
				weekName: json['week_name'] as String?,
				description: json['description'] as String?,
				createdAt: json['created_at'] as String?,
				program: json['program'] == null
						? null
						: ProgramDto.fromJson(json['program'] as Map<String, dynamic>),
			);

	Map<String, dynamic> toJson() => {
				'week_name': weekName,
				'description': description,
				'created_at': createdAt,
				'program': program?.toJson(),
			};
}
