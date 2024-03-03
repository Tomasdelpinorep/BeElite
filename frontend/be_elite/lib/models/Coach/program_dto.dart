class ProgramDto {
	String? programName;
	String? image;

	ProgramDto({this.programName, this.image});

	factory ProgramDto.fromJson(Map<String, dynamic> json) => ProgramDto(
				programName: json['program_name'] as String?,
				image: json['image'] as String?,
			);

	Map<String, dynamic> toJson() => {
				'program_name': programName,
				'image': image,
			};
}
