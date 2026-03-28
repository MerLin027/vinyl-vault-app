class User {
	final String id;
	final String username;
	final String email;
	final String phone;
	final String address;

	User({
		required this.id,
		required this.username,
		required this.email,
		required this.phone,
		required this.address,
	});

	User.fromJson(Map<String, dynamic> json)
			: id = (json['_id'] ?? '').toString(),
				username = (json['username'] ?? '').toString(),
				email = (json['email'] ?? '').toString(),
				phone = (json['phone'] ?? '').toString(),
				address = (json['address'] ?? '').toString();

	Map<String, dynamic> toJson() {
		return {
			'_id': id,
			'username': username,
			'email': email,
			'phone': phone,
			'address': address,
		};
	}
}
