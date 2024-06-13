class InviteDto {
  DateTime? createdAt;
  String? programName;
  String? athleteUsername;
  String? status;

  InviteDto({
    this.createdAt,
    this.programName,
    this.athleteUsername,
    this.status,
  });

  factory InviteDto.fromJson(Map<String, dynamic> json) => InviteDto(
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        programName: json['programName'] as String?,
        athleteUsername: json['athleteUsername'] as String?,
        status: json['status'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'createdAt': createdAt?.toIso8601String(),
        'programName': programName,
        'athleteUsername': athleteUsername,
        'status': status,
      };
}
