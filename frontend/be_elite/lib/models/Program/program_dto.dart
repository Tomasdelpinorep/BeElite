class ProgramDto {
	String? coachName;
	String? coachUsername;
	String? programName;
	String? programDescription;
	String? programPicUrl;
	String? createdAt;
	int? numberOfSessions;
	int? numberOfAthletes;
	bool? isVisible;

	ProgramDto({
		this.coachName, 
		this.coachUsername, 
		this.programName, 
		this.programDescription, 
		this.programPicUrl, 
		this.createdAt, 
		this.numberOfSessions, 
		this.numberOfAthletes, 
		this.isVisible, 
	});

	factory ProgramDto.fromJson(Map<String, dynamic> json) => ProgramDto(
				coachName: json['coachName'] as String?,
				coachUsername: json['coachUsername'] as String?,
				programName: json['programName'] as String?,
				programDescription: json['programDescription'] as String?,
				programPicUrl: json['programPicUrl'] as String?,
				createdAt: json['createdAt'] as String?,
				numberOfSessions: json['numberOfSessions'] as int?,
				numberOfAthletes: json['numberOfAthletes'] as int?,
				isVisible: json['isVisible'] as bool?,
			);

	Map<String, dynamic> toJson() => {
				'coachName': coachName,
				'coachUsername': coachUsername,
				'programName': programName,
				'programDescription': programDescription,
				'programPicUrl': programPicUrl,
				'createdAt': createdAt,
				'numberOfSessions': numberOfSessions,
				'numberOfAthletes': numberOfAthletes,
				'isVisible': isVisible,
			};
}
