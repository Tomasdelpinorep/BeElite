class UserDto {
  String? username;
  String? name;
  String? profilePicUrl;
  String? email;
  String? joinedProgramDate;

  UserDto({this.username, this.name, this.profilePicUrl, this.email, this.joinedProgramDate});

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
        username: json['username'] as String?,
        name: json['name'] as String?,
        profilePicUrl: json['profilePicUrl'] as String?,
        email: json['email'] as String?,
        joinedProgramDate: json['joinedProgramDate'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'username': username,
        'name': name,
        'profilePicUrl': profilePicUrl,
        'email': email,
        'joinedProgramDate': joinedProgramDate,
      };
}
