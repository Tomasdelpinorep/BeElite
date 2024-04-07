class InviteDto {
	String? programId;
	String? athleteId;

	InviteDto({this.programId, this.athleteId});

	factory InviteDto.fromJson(Map<String, dynamic> json) => InviteDto(
				programId: json['programId'] as String?,
				athleteId: json['athleteId'] as String?,
			);

	Map<String, dynamic> toJson() => {
				'programId': programId,
				'athleteId': athleteId,
			};
}
