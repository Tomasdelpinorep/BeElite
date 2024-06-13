import 'athlete_session_id.dart';

class AthleteBlockId {
  int? athlete_block_number;
  AthleteSessionId? athlete_session_id;

  AthleteBlockId({this.athlete_session_id, this.athlete_block_number});

  factory AthleteBlockId.fromJson(Map<String, dynamic> json) => AthleteBlockId(
        athlete_block_number: json['athlete_block_number'] as int?,
        athlete_session_id: json['athlete_session_id'] == null
            ? null
            : AthleteSessionId.fromJson(
                json['athlete_session_id'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'athlete_block_number': athlete_block_number,
        'athlete_session_id': athlete_session_id?.toJson(),
      };
}
