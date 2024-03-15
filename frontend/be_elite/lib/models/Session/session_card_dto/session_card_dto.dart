import 'block_dto.dart';

class SessionCardDto {
	String? date;
	int? sessionNumber;
	String? programId;
	String? weekName;
	int? weekNumber;
	List<Block>? blocks;
	String? title;
	String? subtitle;
	int? sameDaySessionNumber;

	SessionCardDto({
		this.date, 
		this.sessionNumber, 
		this.programId, 
		this.weekName, 
		this.weekNumber, 
		this.blocks, 
		this.title, 
		this.subtitle, 
		this.sameDaySessionNumber, 
	});

	factory SessionCardDto.fromJson(Map<String, dynamic> json) => SessionCardDto(
				date: json['date'] as String?,
				sessionNumber: json['sessionNumber'] as int?,
				programId: json['programId'] as String?,
				weekName: json['weekName'] as String?,
				weekNumber: json['weekNumber'] as int?,
				blocks: (json['blocks'] as List<dynamic>?)
						?.map((e) => Block.fromJson(e as Map<String, dynamic>))
						.toList(),
				title: json['title'] as String?,
				subtitle: json['subtitle'] as String?,
				sameDaySessionNumber: json['sameDaySessionNumber'] as int?,
			);

	Map<String, dynamic> toJson() => {
				'date': date,
				'sessionNumber': sessionNumber,
				'programId': programId,
				'weekName': weekName,
				'weekNumber': weekNumber,
				'blocks': blocks?.map((e) => e.toJson()).toList(),
				'title': title,
				'subtitle': subtitle,
				'sameDaySessionNumber': sameDaySessionNumber,
			};
}
