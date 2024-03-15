class SessionDto {
	String? dayOfWeek;
	int? sessionNumber;

	SessionDto({this.dayOfWeek, this.sessionNumber});

	factory SessionDto.fromJson(Map<String, dynamic> json) => SessionDto(
				dayOfWeek: json['dayOfWeek'] as String?,
				sessionNumber: json['sessionNumber'] as int?,
			);

	Map<String, dynamic> toJson() => {
				'dayOfWeek': dayOfWeek,
				'sessionNumber': sessionNumber,
			};
}
