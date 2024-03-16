import 'post_block_dto.dart';

class PostSessionDto {
	int? sessionNumber;
	String? date;
	String? title;
	String? subtitle;
	List<PostBlockDto>? blocks;
	int? sameDaySessionNumber;

	PostSessionDto({
		this.sessionNumber, 
		this.date, 
		this.title, 
		this.subtitle, 
		this.blocks, 
		this.sameDaySessionNumber, 
	});

	factory PostSessionDto.fromJson(Map<String, dynamic> json) {
		return PostSessionDto(
			sessionNumber: json['session_number'] as int?,
			date: json['date'] as String?,
			title: json['title'] as String?,
			subtitle: json['subtitle'] as String?,
			blocks: (json['blocks'] as List<dynamic>?)
						?.map((e) => PostBlockDto.fromJson(e as Map<String, dynamic>))
						.toList(),
			sameDaySessionNumber: json['same_day_session_number'] as int?,
		);
	}



	Map<String, dynamic> toJson() => {
				'session_number': sessionNumber,
				'date': date,
				'title': title,
				'subtitle': subtitle,
				'blocks': blocks?.map((e) => e.toJson()).toList(),
				'same_day_session_number': sameDaySessionNumber,
			};
}
