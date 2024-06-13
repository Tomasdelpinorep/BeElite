class WeekId {
	int? weekNumber;
	String? weekName;
	String? programId;

	WeekId({this.weekNumber, this.weekName, this.programId});

	factory WeekId.fromJson(Map<String, dynamic> json) => WeekId(
				weekNumber: json['week_number'] as int?,
				weekName: json['week_name'] as String?,
				programId: json['program_id'] as String?,
			);

	Map<String, dynamic> toJson() => {
				'week_number': weekNumber,
				'week_name': weekName,
				'program_id': programId,
			};
}
