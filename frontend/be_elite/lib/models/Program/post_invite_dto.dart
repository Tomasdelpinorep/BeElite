class PostInviteDto {
	String? programName;
	String? athleteUsername;
  String? coachId;

	PostInviteDto({this.programName, this.athleteUsername, this.coachId});

	factory PostInviteDto.fromJson(Map<String, dynamic> json) => PostInviteDto(
				programName: json['programName'] as String?,
				athleteUsername: json['athleteUsername'] as String?,
        coachId: json['coachId'] as String?,
			);

	Map<String, dynamic> toJson() => {
				'programName': programName,
				'athleteUsername': athleteUsername,
        'coachId': coachId,
			};
}
