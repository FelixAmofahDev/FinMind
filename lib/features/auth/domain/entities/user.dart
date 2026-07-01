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

  bool get isOwner => role == 'owner';

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'fullName': fullName,
      'email': email,
      'role': role,
      'emailVerified': emailVerified,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          fullName == other.fullName &&
          email == other.email &&
          role == other.role &&
          emailVerified == other.emailVerified;

  @override
  int get hashCode =>
      id.hashCode ^
      fullName.hashCode ^
      email.hashCode ^
      role.hashCode ^
      emailVerified.hashCode;

  @override
  String toString() =>
      'User(id: $id, fullName: $fullName, email: $email, role: $role, emailVerified: $emailVerified)';
}