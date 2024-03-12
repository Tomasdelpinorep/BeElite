import 'session.dart';

class Content {
	String? weekName;
	String? description;
	List<Session>? sessions;
	int? weekNumber;
  String? created_at;

	Content({this.weekName, this.description, this.sessions, this.weekNumber, this.created_at});

	factory Content.fromJson(Map<String, dynamic> json) => Content(
				weekName: json['weekName'] as String?,
				description: json['description'] as String?,
				sessions: (json['sessions'] as List<dynamic>?)
						?.map((e) => Session.fromJson(e as Map<String, dynamic>))
						.toList(),
				weekNumber: json['weekNumber'] as int?,
        created_at: json['created_at'] as String?,
			);

	Map<String, dynamic> toJson() => {
				'weekName': weekName,
				'description': description,
				'sessions': sessions?.map((e) => e.toJson()).toList(),
				'weekNumber': weekNumber,
        'created_at': created_at,
			};
}
