class PostSetDto {
	int? setNumber;
	int? numberOfSets;
	int? numberOfReps;
	int? percentage;

	PostSetDto({
		this.setNumber, 
		this.numberOfSets, 
		this.numberOfReps, 
		this.percentage, 
	});

	factory PostSetDto.fromJson(Map<String, dynamic> json) => PostSetDto(
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
