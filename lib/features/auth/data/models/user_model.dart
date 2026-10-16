import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, {String? token}) {
    final userData = json['user'] ?? json;
    return UserModel(
      id: userData['id'] as int? ?? 1,
      name: userData['name'] as String? ?? 'SRE Engineer',
      email: userData['email'] as String? ?? 'admin@sigap.id',
      role: userData['role'] as String? ?? 'admin',
      token: token ?? json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'token': token,
    };
  }
}
