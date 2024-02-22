class LoginRequest {
	String? username;
	String? password;

	LoginRequest({this.username, this.password});

	factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
				username: json['username'] as String?,
				password: json['password'] as String?,
			);

	Map<String, dynamic> toJson() => {
				'username': username,
				'password': password,
			};
}
