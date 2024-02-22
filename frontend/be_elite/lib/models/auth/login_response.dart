class LoginResponse {
	String? id;
	String? username;
	String? email;
	String? name;
	String? role;
	String? createdAt;
	String? token;

	LoginResponse({
		this.id, 
		this.username, 
		this.email, 
		this.name, 
		this.role, 
		this.createdAt, 
		this.token, 
	});

	factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
				id: json['id'] as String?,
				username: json['username'] as String?,
				email: json['email'] as String?,
				name: json['name'] as String?,
				role: json['role'] as String?,
				createdAt: json['createdAt'] as String?,
				token: json['token'] as String?,
			);

	Map<String, dynamic> toJson() => {
				'id': id,
				'username': username,
				'email': email,
				'name': name,
				'role': role,
				'createdAt': createdAt,
				'token': token,
			};
}
