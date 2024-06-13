class SessionId {
  int? athleteSessionNumber;
  String? athleteId;

  SessionId({this.athleteSessionNumber, this.athleteId});

  factory SessionId.fromJson(Map<String, dynamic> json) => SessionId(
        athleteSessionNumber: json['athlete_session_number'] as int?,
        athleteId: json['athlete_id'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'athlete_session_number': athleteSessionNumber,
        'athlete_id': athleteId,
      };
}
