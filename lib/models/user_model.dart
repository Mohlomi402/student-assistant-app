class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String status;
  final String role; // "student" or "admin"

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.status,
    required this.role,
  });

  // Supabase → Dart
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      status: json['status'] ?? 'Pending',
      role: json['role'] ?? 'student',
    );
  }

  // Dart → Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'status': status,
      'role': role,
    };
  }

  // Helper: full name
  String get fullName => "$firstName $lastName";

  // Helper: check role
  bool get isAdmin => role == "admin";
  bool get isStudent => role == "student";
}
