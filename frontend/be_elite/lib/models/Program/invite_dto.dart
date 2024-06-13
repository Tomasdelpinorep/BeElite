class InviteDto {
  String? inviteId;
  DateTime? createdAt;
  String? coachName;
  String? programName;
  String? athleteUsername;
  String? status;

  InviteDto({
    this.inviteId,
    this.createdAt,
    this.coachName,
    this.programName,
    this.athleteUsername,
    this.status,
  });

  factory InviteDto.fromJson(Map<String, dynamic> json) => InviteDto(
        inviteId: json['inviteId'] as String?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        coachName: json['coachName'] as String?,
        programName: json['programName'] as String?,
        athleteUsername: json['athleteUsername'] as String?,
        status: json['status'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'inviteId': inviteId,
        'createdAt': createdAt?.toIso8601String(),
        'coachName': coachName,
        'programName': programName,
        'athleteUsername': athleteUsername,
        'status': status,
      };
}
