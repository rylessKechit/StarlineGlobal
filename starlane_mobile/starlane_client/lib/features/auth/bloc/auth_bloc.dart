import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../../data/models/user.dart';
import '../../../data/api/api_client.dart';
import '../repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final FlutterSecureStorage _storage;
  Timer? _tokenTimer;

  AuthBloc({
    required AuthRepository authRepository,
    required FlutterSecureStorage storage,
  })  : _authRepository = authRepository,
        _storage = storage,
        super(AuthInitial()) {
    
    on<AuthStarted>(_onAuthStarted);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthProfileUpdateRequested>(_onProfileUpdateRequested);
    on<AuthTokenRefreshRequested>(_onTokenRefreshRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
  }

  @override
  Future<void> close() {
    _tokenTimer?.cancel();
    return super.close();
  }

  Future<void> _onAuthStarted(AuthStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    
    try {
      final token = await _storage.read(key: 'auth_token');
      final userJson = await _storage.read(key: 'user_data');
      
      if (token != null && userJson != null && !JwtDecoder.isExpired(token)) {
        final user = User.fromJson(Map<String, dynamic>.from(
          Uri.splitQueryString(userJson)
        ));
        
        // Démarrer le timer de rafraîchissement du token
        _startTokenTimer(token);
        
        emit(AuthAuthenticated(user: user, token: token));
      } else {
        // Token expiré ou inexistant
        await _clearStorage();
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      await _clearStorage();
      emit(AuthFailure(error: 'Erreur lors de la vérification de l\'authentification'));
    }
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event, 
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      final request = LoginRequest(
        email: event.email,
        password: event.password,
        role: event.role.name,
      );
      
      final response = await _authRepository.login(request);
      
      // Stocker les données d'authentification
      await _storage.write(key: 'auth_token', value: response.token);
      await _storage.write(key: 'user_data', value: response.user.toJson().toString());
      
      // Démarrer le timer de rafraîchissement du token
      _startTokenTimer(response.token);
      
      emit(AuthAuthenticated(
        user: response.user,
        token: response.token,
      ));
    } catch (e) {
      emit(AuthFailure(error: _getErrorMessage(e)));
    }
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      final request = RegisterRequest(
        name: event.name,
        email: event.email,
        password: event.password,
        phone: event.phone,
        role: event.role.name,
        companyName: event.companyName,
        location: event.location,
      );
      
      final response = await _authRepository.register(request);
      
      // Pour un nouvel utilisateur, on peut soit auto-connecter soit rediriger vers login
      if (response.user.status == UserStatus.active) {
        await _storage.write(key: 'auth_token', value: response.token);
        await _storage.write(key: 'user_data', value: response.user.toJson().toString());
        
        _startTokenTimer(response.token);
        
        emit(AuthAuthenticated(
          user: response.user,
          token: response.token,
        ));
      } else {
        // Utilisateur en attente d'approbation
        emit(AuthRegistrationPending(
          message: 'Votre compte a été créé avec succès. '
                  'Il est en attente d\'approbation par notre équipe.',
        ));
      }
    } catch (e) {
      emit(AuthFailure(error: _getErrorMessage(e)));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authRepository.logout();
    } catch (e) {
      // On continue le logout même en cas d'erreur API
      print('Logout API error: $e');
    } finally {
      await _clearStorage();
      _tokenTimer?.cancel();
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onProfileUpdateRequested(
    AuthProfileUpdateRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state is! AuthAuthenticated) return;
    
    final currentState = state as AuthAuthenticated;
    emit(AuthLoading());
    
    try {
      final updatedUser = await _authRepository.updateProfile(event.request);
      
      // Mettre à jour le stockage local
      await _storage.write(key: 'user_data', value: updatedUser.toJson().toString());
      
      emit(AuthAuthenticated(
        user: updatedUser,
        token: currentState.token,
      ));
    } catch (e) {
      emit(AuthFailure(error: _getErrorMessage(e)));
      // Revenir à l'état précédent en cas d'erreur
      emit(currentState);
    }
  }

  Future<void> _onTokenRefreshRequested(
    AuthTokenRefreshRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Dans votre backend, vous devriez implémenter un endpoint de refresh
    // Pour l'instant, on redirige vers login si le token expire
    try {
      final token = await _storage.read(key: 'auth_token');
      if (token != null && JwtDecoder.isExpired(token)) {
        add(AuthLogoutRequested());
      }
    } catch (e) {
      add(AuthLogoutRequested());
    }
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final token = await _storage.read(key: 'auth_token');
      if (token == null || JwtDecoder.isExpired(token)) {
        add(AuthLogoutRequested());
        return;
      }

      // Optionnel: vérifier avec le serveur
      final user = await _authRepository.getProfile();
      await _storage.write(key: 'user_data', value: user.toJson().toString());
      
      if (state is AuthAuthenticated) {
        final currentState = state as AuthAuthenticated;
        emit(AuthAuthenticated(
          user: user,
          token: currentState.token,
        ));
      }
    } catch (e) {
      // En cas d'erreur, déconnecter l'utilisateur
      add(AuthLogoutRequested());
    }
  }

  void _startTokenTimer(String token) {
    _tokenTimer?.cancel();
    
    try {
      final expiryDate = JwtDecoder.getExpirationDate(token);
      final timeToExpiry = expiryDate.difference(DateTime.now());
      
      // Rafraîchir le token 5 minutes avant expiration
      final refreshTime = timeToExpiry - const Duration(minutes: 5);
      
      if (refreshTime.isNegative) {
        // Token expire bientôt, déconnecter
        add(AuthLogoutRequested());
        return;
      }
      
      _tokenTimer = Timer(refreshTime, () {
        add(AuthTokenRefreshRequested());
      });
    } catch (e) {
      // Erreur lors du décodage du token
      add(AuthLogoutRequested());
    }
  }

  Future<void> _clearStorage() async {
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'user_data');
  }

  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('400')) {
      return 'Données invalides. Veuillez vérifier vos informations.';
    } else if (error.toString().contains('401')) {
      return 'Email ou mot de passe incorrect.';
    } else if (error.toString().contains('403')) {
      return 'Accès refusé. Votre compte peut être suspendu.';
    } else if (error.toString().contains('409')) {
      return 'Un compte avec cet email existe déjà.';
    } else if (error.toString().contains('network')) {
      return 'Erreur de connexion. Vérifiez votre internet.';
    } else {
      return 'Une erreur s\'est produite. Veuillez réessayer.';
    }
  }
}