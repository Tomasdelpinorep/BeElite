class ProgramDto {
  String? program_name;
  String? image;

  ProgramDto({this.program_name, this.image});

  factory ProgramDto.fromJson(Map<String, dynamic> json) => ProgramDto(
        program_name: json['program_name'] as String?,
        image: json['image'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'program_name': program_name,
        'image': image,
      };
}
