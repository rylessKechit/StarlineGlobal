import 'package:dio/dio.dart';
import '../../../data/api/api_client.dart';
import '../../../data/models/activity.dart';

abstract class ActivityRepository {
  Future<List<Activity>> getActivities({
    int page = 1,
    int limit = 20,
    String? category,
    String? search,
    String? sortBy,
  });
  Future<List<Activity>> getFeaturedActivities();
  Future<Activity> getActivityById(String id);
}

class ActivityRepositoryImpl implements ActivityRepository {
  final StarlaneApiClient _apiClient;

  ActivityRepositoryImpl({required StarlaneApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<List<Activity>> getActivities({
    int page = 1,
    int limit = 20,
    String? category,
    String? search,
    String? sortBy,
  }) async {
    try {
      final response = await _apiClient.getActivities(
        page: page,
        limit: limit,
        category: category,
        search: search,
        sortBy: sortBy,
      );
      
      if (response.success && response.data != null) {
        return response.data!;
      } else {
        throw ApiException(
          message: response.message,
          errors: response.errors,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ApiException(message: 'Erreur lors de la récupération des activités');
    }
  }

  @override
  Future<List<Activity>> getFeaturedActivities() async {
    try {
      final response = await _apiClient.getFeaturedActivities();
      
      if (response.success && response.data != null) {
        return response.data!;
      } else {
        throw ApiException(
          message: response.message,
          errors: response.errors,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ApiException(message: 'Erreur lors de la récupération des activités phares');
    }
  }

  @override
  Future<Activity> getActivityById(String id) async {
    try {
      final response = await _apiClient.getActivityById(id);
      
      if (response.success && response.data != null) {
        return response.data!;
      } else {
        throw ApiException(message: response.message);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ApiException(message: 'Erreur lors de la récupération de l\'activité');
    }
  }

  ApiException _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return ApiException(
          message: 'Timeout de connexion. Vérifiez votre connexion internet.',
          statusCode: e.response?.statusCode,
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;
        
        String message = 'Une erreur est survenue';
        List<String>? errors;
        
        if (data is Map<String, dynamic>) {
          message = data['message'] ?? message;
          if (data['errors'] is List) {
            errors = List<String>.from(data['errors']);
          }
        }
        
        return ApiException(
          message: message,
          statusCode: statusCode,
          errors: errors,
        );
      case DioExceptionType.cancel:
        return ApiException(message: 'Requête annulée');
      default:
        return ApiException(
          message: 'Erreur de connexion. Vérifiez votre connexion internet.',
          statusCode: e.response?.statusCode,
        );
    }
  }
}