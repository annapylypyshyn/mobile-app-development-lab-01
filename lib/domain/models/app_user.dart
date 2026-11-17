class AppUser {
  final String id;
  final String fullName;
  final String email;
  final String passwordHash;

  const AppUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.passwordHash,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'passwordHash': passwordHash,
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      passwordHash: json['passwordHash'] as String,
    );
  }
}
