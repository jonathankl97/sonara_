class UserModel {
  final String id;
  final String email;
  final String? displayName;
  final String? city;
  final String role;
  final List<String> roles;

  UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.city,
    required this.role,
    required this.roles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      city: json['city'] as String?,
      role: json['role'] as String,
      roles: (json['roles'] as List<dynamic>?)
              ?.map((r) => r as String)
              .toList() ??
          [],
    );
  }
}