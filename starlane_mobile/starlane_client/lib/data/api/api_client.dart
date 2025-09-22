import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:retrofit/retrofit.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_client.g.dart';

/// Configuration pour l'API Starlane Global
class ApiConfig {
  static const String baseUrl = kDebugMode 
    ? 'http://localhost:5000/api'  // Développement
    : 'https://api.starlaneglobal.com/api';  // Production
  
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

    // Intercepteurs
    _dio.interceptors.add(_AuthInterceptor(_storage));
    
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
      // Token expiré, rediriger vers login
      await _storage.deleteAll();
      // Ici vous pouvez ajouter la navigation vers login
    }
    super.onError(err, handler);
  }
}

/// Client API principal avec Retrofit
@RestApi()
abstract class StarlaneApiClient {
  factory StarlaneApiClient(Dio dio, {String baseUrl}) = _StarlaneApiClient;

  // ============ AUTH ENDPOINTS ============
  @POST('/auth/register')
  Future<ApiResponse<AuthResponse>> register(@Body() RegisterRequest request);

  @POST('/auth/login')
  Future<ApiResponse<AuthResponse>> login(@Body() LoginRequest request);

  @GET('/auth/profile')
  Future<ApiResponse<User>> getProfile();

  @PUT('/auth/profile')
  Future<ApiResponse<User>> updateProfile(@Body() UpdateProfileRequest request);

  @POST('/auth/logout')
  Future<ApiResponse<void>> logout();

  // ============ USER ENDPOINTS ============
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

  // ============ ACTIVITIES ENDPOINTS ============ 
  @GET('/activities')
  Future<ApiResponse<List<Activity>>> getActivities({
    @Query('category') String? category,
    @Query('location') String? location,
    @Query('page') int page = 1,
    @Query('limit') int limit = 20,
  });

  @GET('/activities/{id}')
  Future<ApiResponse<Activity>> getActivityById(@Path('id') String activityId);

  @POST('/activities')
  Future<ApiResponse<Activity>> createActivity(@Body() CreateActivityRequest request);

  @PUT('/activities/{id}')
  Future<ApiResponse<Activity>> updateActivity(
    @Path('id') String activityId,
    @Body() UpdateActivityRequest request,
  );

  @DELETE('/activities/{id}')
  Future<ApiResponse<void>> deleteActivity(@Path('id') String activityId);

  @GET('/activities/provider/{providerId}')
  Future<ApiResponse<List<Activity>>> getProviderActivities(
    @Path('providerId') String providerId,
  );

  // ============ BOOKINGS ENDPOINTS ============
  @GET('/bookings')
  Future<ApiResponse<List<Booking>>> getBookings({
    @Query('status') String? status,
    @Query('page') int page = 1,
    @Query('limit') int limit = 20,
  });

  @GET('/bookings/{id}')
  Future<ApiResponse<Booking>> getBookingById(@Path('id') String bookingId);

  @POST('/bookings')
  Future<ApiResponse<Booking>> createBooking(@Body() CreateBookingRequest request);

  @PUT('/bookings/{id}')
  Future<ApiResponse<Booking>> updateBooking(
    @Path('id') String bookingId,
    @Body() UpdateBookingRequest request,
  );

  @PATCH('/bookings/{id}/status')
  Future<ApiResponse<Booking>> updateBookingStatus(
    @Path('id') String bookingId,
    @Body() UpdateStatusRequest request,
  );

  @GET('/bookings/client/{clientId}')
  Future<ApiResponse<List<Booking>>> getClientBookings(
    @Path('clientId') String clientId,
  );

  @GET('/bookings/provider/{providerId}')
  Future<ApiResponse<List<Booking>>> getProviderBookings(
    @Path('providerId') String providerId,
  );

  // ============ REVIEWS ENDPOINTS ============
  @GET('/reviews/activity/{activityId}')
  Future<ApiResponse<List<Review>>> getActivityReviews(
    @Path('activityId') String activityId,
  );

  @POST('/reviews')
  Future<ApiResponse<Review>> createReview(@Body() CreateReviewRequest request);

  @GET('/reviews/user/{userId}')
  Future<ApiResponse<List<Review>>> getUserReviews(@Path('userId') String userId);
}

// ============ RESPONSE WRAPPERS ============
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

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
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

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
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