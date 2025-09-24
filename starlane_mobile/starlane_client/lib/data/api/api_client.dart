// Path: starlane_mobile/starlane_client/lib/data/api/api_client.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:retrofit/retrofit.dart';
import 'package:json_annotation/json_annotation.dart';
import '../models/user.dart';
import '../models/activity.dart';

part 'api_client.g.dart';

/// Configuration pour l'API Starlane Global
class ApiConfig {
  static const String baseUrl = kDebugMode 
    ? 'http://10.0.2.2:5000/api'  // Android Emulator
    : 'https://api.starlane-global.com/api'; // Production
  
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}

/// Client Dio configuré pour l'API
class DioClient {
  static DioClient? _instance;
  late Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  DioClient._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      sendTimeout: ApiConfig.sendTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Intercepteur pour ajouter le token d'authentification
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // Token expiré, nettoyer le storage
          await _storage.delete(key: 'auth_token');
          await _storage.delete(key: 'user_data');
        }
        handler.next(error);
      },
    ));

    // Logs en mode debug
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
        error: true,
      ));
    }
  }

  factory DioClient() {
    _instance ??= DioClient._internal();
    return _instance!;
  }

  Dio get dio => _dio;
}

/// Exception personnalisée pour l'API
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final List<String>? errors;

  ApiException({
    required this.message,
    this.statusCode,
    this.errors,
  });

  @override
  String toString() => 'ApiException: $message';
}

@RestApi()
abstract class StarlaneApiClient {
  factory StarlaneApiClient(Dio dio) = _StarlaneApiClient;

  // ========== AUTH ENDPOINTS ==========
  @POST('/auth/register')
  Future<ApiResponse<User>> register(@Body() RegisterRequest request);

  @POST('/auth/login')
  Future<ApiResponse<LoginResponse>> login(@Body() LoginRequest request);

  @GET('/auth/profile')
  Future<ApiResponse<User>> getProfile();

  @PUT('/auth/profile')
  Future<ApiResponse<User>> updateProfile(@Body() UpdateProfileRequest request);

  @POST('/auth/logout')
  Future<ApiResponse<String>> logout();

  // ========== USER ENDPOINTS ==========
  @GET('/users')
  Future<ApiResponse<PaginatedResponse<User>>> getUsers({
    @Query('page') int page = 1,
    @Query('limit') int limit = 20,
    @Query('role') String? role,
    @Query('status') String? status,
    @Query('search') String? search,
  });

  @GET('/users/{id}')
  Future<ApiResponse<User>> getUserById(@Path('id') String userId);

  @PUT('/users/{id}')
  Future<ApiResponse<User>> updateUser(
    @Path('id') String userId,
    @Body() UpdateUserRequest request,
  );

  // ========== ACTIVITY ENDPOINTS ==========
  @GET('/activities')
  Future<ApiResponse<List<Activity>>> getActivities({
    @Query('page') int page = 1,
    @Query('limit') int limit = 20,
    @Query('category') String? category,
    @Query('search') String? search,
    @Query('sortBy') String? sortBy,
    @Query('featured') bool? featured,
  });

  @GET('/activities/featured')
  Future<ApiResponse<List<Activity>>> getFeaturedActivities();

  @GET('/activities/{id}')
  Future<ApiResponse<Activity>> getActivityById(@Path('id') String id);

  @POST('/activities')
  Future<ApiResponse<Activity>> createActivity(
    @Body() CreateActivityRequest request,
  );

  @PUT('/activities/{id}')
  Future<ApiResponse<Activity>> updateActivity(
    @Path('id') String id,
    @Body() UpdateActivityRequest request,
  );

  @DELETE('/activities/{id}')
  Future<ApiResponse<String>> deleteActivity(@Path('id') String id);

  // ========== HEALTH CHECK ==========
  @GET('/health')
  Future<ApiResponse<HealthResponse>> healthCheck();
}

// ========== RESPONSE MODELS ==========
@JsonSerializable()
class HealthResponse {
  final String message;
  final String timestamp;
  final String environment;

  HealthResponse({
    required this.message,
    required this.timestamp,
    required this.environment,
  });

  factory HealthResponse.fromJson(Map<String, dynamic> json) =>
      _$HealthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$HealthResponseToJson(this);
}

// ========== RESPONSE WRAPPERS ==========
@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final List<String>? errors;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);
}

@JsonSerializable(genericArgumentFactories: true)
class PaginatedResponse<T> {
  final List<T> data;
  final Pagination pagination;

  PaginatedResponse({
    required this.data,
    required this.pagination,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$PaginatedResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$PaginatedResponseToJson(this, toJsonT);
}

@JsonSerializable()
class Pagination {
  final int currentPage;
  final int totalPages;
  final int totalUsers;
  final bool hasNext;
  final bool hasPrev;

  Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalUsers,
    required this.hasNext,
    required this.hasPrev,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationToJson(this);
}

// ========== AUTH REQUEST MODELS ==========
@JsonSerializable()
class RegisterRequest {
  final String name;
  final String email;
  final String password;
  final String? phone;
  final String role;
  final String? companyName;
  final String? location;

  RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
    this.phone,
    this.role = 'client',
    this.companyName,
    this.location,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

@JsonSerializable()
class LoginResponse {
  final User user;
  final String token;

  LoginResponse({
    required this.user,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class UpdateProfileRequest {
  final String? name;
  final String? phone;
  final String? location;
  final String? companyName;

  UpdateProfileRequest({
    this.name,
    this.phone,
    this.location,
    this.companyName,
  });

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProfileRequestToJson(this);
}

@JsonSerializable()
class UpdateUserRequest {
  final String? name;
  final String? email;
  final String? phone;
  final String? role;
  final String? status;
  final String? location;
  final String? companyName;

  UpdateUserRequest({
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
}