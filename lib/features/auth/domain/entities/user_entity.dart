import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String username;
  final String email;
  final List<String> roles;
  final List<String> permissions;
  final String? token;

  const UserEntity({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.roles,
    required this.permissions,
    this.token,
  });

  String get primaryRole => roles.isNotEmpty ? roles.first : 'user';

  // Backward compatibility
  String get role => primaryRole;

  bool get isAdminOrDev => roles.any((r) => r.toLowerCase() == 'admin' || r.toLowerCase() == 'dev');

  bool hasPermission(String permission) => permissions.contains(permission);

  @override
  List<Object?> get props => [id, name, username, email, roles, permissions, token];
}
