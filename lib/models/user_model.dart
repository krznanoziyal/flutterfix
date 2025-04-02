// lib/models/user_model.dart
class User {
  final String name;
  final String email;
  final String avatarUrl;
  final String role;

  User({
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.role,
  });
}