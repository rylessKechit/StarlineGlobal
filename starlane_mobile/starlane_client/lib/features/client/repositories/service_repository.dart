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
    bool? featured,
  });
  Future<List<Service>> getFeaturedServices();
  Future<Service> getServiceById(String id);
  Future<Service> createService(CreateServiceRequest request);
  Future<Service> updateService(String id, UpdateServiceRequest request);
  Future<String> deleteService(String id);
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
    bool? featured,
  }) async {
    try {
      final response = await _serviceApiClient.getServices(
        page: page,
        limit: limit,
        category: category,
        featured: featured,
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
      throw ApiException(message: 'Erreur lors de la récupération des services');
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
      throw ApiException(message: 'Erreur lors de la récupération des services phares');
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

  @override
  Future<Service> createService(CreateServiceRequest request) async {
    try {
      final response = await _serviceApiClient.createService(request);
      
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
      throw ApiException(message: 'Erreur lors de la création du service');
    }
  }

  @override
  Future<Service> updateService(String id, UpdateServiceRequest request) async {
    try {
      final response = await _serviceApiClient.updateService(id, request);
      
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
      throw ApiException(message: 'Erreur lors de la mise à jour du service');
    }
  }

  @override
  Future<String> deleteService(String id) async {
    try {
      final response = await _serviceApiClient.deleteService(id);
      
      if (response.success) {
        return response.message;
      } else {
        throw ApiException(message: response.message);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ApiException(message: 'Erreur lors de la suppression du service');
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
        
        return ApiException(
          message: message,
          statusCode: statusCode,
          errors: errors,
        );
      
      case DioExceptionType.cancel:
        return ApiException(
          message: 'Requête annulée',
          statusCode: e.response?.statusCode,
        );
      
      case DioExceptionType.connectionError:
        return ApiException(
          message: 'Erreur de connexion. Vérifiez votre réseau.',
          statusCode: e.response?.statusCode,
        );
      
      default:
        return ApiException(
          message: e.message ?? 'Erreur inconnue',
          statusCode: e.response?.statusCode,
        );
    }
  }
}