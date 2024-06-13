class SessionDto {
  String? date;
  int? sessionNumber;
  int? sameDaySessionNumber;

  SessionDto({this.date, this.sessionNumber, this.sameDaySessionNumber});

  factory SessionDto.fromJson(Map<String, dynamic> json) => SessionDto(
      date: json['date'] as String?,
      sessionNumber: json['sessionNumber'] as int?,
      sameDaySessionNumber: json['sameDaySessionNumber'] as int?);

  Map<String, dynamic> toJson() => {
        'date': date,
        'sessionNumber': sessionNumber,
        'sameDaySessionNumber': sameDaySessionNumber,
      };
}
