// Path: starlane_mobile/starlane_client/lib/features/client/repositories/service_repository.dart
import 'package:dio/dio.dart';
import '../../../data/api/api_client.dart';
import '../../../data/api/service_api_client.dart';
import '../../../data/models/service.dart';

abstract class ServiceRepository {
  Future<List<Service>> getServices({
    int page = 1,
    int limit = 20,
    String? category,
    String? search,
    String? sortBy,
  });
  Future<List<Service>> getFeaturedServices();
  Future<Service> getServiceById(String id);
}

class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceApiClient _serviceApiClient;

  ServiceRepositoryImpl({required ServiceApiClient serviceApiClient})
      : _serviceApiClient = serviceApiClient;

  @override
  Future<List<Service>> getServices({
    int page = 1,
    int limit = 20,
    String? category,
    String? search,
    String? sortBy,
  }) async {
    try {
      final response = await _serviceApiClient.getServices(
        page: page,
        limit: limit,
        category: category,
        featured: null,
      );
      
      if (response.success && response.data != null) {
        var services = response.data!;
        
        // Filtrage côté client pour search (temporaire)
        if (search != null && search.isNotEmpty) {
          services = services.where((service) {
            return service.title.toLowerCase().contains(search.toLowerCase()) ||
                   service.description.toLowerCase().contains(search.toLowerCase()) ||
                   (service.shortDescription?.toLowerCase().contains(search.toLowerCase()) ?? false);
          }).toList();
        }
        
        // Tri côté client (temporaire)
        if (sortBy != null) {
          switch (sortBy) {
            case 'title':
              services.sort((a, b) => a.title.compareTo(b.title));
              break;
            case 'category':
              services.sort((a, b) => a.category.compareTo(b.category));
              break;
            case 'createdAt':
              services.sort((a, b) => b.createdAt.compareTo(a.createdAt));
              break;
          }
        }
        
        return services;
      } else {
        throw ApiException(
          message: response.message,
          errors: response.errors,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      return <Service>[];
    }
  }

  @override
  Future<List<Service>> getFeaturedServices() async {
    try {
      final response = await _serviceApiClient.getFeaturedServices();
      
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
      return <Service>[];
    }
  }

  @override
  Future<Service> getServiceById(String id) async {
    try {
      final response = await _serviceApiClient.getServiceById(id);
      
      if (response.success && response.data != null) {
        return response.data!;
      } else {
        throw ApiException(message: response.message);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ApiException(message: 'Erreur lors de la récupération du service');
    }
  }

  // Helper pour gérer les erreurs Dio
  ApiException _handleDioException(DioException e) {
    
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Délai de connexion dépassé. Vérifiez votre connexion internet.',
          statusCode: e.response?.statusCode,
        );
      
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 0;
        final responseData = e.response?.data;
        
        if (statusCode >= 500) {
          return ApiException(
            message: 'Erreur serveur. Veuillez réessayer plus tard.',
            statusCode: statusCode,
          );
        } else if (statusCode == 404) {
          return ApiException(
            message: 'Service non trouvé.',
            statusCode: statusCode,
          );
        } else if (statusCode == 401) {
          return ApiException(
            message: 'Non autorisé. Veuillez vous reconnecter.',
            statusCode: statusCode,
          );
        } else {
          String message = 'Erreur lors de la requête.';
          if (responseData is Map<String, dynamic> && responseData['message'] != null) {
            message = responseData['message'];
          }
          return ApiException(
            message: message,
            statusCode: statusCode,
          );
        }
      
      case DioExceptionType.cancel:
        return ApiException(message: 'Requête annulée.');
      
      default:
        return ApiException(
          message: 'Erreur de connexion. Vérifiez votre connexion internet.',
        );
    }
  }
}