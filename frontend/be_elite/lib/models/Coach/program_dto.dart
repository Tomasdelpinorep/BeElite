class ProgramDto {
  String? program_name;
  String? program_description;
  String? image;

  ProgramDto({this.program_name, this.program_description, this.image});

  factory ProgramDto.fromJson(Map<String, dynamic> json) => ProgramDto(
        program_name: json['program_name'] as String?,
        program_description: json['program_description'] as String?,
        image: json['image'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'program_name': program_name,
        'program_description': program_description,
        'image': image,
      };
}
