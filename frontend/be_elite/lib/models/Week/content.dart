class Content {
  String? weekName;
  String? description;
  List<dynamic>? sessions;
  int? id;

  Content({this.weekName, this.description, this.sessions, this.id});

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        weekName: json['weekName'] as String?,
        description: json['description'] as String?,
        sessions: json['sessions'] as List<dynamic>?,
        id: json['id'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'weekName': weekName,
        'description': description,
        'sessions': sessions,
        'id': id,
      };
}
