class User {
  const User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.emailVerified,
  });

  final String id;
  final String fullName;
  final String email;
  final String role;
  final bool emailVerified;

  User copyWith({
    String? id,
    String? fullName,
    String? email,
    String? role,
    bool? emailVerified,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      emailVerified: emailVerified ?? this.emailVerified,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is User &&
        other.id == id &&
        other.fullName == fullName &&
        other.email == email &&
        other.role == role &&
        other.emailVerified == emailVerified;
  }

  @override
  int get hashCode => Object.hash(id, fullName, email, role, emailVerified);
}