class Set {
	int? numberOfSets;
	int? numberOfReps;
	int? percentage;

	Set({this.numberOfSets, this.numberOfReps, this.percentage});

	factory Set.fromJson(Map<String, dynamic> json) => Set(
				numberOfSets: json['numberOfSets'] as int?,
				numberOfReps: json['numberOfReps'] as int?,
				percentage: json['percentage'] as int?,
			);

	Map<String, dynamic> toJson() => {
				'numberOfSets': numberOfSets,
				'numberOfReps': numberOfReps,
				'percentage': percentage,
			};
}
