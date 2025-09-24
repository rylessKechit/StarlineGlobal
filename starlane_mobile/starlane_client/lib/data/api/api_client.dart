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
  // ✅ CORRIGÉ: URL avec le bon port
  static const String baseUrl = kDebugMode 
    ? 'http://localhost:4000/api'  // Port 4000 comme votre backend
    : 'https://api.starlaneglobal.com/api';
  
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;
}

/// Client HTTP configuré pour Starlane Global
class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;
  
  DioClient._internal() {
    // ✅ CORRIGÉ: Initialisation automatique dans le constructeur
    _initializeDio();
  }

  late Dio _dio;
  final _storage = const FlutterSecureStorage();

  Dio get dio => _dio;

  // ✅ MÉTHODE PRIVÉE - Plus de méthode initialize() publique
  void _initializeDio() {
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

  // ========== AUTH ENDPOINTS ==========
  // ✅ CORRIGÉ: register retourne User, pas AuthResponse
  @POST('/auth/register')
  Future<ApiResponse<User>> register(@Body() RegisterRequest request);

  // ✅ CORRIGÉ: login retourne LoginResponse, pas AuthResponse
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

  // ========== BOOKING ENDPOINTS ==========
  @GET('/bookings')
  Future<ApiResponse<List<Booking>>> getBookings({
    @Query('page') int page = 1,
    @Query('limit') int limit = 20,
    @Query('status') String? status,
  });

  @GET('/bookings/{id}')
  Future<ApiResponse<Booking>> getBookingById(@Path('id') String id);

  @POST('/bookings')
  Future<ApiResponse<Booking>> createBooking(
    @Body() CreateBookingRequest request,
  );

  @PUT('/bookings/{id}')
  Future<ApiResponse<Booking>> updateBooking(
    @Path('id') String id,
    @Body() UpdateBookingRequest request,
  );

  @DELETE('/bookings/{id}')
  Future<ApiResponse<String>> cancelBooking(@Path('id') String id);

  // ========== HEALTH CHECK ==========
  @GET('/health')
  Future<ApiResponse<HealthResponse>> healthCheck();
}

// ========== REQUEST MODELS - AJOUT DES CLASSES MANQUANTES ==========

// ✅ AJOUT: LoginRequest (qui n'avait que email/password dans votre log)
@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

// ✅ AJOUT: RegisterRequest
@JsonSerializable()
class RegisterRequest {
  final String name;
  final String email;
  final String password;
  final String? phone;
  final String role;
  final String? location;
  final String? companyName;

  RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
    this.phone,
    this.role = 'client',
    this.location,
    this.companyName,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) => _$RegisterRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

// ✅ AJOUT: UpdateProfileRequest
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

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) => _$UpdateProfileRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateProfileRequestToJson(this);
}

// ✅ AJOUT: LoginResponse (pour différencier de AuthResponse)
@JsonSerializable()
class LoginResponse {
  final User user;
  final String token;

  LoginResponse({
    required this.user,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
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

// ========== BOOKING MODELS ==========
@JsonSerializable()
class Booking {
  final String id;
  final String activityId;
  final String clientId;
  final String providerId;
  final String bookingNumber;
  final BookingDate bookingDate;
  final BookingPricing pricing;
  final BookingStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Booking({
    required this.id,
    required this.activityId,
    required this.clientId,
    required this.providerId,
    required this.bookingNumber,
    required this.bookingDate,
    required this.pricing,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);

  Map<String, dynamic> toJson() => _$BookingToJson(this);
}

@JsonSerializable()
class BookingDate {
  final DateTime start;
  final DateTime end;

  BookingDate({
    required this.start,
    required this.end,
  });

  factory BookingDate.fromJson(Map<String, dynamic> json) =>
      _$BookingDateFromJson(json);

  Map<String, dynamic> toJson() => _$BookingDateToJson(this);
}

@JsonSerializable()
class BookingPricing {
  final double baseAmount;
  final double totalAmount;
  final String currency;

  BookingPricing({
    required this.baseAmount,
    required this.totalAmount,
    required this.currency,
  });

  factory BookingPricing.fromJson(Map<String, dynamic> json) =>
      _$BookingPricingFromJson(json);

  Map<String, dynamic> toJson() => _$BookingPricingToJson(this);
}

enum BookingStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('confirmed')
  confirmed,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('refunded')
  refunded;

  String get displayName {
    switch (this) {
      case BookingStatus.pending:
        return 'En attente';
      case BookingStatus.confirmed:
        return 'Confirmée';
      case BookingStatus.inProgress:
        return 'En cours';
      case BookingStatus.completed:
        return 'Terminée';
      case BookingStatus.cancelled:
        return 'Annulée';
      case BookingStatus.refunded:
        return 'Remboursée';
    }
  }
}

// ========== BOOKING REQUEST MODELS ==========
@JsonSerializable()
class CreateBookingRequest {
  final String activityId;
  final DateTime startDate;
  final DateTime endDate;
  final int participants;

  CreateBookingRequest({
    required this.activityId,
    required this.startDate,
    required this.endDate,
    required this.participants,
  });

  factory CreateBookingRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateBookingRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateBookingRequestToJson(this);
}

@JsonSerializable()
class UpdateBookingRequest {
  final DateTime? startDate;
  final DateTime? endDate;
  final int? participants;
  final BookingStatus? status;

  UpdateBookingRequest({
    this.startDate,
    this.endDate,
    this.participants,
    this.status,
  });

  factory UpdateBookingRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateBookingRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateBookingRequestToJson(this);
}

// ========== UPDATE USER REQUEST ==========
@JsonSerializable()
class UpdateUserRequest {
  final String? name;
  final String? email;
  final String? phone;
  final String? location;

  UpdateUserRequest({
    this.name,
    this.email,
    this.phone,
    this.location,
  });

  factory UpdateUserRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateUserRequestToJson(this);
}

// ========== EXCEPTION CLASSES ==========
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