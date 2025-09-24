// Path: starlane_mobile/starlane_client/lib/features/auth/repositories/auth_repository.dart
import 'package:dio/dio.dart';
// ✅ IMPORTS CORRECTS - Seulement les classes nécessaires
import '../../../data/api/api_client.dart';
import '../../../data/models/user.dart' show User, AuthResponse, AuthException;

abstract class AuthRepository {
  Future<AuthResponse> login(LoginRequest request);
  Future<AuthResponse> register(RegisterRequest request);
  Future<User> getProfile();
  Future<User> updateProfile(UpdateProfileRequest request);
  Future<void> logout();
  Future<bool> healthCheck();
}

class AuthRepositoryImpl implements AuthRepository {
  final StarlaneApiClient _apiClient;

  AuthRepositoryImpl({required StarlaneApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _apiClient.login(request);
      
      if (response.success && response.data != null) {
        // ✅ CORRIGÉ: Retourner AuthResponse créé à partir de LoginResponse
        return AuthResponse(
          user: response.data!.user,
          token: response.data!.token,
        );
      } else {
        throw AuthException(
          message: response.message,
          errors: response.errors,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw AuthException(message: 'Erreur inattendue lors de la connexion');
    }
  }

  @override
  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await _apiClient.register(request);
      
      if (response.success && response.data != null) {
        // ✅ CORRIGÉ: Pour le register, on doit faire un login après
        // ou l'API doit retourner le token avec l'utilisateur
        // Pour l'instant, on crée une réponse avec un token vide
        // Il faudra adapter selon la réponse réelle de votre API
        return AuthResponse(
          user: response.data!,
          token: '', // TODO: L'API register doit retourner un token
        );
      } else {
        throw AuthException(
          message: response.message,
          errors: response.errors,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw AuthException(message: 'Erreur inattendue lors de l\'inscription');
    }
  }

  @override
  Future<User> getProfile() async {
    try {
      final response = await _apiClient.getProfile();
      
      if (response.success && response.data != null) {
        return response.data!;
      } else {
        throw AuthException(message: response.message);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw AuthException(message: 'Erreur lors de la récupération du profil');
    }
  }

  @override
  Future<User> updateProfile(UpdateProfileRequest request) async {
    try {
      final response = await _apiClient.updateProfile(request);
      
      if (response.success && response.data != null) {
        return response.data!;
      } else {
        throw AuthException(
          message: response.message,
          errors: response.errors,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw AuthException(message: 'Erreur lors de la mise à jour du profil');
    }
  }

  @override
  Future<void> logout() async {
    try {
      final response = await _apiClient.logout();
      if (!response.success) {
        throw AuthException(message: response.message);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode != 401) {
        throw _handleDioException(e);
      }
      // Si 401, on considère que c'est OK (token déjà expiré)
    } catch (e) {
      // Ignorer les autres erreurs de logout pour ne pas bloquer l'utilisateur
    }
  }

  @override
  Future<bool> healthCheck() async {
    try {
      // Pour l'instant, on fait un simple ping vers getProfile
      // Vous pouvez ajouter un endpoint /health dans votre API
      await _apiClient.getProfile();
      return true;
    } catch (e) {
      return false;
    }
  }

  AuthException _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AuthException(
          message: 'Délai de connexion dépassé. Vérifiez votre connexion internet.',
        );
      
      case DioExceptionType.connectionError:
        return AuthException(
          message: 'Impossible de se connecter au serveur. Vérifiez que votre API tourne sur le port 5000.',
        );
      
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;
        
        String message = 'Erreur du serveur';
        List<String>? errors;
        
        if (data is Map<String, dynamic>) {
          message = data['message'] ?? message;
          if (data['errors'] is List) {
            errors = (data['errors'] as List).cast<String>();
          }
        }
        
        switch (statusCode) {
          case 400:
            return AuthException(message: 'Données invalides. $message', errors: errors);
          case 401:
            return AuthException(message: 'Email ou mot de passe incorrect');
          case 403:
            return AuthException(message: 'Accès refusé. Votre compte peut être suspendu.');
          case 404:
            return AuthException(message: 'Service non trouvé. Vérifiez l\'URL de votre API.');
          case 422:
            return AuthException(message: 'Données de validation incorrectes', errors: errors);
          case 500:
            return AuthException(message: 'Erreur interne du serveur. Veuillez réessayer.');
          default:
            return AuthException(message: 'Erreur inattendue ($statusCode): $message');
        }
      
      case DioExceptionType.cancel:
        return AuthException(message: 'Requête annulée');
      
      case DioExceptionType.unknown:
      default:
        return AuthException(message: 'Erreur de connexion inconnue');
    }
  }
}