import '../../domain/entities/user_entity.dart';

class UserModel {
  final bool success;
  final String message;
  final Data data;

  UserModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      success: json['success'] as bool? ?? true,
      message: json['message'] as String? ?? '',
      data: Data.fromJson(
        (json['data'] as Map<String, dynamic>?) ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data.toJson(),
      };

  UserModel copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      UserModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  UserEntity toEntity() => data.user.toEntity(token: data.token);
}

class Data {
  final String token;
  final String tokenType;
  final User user;

  Data({
    required this.token,
    required this.tokenType,
    required this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      token: (json['token'] ?? json['access_token'] ?? '').toString(),
      tokenType: (json['tokenType'] ?? json['token_type'] ?? 'Bearer').toString(),
      user: User.fromJson(
        (json['user'] as Map<String, dynamic>?) ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'token': token,
        'tokenType': tokenType,
        'user': user.toJson(),
      };

  Data copyWith({
    String? token,
    String? tokenType,
    User? user,
  }) =>
      Data(
        token: token ?? this.token,
        tokenType: tokenType ?? this.tokenType,
        user: user ?? this.user,
      );
}

class User {
  final String id;
  final String name;
  final String username;
  final String email;
  final List<String> roles;
  final List<String> permissions;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.roles,
    required this.permissions,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final rawRoles = json['roles'] as List? ?? [];
    final rawPermissions = json['permissions'] as List? ?? [];

    return User(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      username: (json['username'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      roles: rawRoles.map((e) => e.toString()).toList(),
      permissions: rawPermissions.map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'username': username,
        'email': email,
        'roles': roles,
        'permissions': permissions,
      };

  User copyWith({
    String? id,
    String? name,
    String? username,
    String? email,
    List<String>? roles,
    List<String>? permissions,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        username: username ?? this.username,
        email: email ?? this.email,
        roles: roles ?? this.roles,
        permissions: permissions ?? this.permissions,
      );

  UserEntity toEntity({String? token}) => UserEntity(
        id: id,
        name: name,
        username: username,
        email: email,
        roles: roles,
        permissions: permissions,
        token: token,
      );
}
