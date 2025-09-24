// Path: starlane_mobile/starlane_client/lib/features/auth/bloc/auth_bloc.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:equatable/equatable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

// ✅ IMPORTS CORRECTS - Classes bien séparées
import '../../../data/api/api_client.dart' show LoginRequest, RegisterRequest, UpdateProfileRequest;
import '../../../data/models/user.dart' show User, AuthResponse, UserRole, AuthException;
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
  }) : _authRepository = authRepository,
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

  Future<void> _onAuthStarted(
    AuthStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      final token = await _storage.read(key: 'auth_token');
      final userDataString = await _storage.read(key: 'user_data');
      
      if (token != null && userDataString != null) {
        // Vérifier si le token est valide et non expiré
        if (!JwtDecoder.isExpired(token)) {
          final userMap = jsonDecode(userDataString);
          final user = User.fromJson(userMap);
          
          // Démarrer le timer de rafraîchissement
          _startTokenTimer(token);
          
          emit(AuthAuthenticated(user: user, token: token));
          return;
        }
      }
      
      // Token expiré ou inexistant
      await _clearStorage();
      emit(AuthUnauthenticated());
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
      // ✅ CORRIGÉ: Suppression du paramètre 'role' qui n'existe pas dans LoginRequest
      final request = LoginRequest(
        email: event.email,
        password: event.password,
      );
      
      final response = await _authRepository.login(request);
      
      // Stocker les données d'authentification
      await _storage.write(key: 'auth_token', value: response.token);
      await _storage.write(key: 'user_data', value: jsonEncode(response.user.toJson()));
      
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
        location: event.location,
        companyName: event.companyName,
      );
      
      final response = await _authRepository.register(request);
      
      // Si le register ne retourne pas de token, faire un login automatique
      if (response.token.isEmpty) {
        // Faire un login automatique après inscription
        final loginRequest = LoginRequest(
          email: event.email,
          password: event.password,
        );
        final loginResponse = await _authRepository.login(loginRequest);
        
        // Stocker les données d'authentification du login
        await _storage.write(key: 'auth_token', value: loginResponse.token);
        await _storage.write(key: 'user_data', value: jsonEncode(loginResponse.user.toJson()));
        
        _startTokenTimer(loginResponse.token);
        
        emit(AuthAuthenticated(
          user: loginResponse.user,
          token: loginResponse.token,
        ));
      } else {
        // Si le register retourne un token
        await _storage.write(key: 'auth_token', value: response.token);
        await _storage.write(key: 'user_data', value: jsonEncode(response.user.toJson()));
        
        _startTokenTimer(response.token);
        
        emit(AuthAuthenticated(
          user: response.user,
          token: response.token,
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
      // Tentative de logout côté serveur
      await _authRepository.logout();
    } catch (e) {
      // Ignorer les erreurs de logout côté serveur
    }
    
    // Nettoyer le stockage local
    await _clearStorage();
    
    // Annuler le timer
    _tokenTimer?.cancel();
    
    emit(AuthUnauthenticated());
  }

  Future<void> _onProfileUpdateRequested(
    AuthProfileUpdateRequested event,
    Emitter<AuthState> emit,
  ) async {
    final currentState = state;
    if (currentState is! AuthAuthenticated) return;
    
    emit(AuthLoading());
    
    try {
      // ✅ CORRIGÉ: Suppression du paramètre 'avatar' qui n'existe pas dans UpdateProfileRequest
      final request = UpdateProfileRequest(
        name: event.name,
        phone: event.phone,
        location: event.location,
        companyName: null, // Peut être ajouté selon les besoins
      );
      
      final updatedUser = await _authRepository.updateProfile(request);
      
      // Mettre à jour le stockage local
      await _storage.write(key: 'user_data', value: jsonEncode(updatedUser.toJson()));
      
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
    try {
      final token = await _storage.read(key: 'auth_token');
      if (token != null && JwtDecoder.isExpired(token)) {
        await _clearStorage();
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      await _clearStorage();
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final token = await _storage.read(key: 'auth_token');
    final userDataString = await _storage.read(key: 'user_data');
    
    if (token != null && userDataString != null) {
      try {
        if (!JwtDecoder.isExpired(token)) {
          final userMap = jsonDecode(userDataString);
          final user = User.fromJson(userMap);
          
          emit(AuthAuthenticated(user: user, token: token));
          return;
        }
      } catch (e) {
        // Erreur lors du décodage
      }
    }
    
    await _clearStorage();
    emit(AuthUnauthenticated());
  }

  void _startTokenTimer(String token) {
    _tokenTimer?.cancel();
    
    try {
      final expiryDate = JwtDecoder.getExpirationDate(token);
      final timeUntilExpiry = expiryDate.difference(DateTime.now());
      
      // Rafraîchir le token 5 minutes avant expiration
      final refreshTime = timeUntilExpiry - const Duration(minutes: 5);
      
      if (refreshTime.isNegative) {
        // Token expire dans moins de 5 minutes, vérifier immédiatement
        add(AuthTokenRefreshRequested());
        return;
      }
      
      _tokenTimer = Timer(refreshTime, () {
        add(AuthTokenRefreshRequested());
      });
    } catch (e) {
      // Erreur lors de l'analyse du token, forcer la vérification
      add(AuthTokenRefreshRequested());
    }
  }

  Future<void> _clearStorage() async {
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'user_data');
  }

  String _getErrorMessage(dynamic error) {
    // ✅ CORRIGÉ: AuthException maintenant correctement importé
    if (error is AuthException) {
      return error.message;
    }
    return error.toString();
  }
}