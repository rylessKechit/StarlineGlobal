// Path: starlane_mobile/starlane_client/lib/features/client/repositories/activity_repository.dart
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
        // ✅ CORRECTION: Votre backend renvoie une structure avec pagination
        // Il faut extraire les activités de data.activities
        final responseData = response.data as Map<String, dynamic>?;
        if (responseData != null && responseData['activities'] != null) {
          final activitiesList = responseData['activities'] as List;
          return activitiesList
              .map((json) => Activity.fromJson(json as Map<String, dynamic>))
              .toList();
        }
        return [];
      } else {
        throw ApiException(
          message: response.message,
          errors: response.errors,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      print('🔍 ERREUR getActivities: $e');
      throw ApiException(message: 'Erreur lors de la récupération des activités');
    }
  }

  @override
  Future<List<Activity>> getFeaturedActivities() async {
    try {
      final response = await _apiClient.getFeaturedActivities();
      
      if (response.success && response.data != null) {
        // Pour les featured, votre backend renvoie directement la liste
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
        
        String message = 'Erreur serveur';
        List<String>? errors;
        
        if (data is Map<String, dynamic>) {
          message = data['message'] ?? message;
          errors = (data['errors'] as List?)?.cast<String>();
        }
        
        switch (statusCode) {
          case 400:
            return ApiException(message: 'Requête invalide: $message', errors: errors);
          case 401:
            return ApiException(message: 'Non autorisé. Veuillez vous reconnecter.');
          case 403:
            return ApiException(message: 'Accès refusé.');
          case 404:
            return ApiException(message: 'Ressource non trouvée.');
          case 500:
            return ApiException(message: 'Erreur serveur. Veuillez réessayer.');
          default:
            return ApiException(message: 'Erreur $statusCode: $message');
        }
      
      case DioExceptionType.connectionError:
        return ApiException(
          message: 'Impossible de se connecter au serveur. Vérifiez votre connexion.',
        );
      
      case DioExceptionType.cancel:
        return ApiException(message: 'Requête annulée');
      
      case DioExceptionType.unknown:
      default:
        return ApiException(message: 'Erreur de connexion inconnue');
    }
  }
}