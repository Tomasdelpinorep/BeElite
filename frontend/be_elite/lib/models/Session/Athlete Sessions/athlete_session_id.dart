class AthleteSessionId {
  int? athlete_session_number;
  String? athlete_id;

  AthleteSessionId({this.athlete_session_number, this.athlete_id});

  factory AthleteSessionId.fromJson(Map<String, dynamic> json) {
    return AthleteSessionId(
      athlete_session_number: json['athlete_session_number'] as int?,
      athlete_id: json['athlete_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'athlete_session_number': athlete_session_number,
        'athlete_id': athlete_id,
      };
}
