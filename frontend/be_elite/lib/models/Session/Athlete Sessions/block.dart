import 'block_id.dart';
import 'set.dart';

class AthleteBlockDto {
  AthleteBlockId? blockId;
  String? movement;
  String? instructions;
  dynamic rest;
  List<Set>? sets;
  dynamic feedback;
  bool? isCompleted;

  AthleteBlockDto({
    this.blockId,
    this.movement,
    this.instructions,
    this.rest,
    this.sets,
    this.feedback,
    this.isCompleted,
  });

  factory AthleteBlockDto.fromJson(Map<String, dynamic> json) => AthleteBlockDto(
        blockId: json['blockId'] == null
            ? null
            : AthleteBlockId.fromJson(json['blockId'] as Map<String, dynamic>),
        movement: json['movement'] as String?,
        instructions: json['instructions'] as String?,
        rest: json['rest'] as dynamic,
        sets: (json['sets'] as List<dynamic>?)
            ?.map((e) => Set.fromJson(e as Map<String, dynamic>))
            .toList(),
        feedback: json['feedback'] as dynamic,
        isCompleted: json['isCompleted'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'blockId': blockId?.toJson(),
        'movement': movement,
        'instructions': instructions,
        'rest': rest,
        'sets': sets?.map((e) => e.toJson()).toList(),
        'feedback': feedback,
        'isCompleted': isCompleted,
      };
}
