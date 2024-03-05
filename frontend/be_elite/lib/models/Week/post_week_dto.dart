import 'package:be_elite/models/Coach/program_dto.dart';


class PostWeekDto {
	String? week_name;
	String? description;
	String? created_at;
	ProgramDto? program;

	PostWeekDto({
		this.week_name, 
		this.description, 
		this.created_at, 
		this.program, 
	});

	factory PostWeekDto.fromJson(Map<String, dynamic> json) => PostWeekDto(
				week_name: json['week_name'] as String?,
				description: json['description'] as String?,
				created_at: json['created_at'] as String?,
				program: json['program'] == null
						? null
						: ProgramDto.fromJson(json['program'] as Map<String, dynamic>),
			);

	Map<String, dynamic> toJson() => {
				'week_name': week_name,
				'description': description,
				'created_at': created_at,
				'program': program?.toJson(),
			};
}
