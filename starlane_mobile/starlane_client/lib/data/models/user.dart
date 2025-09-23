import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final UserRole role;
  final UserStatus status;
  final String? avatar;
  final String? location;
  final double? totalSpent;
  final String? favoriteDriver;
  final String? companyName;
  final double? totalRevenue;
  final double? rating;
  final int? reviewsCount;
  final int? totalBookings;
  final bool emailVerified;
  final DateTime? lastLogin;
  final DateTime? memberSince;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    required this.status,
    this.avatar,
    this.location,
    this.totalSpent,
    this.favoriteDriver,
    this.companyName,
    this.totalRevenue,
    this.rating,
    this.reviewsCount,
    this.totalBookings,
    this.emailVerified = false,
    this.lastLogin,
    this.memberSince,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.length >= 2 ? name.substring(0, 2).toUpperCase() : name.toUpperCase();
  }

  bool get isActive => status == UserStatus.active;
  bool get isClient => role == UserRole.client;
  bool get isProvider => role == UserRole.prestataire;
  bool get isAdmin => role == UserRole.admin;

  @override
  List<Object?> get props => [
    id, name, email, phone, role, status, avatar, location,
    totalSpent, favoriteDriver, companyName, totalRevenue,
    rating, reviewsCount, totalBookings, emailVerified,
    lastLogin, memberSince, createdAt, updatedAt
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

  bool get canAccess => this == UserStatus.active;
}

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

@JsonSerializable()
class LoginRequest extends Equatable {
  final String email;
  final String password;
  final String role;

  const LoginRequest({
    required this.email,
    required this.password,
    required this.role,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
  
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);

  @override
  List<Object> get props => [email, password, role];
}

@JsonSerializable()
class RegisterRequest extends Equatable {
  final String name;
  final String email;
  final String password;
  final String? phone;
  final String role;
  final String? location;
  final String? companyName;

  const RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
    this.phone,
    required this.role,
    this.location,
    this.companyName,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
  
  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);

  @override
  List<Object?> get props => [name, email, password, phone, role, location, companyName];
}

@JsonSerializable()
class UpdateProfileRequest extends Equatable {
  final String? name;
  final String? phone;
  final String? location;
  final String? avatar;

  const UpdateProfileRequest({
    this.name,
    this.phone,
    this.location,
    this.avatar,
  });

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileRequestFromJson(json);
  
  Map<String, dynamic> toJson() => _$UpdateProfileRequestToJson(this);

  @override
  List<Object?> get props => [name, phone, location, avatar];
}

@JsonSerializable()
class UpdateUserRequest extends Equatable {
  final String? name;
  final String? phone;
  final String? location;
  final String? avatar;
  final String? status;

  const UpdateUserRequest({
    this.name,
    this.phone,
    this.location,
    this.avatar,
    this.status,
  });

  factory UpdateUserRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserRequestFromJson(json);
  
  Map<String, dynamic> toJson() => _$UpdateUserRequestToJson(this);

  @override
  List<Object?> get props => [name, phone, location, avatar, status];
}