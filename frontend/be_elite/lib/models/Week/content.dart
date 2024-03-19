import 'package:be_elite/models/Session/session_dto.dart';


class WeekContent {
	String? weekName;
	String? description;
	List<SessionDto>? sessions;
	int? weekNumber;
  String? created_at;
  List<dynamic>? span;

	WeekContent({this.weekName, this.description, this.sessions, this.weekNumber, this.created_at, this.span});

	factory WeekContent.fromJson(Map<String, dynamic> json) => WeekContent(
				weekName: json['weekName'] as String?,
				description: json['description'] as String?,
				sessions: (json['sessions'] as List<dynamic>?)
						?.map((e) => SessionDto.fromJson(e as Map<String, dynamic>))
						.toList(),
				weekNumber: json['weekNumber'] as int?,
        created_at: json['created_at'] as String?,
        span: json['span'] as List<dynamic>?,
			);

	Map<String, dynamic> toJson() => {
				'weekName': weekName,
				'description': description,
				'sessions': sessions?.map((e) => e.toJson()).toList(),
				'weekNumber': weekNumber,
        'created_at': created_at,
        'span': span,
			};
}
