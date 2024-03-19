class SessionDto {
	String? dayOfWeek;
	int? sessionNumber;
  int? sameDaySessionNumber;

	SessionDto({this.dayOfWeek, this.sessionNumber, this.sameDaySessionNumber});

	factory SessionDto.fromJson(Map<String, dynamic> json) => SessionDto(
				dayOfWeek: json['dayOfWeek'] as String?,
				sessionNumber: json['sessionNumber'] as int?,
        sameDaySessionNumber: json['sameDaySessionNumber'] as int?
			);

	Map<String, dynamic> toJson() => {
				'dayOfWeek': dayOfWeek,
				'sessionNumber': sessionNumber,
        'sameDaySessionNumber' : sameDaySessionNumber,
			};
}
