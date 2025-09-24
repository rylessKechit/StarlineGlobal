import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

enum UserRole {
  client,
  prestataire,
  admin,
}

enum UserStatus {
  active,
  pending,
  suspended,
  inactive,
}

@JsonSerializable()
class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final UserRole role;
  final UserStatus status;
  final String? location;
  final String? companyName;
  final String? avatar;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastLogin;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    required this.status,
    this.location,
    this.companyName,
    this.avatar,
    required this.createdAt,
    required this.updatedAt,
    this.lastLogin,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    UserRole? role,
    UserStatus? status,
    String? location,
    String? companyName,
    String? avatar,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLogin,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      status: status ?? this.status,
      location: location ?? this.location,
      companyName: companyName ?? this.companyName,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }
}

// ✅ AJOUT DE LA CLASSE AuthResponse (cette classe reste ici car elle n'existe que dans les models)
@JsonSerializable()
class AuthResponse {
  final User user;
  final String token;

  AuthResponse({
    required this.user,
    required this.token,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => _$AuthResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}

// ✅ AJOUT DE LA CLASSE AuthException (cette classe reste ici car elle n'existe que dans les models)
class AuthException implements Exception {
  final String message;
  final List<String>? errors;

  AuthException({
    required this.message,
    this.errors,
  });

  @override
  String toString() => 'AuthException: $message';
}