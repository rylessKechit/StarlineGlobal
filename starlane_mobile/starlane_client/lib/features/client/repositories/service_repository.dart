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
      print('🔍 Repository: Appel getServices avec category=$category');
      
      final response = await _serviceApiClient.getServices(
        page: page,
        limit: limit,
        category: category,
        featured: null,
      );
      
      print('🌐 API Response success: ${response.success}');
      
      if (response.success && response.data != null) {
        // CORRECTION - response.data est déjà une List<Service> typée par Retrofit
        var services = response.data!;
        
        print('📊 Services reçus: ${services.length}');
        for (final service in services) {
          print('✅ Service: ${service.title} (${service.category})');
        }
        
        // Filtrage côté client pour search (temporaire)
        if (search != null && search.isNotEmpty) {
          final searchLower = search.toLowerCase();
          services = services.where((service) {
            return service.title.toLowerCase().contains(searchLower) ||
                   service.description.toLowerCase().contains(searchLower) ||
                   (service.shortDescription?.toLowerCase().contains(searchLower) ?? false);
          }).toList();
          
          print('🔍 Services filtrés par recherche "$search": ${services.length}');
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
          print('📊 Services triés par: $sortBy');
        }
        
        print('✅ Services traités avec succès: ${services.length}');
        return services;
      } else {
        final errorMessage = response.message;
        print('🚨 Erreur API: $errorMessage');
        throw ApiException(
          message: errorMessage,
          errors: response.errors,
        );
      }
    } on DioException catch (e) {
      print('🚨 Erreur Dio dans getServices: ${e.type} - ${e.message}');
      throw _handleDioException(e);
    } catch (e, stackTrace) {
      print('🚨 Erreur générale dans getServices: $e');
      print('🔍 Stack trace: ${stackTrace.toString().split('\n').take(3).join('\n')}');
      rethrow;
    }
  }

  @override
  Future<List<Service>> getFeaturedServices() async {
    try {
      print('🔍 Repository: Appel getFeaturedServices');
      
      final response = await _serviceApiClient.getFeaturedServices();
      
      print('🌐 API Response success: ${response.success}');
      
      if (response.success && response.data != null) {
        // CORRECTION - response.data est déjà une List<Service> typée par Retrofit
        final services = response.data!;
        
        print('📊 Services featured reçus: ${services.length}');
        for (final service in services) {
          print('✅ Service featured: ${service.title}');
        }
        
        return services;
      } else {
        final errorMessage = response.message;
        print('🚨 Erreur API featured: $errorMessage');
        throw ApiException(
          message: errorMessage,
          errors: response.errors,
        );
      }
    } on DioException catch (e) {
      print('🚨 Erreur Dio dans getFeaturedServices: ${e.type} - ${e.message}');
      throw _handleDioException(e);
    } catch (e, stackTrace) {
      print('🚨 Erreur générale dans getFeaturedServices: $e');
      print('🔍 Stack trace: ${stackTrace.toString().split('\n').take(3).join('\n')}');
      rethrow;
    }
  }

  @override
  Future<Service> getServiceById(String id) async {
    try {
      print('🔍 Repository: Appel getServiceById pour id=$id');
      
      final response = await _serviceApiClient.getServiceById(id);
      
      if (response.success && response.data != null) {
        // CORRECTION - response.data est déjà un Service typé par Retrofit
        final service = response.data!;
        
        print('✅ Service chargé: ${service.title}');
        return service;
      } else {
        final errorMessage = response.message ?? 'Service introuvable';
        throw ApiException(
          message: errorMessage,
          errors: response.errors,
        );
      }
    } on DioException catch (e) {
      print('🚨 Erreur Dio dans getServiceById: $e');
      throw _handleDioException(e);
    } catch (e, stackTrace) {
      print('🚨 Erreur générale dans getServiceById: $e');
      print('🔍 Stack trace: ${stackTrace.toString().split('\n').take(3).join('\n')}');
      rethrow;
    }
  }

  // Gestion des erreurs Dio
  ApiException _handleDioException(DioException e) {
    print('🔍 Gestion erreur Dio: ${e.type}');
    
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Délai de connexion dépassé. Vérifiez votre connexion internet.',
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;
        
        print('🔍 Réponse HTTP $statusCode: $data');
        
        if (data is Map<String, dynamic> && data['message'] != null) {
          return ApiException(
            message: data['message'].toString(),
            errors: data['errors'],
          );
        }
        
        switch (statusCode) {
          case 404:
            return ApiException(message: 'Service non trouvé');
          case 500:
            return ApiException(message: 'Erreur serveur. Veuillez réessayer plus tard.');
          default:
            return ApiException(message: 'Erreur réseau: $statusCode');
        }
      case DioExceptionType.cancel:
        return ApiException(message: 'Requête annulée');
      case DioExceptionType.connectionError:
        return ApiException(message: 'Erreur de connexion. Vérifiez votre connexion internet.');
      default:
        return ApiException(message: 'Erreur inattendue: ${e.message}');
    }
  }
}