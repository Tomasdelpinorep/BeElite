class Session {
	String? dayOfWeek;
	int? sessionNumber;

	Session({this.dayOfWeek, this.sessionNumber});

	factory Session.fromJson(Map<String, dynamic> json) => Session(
				dayOfWeek: json['dayOfWeek'] as String?,
				sessionNumber: json['sessionNumber'] as int?,
			);

	Map<String, dynamic> toJson() => {
				'dayOfWeek': dayOfWeek,
				'sessionNumber': sessionNumber,
			};
}
