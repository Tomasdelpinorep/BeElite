import 'set.dart';

class Block {
	int? blockNumber;
	String? movement;
	String? blockInstructions;
	int? restBetweenSets;
	List<Set>? sets;

	Block({
		this.blockNumber, 
		this.movement, 
		this.blockInstructions, 
		this.restBetweenSets, 
		this.sets, 
	});

	factory Block.fromJson(Map<String, dynamic> json) => Block(
				blockNumber: json['block_number'] as int?,
				movement: json['movement'] as String?,
				blockInstructions: json['block_instructions'] as String?,
				restBetweenSets: json['rest_between_sets'] as int?,
				sets: (json['sets'] as List<dynamic>?)
						?.map((e) => Set.fromJson(e as Map<String, dynamic>))
						.toList(),
			);

	Map<String, dynamic> toJson() => {
				'block_number': blockNumber,
				'movement': movement,
				'block_instructions': blockInstructions,
				'rest_between_sets': restBetweenSets,
				'sets': sets?.map((e) => e.toJson()).toList(),
			};
}
