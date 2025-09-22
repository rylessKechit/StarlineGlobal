import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

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
  final String? avatar;
  final String? location;
  
  // Client specific fields
  final double totalSpent;
  final String? favoriteDriver;
  
  // Provider specific fields
  final String? companyName;
  final double totalRevenue;
  final double rating;
  final int reviewsCount;
  
  // Statistics
  final int totalBookings;
  
  // Verification & Security
  final bool emailVerified;
  final DateTime? lastLogin;
  
  // Metadata
  final DateTime memberSince;
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
    this.totalSpent = 0.0,
    this.favoriteDriver,
    this.companyName,
    this.totalRevenue = 0.0,
    this.rating = 0.0,
    this.reviewsCount = 0,
    this.totalBookings = 0,
    this.emailVerified = false,
    this.lastLogin,
    required this.memberSince,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  // Getters
  bool get isProvider => role == UserRole.prestataire;
  bool get isClient => role == UserRole.client;
  bool get isAdmin => role == UserRole.admin;
  bool get isActive => status == UserStatus.active;
  bool get hasAvatar => avatar != null && avatar!.isNotEmpty;
  String get displayName => name;
  String get initials => name.split(' ').take(2).map((e) => e.isNotEmpty ? e[0].toUpperCase() : '').join();

  // CopyWith method for immutability
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    UserRole? role,
    UserStatus? status,
    String? avatar,
    String? location,
    double? totalSpent,
    String? favoriteDriver,
    String? companyName,
    double? totalRevenue,
    double? rating,
    int? reviewsCount,
    int? totalBookings,
    bool? emailVerified,
    DateTime? lastLogin,
    DateTime? memberSince,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      status: status ?? this.status,
      avatar: avatar ?? this.avatar,
      location: location ?? this.location,
      totalSpent: totalSpent ?? this.totalSpent,
      favoriteDriver: favoriteDriver ?? this.favoriteDriver,
      companyName: companyName ?? this.companyName,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      totalBookings: totalBookings ?? this.totalBookings,
      emailVerified: emailVerified ?? this.emailVerified,
      lastLogin: lastLogin ?? this.lastLogin,
      memberSince: memberSince ?? this.memberSince,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

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

  String get description {
    switch (this) {
      case UserRole.client:
        return 'Accès aux services de luxe';
      case UserRole.prestataire:
        return 'Fournisseur de services';
      case UserRole.admin:
        return 'Administrateur de la plateforme';
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

// Auth Request/Response Models
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
  final String? companyName;
  final String? location;

  const RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
    this.phone,
    required this.role,
    this.companyName,
    this.location,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
  
  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);

  @override
  List<Object?> get props => [name, email, password, phone, role, companyName, location];
}

@JsonSerializable()
class UpdateProfileRequest extends Equatable {
  final String? name;
  final String? phone;
  final String? location;
  final String? companyName;
  final String? avatar;

  const UpdateProfileRequest({
    this.name,
    this.phone,
    this.location,
    this.companyName,
    this.avatar,
  });

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileRequestFromJson(json);
  
  Map<String, dynamic> toJson() => _$UpdateProfileRequestToJson(this);

  @override
  List<Object?> get props => [name, phone, location, companyName, avatar];
}

@JsonSerializable()
class UpdateUserRequest extends Equatable {
  final String? name;
  final String? email;
  final String? phone;
  final String? role;
  final String? status;
  final String? location;
  final String? companyName;

  const UpdateUserRequest({
    this.name,
    this.email,
    this.phone,
    this.role,
    this.status,
    this.location,
    this.companyName,
  });

  factory UpdateUserRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserRequestFromJson(json);
  
  Map<String, dynamic> toJson() => _$UpdateUserRequestToJson(this);

  @override
  List<Object?> get props => [name, email, phone, role, status, location, companyName];
}