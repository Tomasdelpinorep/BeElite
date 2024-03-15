class Set {
	int? setNumber;
	int? numberOfSets;
	int? numberOfReps;
	int? percentage;

	Set({
		this.setNumber, 
		this.numberOfSets, 
		this.numberOfReps, 
		this.percentage, 
	});

	factory Set.fromJson(Map<String, dynamic> json) => Set(
				setNumber: json['set_number'] as int?,
				numberOfSets: json['number_of_sets'] as int?,
				numberOfReps: json['number_of_reps'] as int?,
				percentage: json['percentage'] as int?,
			);

	Map<String, dynamic> toJson() => {
				'set_number': setNumber,
				'number_of_sets': numberOfSets,
				'number_of_reps': numberOfReps,
				'percentage': percentage,
			};
}
