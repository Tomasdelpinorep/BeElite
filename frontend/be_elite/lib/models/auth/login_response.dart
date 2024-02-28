class LoginResponse {
	String? id;
	String? username;
	String? email;
	String? name;
	String? role;
	String? profilePicUrl;
	String? createdAt;
	String? token;

	LoginResponse({
		this.id, 
		this.username, 
		this.email, 
		this.name, 
		this.role, 
		this.profilePicUrl, 
		this.createdAt, 
		this.token, 
	});

	factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
				id: json['id'] as String?,
				username: json['username'] as String?,
				email: json['email'] as String?,
				name: json['name'] as String?,
				role: json['role'] as String?,
				profilePicUrl: json['profilePicUrl'] as String?,
				createdAt: json['createdAt'] as String?,
				token: json['token'] as String?,
			);

	Map<String, dynamic> toJson() => {
				'id': id,
				'username': username,
				'email': email,
				'name': name,
				'role': role,
				'profilePicUrl': profilePicUrl,
				'createdAt': createdAt,
				'token': token,
			};
}
