import 'package:be_elite/models/Session/Athlete%20Sessions/athlete_session_id.dart';
import 'package:be_elite/models/Session/Athlete%20Sessions/block.dart';

class AthleteSessionDto {
  AthleteSessionId? sessionId;
  String? date;
  String? title;
  String? subtitle;
  int? sameDaySessionNumber;
  List<AthleteBlockDto>? blocks;
  bool? isCompleted;

  AthleteSessionDto({
    this.sessionId,
    this.date,
    this.title,
    this.subtitle,
    this.sameDaySessionNumber,
    this.blocks,
    this.isCompleted,
  });

  factory AthleteSessionDto.fromJson(Map<String, dynamic> json) {
    return AthleteSessionDto(
      sessionId: json['sessionId'] == null
          ? null
          : AthleteSessionId.fromJson(json['sessionId'] as Map<String, dynamic>),
      date: json['date'] as String?,
      title: json['title'] as String?,
      subtitle: json['subtitle'] as String?,
      sameDaySessionNumber: json['sameDaySessionNumber'] as int?,
      blocks: (json['blocks'] as List<dynamic>?)
          ?.map((e) => AthleteBlockDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      isCompleted: json['isCompleted'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        'sessionId': sessionId?.toJson(),
        'date': date,
        'title': title,
        'subtitle': subtitle,
        'sameDaySessionNumber': sameDaySessionNumber,
        'blocks': blocks?.map((e) => e.toJson()).toList(),
        'isCompleted': isCompleted,
      };
}
