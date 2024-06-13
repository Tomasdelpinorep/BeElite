class PostProgramDto {
  String? programName;
  String? description;
  String? image;
  String? createdAt;
  String? coachId;

  PostProgramDto({
    this.programName,
    this.description,
    this.image,
    this.createdAt,
    this.coachId,
  });

  factory PostProgramDto.fromJson(Map<String, dynamic> json) {
    return PostProgramDto(
      programName: json['programName'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String?,
      createdAt: json['createdAt'] as String?,
      coachId: json['coach_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'programName': programName,
        'description': description,
        'image': image,
        'createdAt': createdAt,
        'coach_id': coachId,
      };
}
