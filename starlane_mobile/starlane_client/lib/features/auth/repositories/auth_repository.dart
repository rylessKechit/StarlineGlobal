import 'package:dio/dio.dart';
import '../../../data/api/api_client.dart';
import '../../../data/models/user.dart';

abstract class AuthRepository {
  Future<AuthResponse> login(LoginRequest request);
  Future<AuthResponse> register(RegisterRequest request);
  Future<User> getProfile();
  Future<User> updateProfile(UpdateProfileRequest request);
  Future<void> logout();
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
      throw AuthException(message: 'Erreur inattendue lors de la connexion');
    }
  }

  @override
  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await _apiClient.register(request);
      
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
      await _apiClient.logout();
    } on DioException catch (e) {
      // On peut ignorer certaines erreurs lors de la déconnexion
      if (e.response?.statusCode != 401) {
        throw _handleDioException(e);
      }
    } catch (e) {
      // Ignorer les erreurs de logout pour ne pas bloquer l'utilisateur
      print('Erreur lors de la déconnexion: $e');
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
          message: 'Impossible de se connecter au serveur. Vérifiez votre connexion internet.',
        );
      
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;
        
        String message = 'Erreur du serveur';
        List<String>? errors;
        
        if (data is Map<String, dynamic>) {
          message = data['message'] ?? message;
          errors = data['errors']?.cast<String>();
        }
        
        switch (statusCode) {
          case 400:
            return AuthException(
              message: 'Données invalides. $message',
              errors: errors,
            );
          case 401:
            return AuthException(message: 'Email ou mot de passe incorrect');
          case 403:
            return AuthException(
              message: 'Accès refusé. Votre compte peut être suspendu.',
            );
          case 409:
            return AuthException(message: 'Un compte avec cet email existe déjà');
          case 422:
            return AuthException(
              message: 'Données de validation invalides',
              errors: errors,
            );
          case 500:
            return AuthException(
              message: 'Erreur interne du serveur. Veuillez réessayer plus tard.',
            );
          default:
            return AuthException(message: message);
        }
      
      case DioExceptionType.cancel:
        return AuthException(message: 'Requête annulée');
      
      case DioExceptionType.unknown:
      default:
        return AuthException(
          message: 'Erreur de connexion. Vérifiez votre connexion internet.',
        );
    }
  }
}

/// Exception personnalisée pour les erreurs d'authentification
class AuthException implements Exception {
  final String message;
  final List<String>? errors;
  final int? statusCode;

  AuthException({
    required this.message,
    this.errors,
    this.statusCode,
  });

  @override
  String toString() {
    if (errors != null && errors!.isNotEmpty) {
      return '$message\n${errors!.join('\n')}';
    }
    return message;
  }
}

/// Extension pour faciliter la gestion des erreurs
extension AuthExceptionExtension on AuthException {
  bool get isNetworkError => message.contains('connexion') || message.contains('internet');
  bool get isValidationError => errors != null && errors!.isNotEmpty;
  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isConflict => statusCode == 409;
}