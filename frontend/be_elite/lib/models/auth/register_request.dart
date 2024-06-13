class RegisterRequest {
  String? name;
  String? username;
  String? email;
  String? password;
  String? verifyPassword;
  String? userType;

  RegisterRequest({
    this.name,
    this.username,
    this.email,
    this.password,
    this.verifyPassword,
    this.userType,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) {
    return RegisterRequest(
      name: json['name'] as String?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      verifyPassword: json['verifyPassword'] as String?,
      userType: json['userType'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'username': username,
        'email': email,
        'password': password,
        'verifyPassword': verifyPassword,
        'userType': userType,
      };
}
