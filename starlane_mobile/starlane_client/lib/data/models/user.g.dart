// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      status: $enumDecode(_$UserStatusEnumMap, json['status']),
      avatar: json['avatar'] as String?,
      location: json['location'] as String?,
      totalSpent: (json['totalSpent'] as num?)?.toDouble(),
      favoriteDriver: json['favoriteDriver'] as String?,
      companyName: json['companyName'] as String?,
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble(),
      rating: (json['rating'] as num?)?.toDouble(),
      reviewsCount: (json['reviewsCount'] as num?)?.toInt(),
      totalBookings: (json['totalBookings'] as num?)?.toInt(),
      emailVerified: json['emailVerified'] as bool? ?? false,
      lastLogin: json['lastLogin'] == null
          ? null
          : DateTime.parse(json['lastLogin'] as String),
      memberSince: json['memberSince'] == null
          ? null
          : DateTime.parse(json['memberSince'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'role': _$UserRoleEnumMap[instance.role]!,
      'status': _$UserStatusEnumMap[instance.status]!,
      'avatar': instance.avatar,
      'location': instance.location,
      'totalSpent': instance.totalSpent,
      'favoriteDriver': instance.favoriteDriver,
      'companyName': instance.companyName,
      'totalRevenue': instance.totalRevenue,
      'rating': instance.rating,
      'reviewsCount': instance.reviewsCount,
      'totalBookings': instance.totalBookings,
      'emailVerified': instance.emailVerified,
      'lastLogin': instance.lastLogin?.toIso8601String(),
      'memberSince': instance.memberSince?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$UserRoleEnumMap = {
  UserRole.client: 'client',
  UserRole.prestataire: 'prestataire',
  UserRole.admin: 'admin',
};

const _$UserStatusEnumMap = {
  UserStatus.active: 'active',
  UserStatus.pending: 'pending',
  UserStatus.suspended: 'suspended',
  UserStatus.inactive: 'inactive',
};

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) => AuthResponse(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
    );

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{
      'user': instance.user,
      'token': instance.token,
    };

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
      email: json['email'] as String,
      password: json['password'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'role': instance.role,
    };

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) =>
    RegisterRequest(
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      phone: json['phone'] as String?,
      role: json['role'] as String,
      location: json['location'] as String?,
      companyName: json['companyName'] as String?,
    );

Map<String, dynamic> _$RegisterRequestToJson(RegisterRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
      'phone': instance.phone,
      'role': instance.role,
      'location': instance.location,
      'companyName': instance.companyName,
    };

UpdateProfileRequest _$UpdateProfileRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateProfileRequest(
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      location: json['location'] as String?,
      avatar: json['avatar'] as String?,
    );

Map<String, dynamic> _$UpdateProfileRequestToJson(
        UpdateProfileRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'phone': instance.phone,
      'location': instance.location,
      'avatar': instance.avatar,
    };

UpdateUserRequest _$UpdateUserRequestFromJson(Map<String, dynamic> json) =>
    UpdateUserRequest(
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      location: json['location'] as String?,
      avatar: json['avatar'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$UpdateUserRequestToJson(UpdateUserRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'phone': instance.phone,
      'location': instance.location,
      'avatar': instance.avatar,
      'status': instance.status,
    };
