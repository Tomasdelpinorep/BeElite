import 'session.dart';

class Content {
	String? weekName;
	String? description;
	List<Session>? sessions;
	int? id;

	Content({this.weekName, this.description, this.sessions, this.id});

	factory Content.fromJson(Map<String, dynamic> json) => Content(
				weekName: json['weekName'] as String?,
				description: json['description'] as String?,
				sessions: (json['sessions'] as List<dynamic>?)
						?.map((e) => Session.fromJson(e as Map<String, dynamic>))
						.toList(),
				id: json['id'] as int?,
			);

	Map<String, dynamic> toJson() => {
				'weekName': weekName,
				'description': description,
				'sessions': sessions?.map((e) => e.toJson()).toList(),
				'id': id,
			};
}
