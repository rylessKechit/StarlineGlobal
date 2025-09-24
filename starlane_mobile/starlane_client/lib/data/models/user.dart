// Path: starlane_mobile/starlane_client/lib/data/models/user.dart
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String email;
  final String? phone;
  final UserRole role;
  final UserStatus status;
  final String? companyName;
  final String? location;
  final String? avatar;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    required this.status,
    this.companyName,
    this.location,
    this.avatar,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  // Getters utilitaires
  String get displayName => name;
  bool get isActive => status == UserStatus.active;
  bool get isClient => role == UserRole.client;
  bool get isProvider => role == UserRole.prestataire;
  bool get isAdmin => role == UserRole.admin;

  @override
  List<Object?> get props => [
    id, name, email, phone, role, status, 
    companyName, location, avatar, createdAt, updatedAt
  ];
}

@JsonEnum()
enum UserRole {
  @JsonValue('client')
  client,
  @JsonValue('prestataire')
  prestataire,
  @JsonValue('admin')
  admin;
  
  String get displayName {
    switch (this) {
      case UserRole.client:
        return 'Client';
      case UserRole.prestataire:
        return 'Prestataire';
      case UserRole.admin:
        return 'Administrateur';
    }
  }
}

@JsonEnum()
enum UserStatus {
  @JsonValue('active')
  active,
  @JsonValue('pending')
  pending,
  @JsonValue('suspended')
  suspended,
  @JsonValue('inactive')
  inactive;
  
  String get displayName {
    switch (this) {
      case UserStatus.active:
        return 'Actif';
      case UserStatus.pending:
        return 'En attente';
      case UserStatus.suspended:
        return 'Suspendu';
      case UserStatus.inactive:
        return 'Inactif';
    }
  }
}

// Response pour l'authentification
@JsonSerializable()
class AuthResponse extends Equatable {
  final User user;
  final String token;

  const AuthResponse({
    required this.user,
    required this.token,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => 
      _$AuthResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);

  @override
  List<Object> get props => [user, token];
}

// Exception pour l'authentification
class AuthException implements Exception {
  final String message;
  final int? statusCode;
  final List<String>? errors;

  AuthException({
    required this.message,
    this.statusCode,
    this.errors,
  });

  @override
  String toString() => 'AuthException: $message';
}