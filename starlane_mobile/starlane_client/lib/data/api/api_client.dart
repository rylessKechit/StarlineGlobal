import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:retrofit/retrofit.dart';
import 'package:json_annotation/json_annotation.dart';
import '../models/user.dart';

part 'api_client.g.dart';

/// Configuration pour l'API Starlane Global
class ApiConfig {
  static const String baseUrl = kDebugMode 
    ? 'http://localhost:4000/api'
    : 'https://api.starlaneglobal.com/api';
  
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;
}

/// Client HTTP configuré pour Starlane Global
class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;
  DioClient._internal();

  late Dio _dio;
  final _storage = const FlutterSecureStorage();

  Dio get dio => _dio;

  void initialize() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: Duration(milliseconds: ApiConfig.connectTimeout),
      receiveTimeout: Duration(milliseconds: ApiConfig.receiveTimeout),
      sendTimeout: Duration(milliseconds: ApiConfig.sendTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(_AuthInterceptor(_storage));
    
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
        error: true,
        logPrint: (obj) => print('🌐 API: $obj'),
      ));
    }
  }
}

/// Intercepteur d'authentification
class _AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;

  _AuthInterceptor(this._storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storage.read(key: 'auth_token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await _storage.deleteAll();
    }
    super.onError(err, handler);
  }
}

/// Client API principal avec Retrofit
@RestApi()
abstract class StarlaneApiClient {
  factory StarlaneApiClient(Dio dio, {String baseUrl}) = _StarlaneApiClient;

  @POST('/auth/register')
  Future<ApiResponse<AuthResponse>> register(@Body() RegisterRequest request);

  @POST('/auth/login')
  Future<ApiResponse<AuthResponse>> login(@Body() LoginRequest request);

  @GET('/auth/profile')
  Future<ApiResponse<User>> getProfile();

  @PUT('/auth/profile')
  Future<ApiResponse<User>> updateProfile(@Body() UpdateProfileRequest request);

  @POST('/auth/logout')
  Future<ApiResponse<String>> logout();

  @GET('/users')
  Future<ApiResponse<PaginatedResponse<User>>> getUsers({
    @Query('page') int page = 1,
    @Query('limit') int limit = 10,
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

  @GET('/health')
  Future<ApiResponse<HealthResponse>> healthCheck();
}

// Response Models
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

// Response Wrappers
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

// Exception Classes
class AuthException implements Exception {
  final String message;
  final List<String>? errors;

  AuthException({required this.message, this.errors});

  @override
  String toString() => 'AuthException: $message';
}

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
  String toString() => 'ApiException($statusCode): $message';
}