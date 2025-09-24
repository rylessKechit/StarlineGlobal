part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthStarted extends AuthEvent {}

// CORRECTION: role optionnel avec valeur par défaut
class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;
  final UserRole role;

  const AuthLoginRequested({
    required this.email,
    required this.password,
    this.role = UserRole.client, // AJOUT: Valeur par défaut
  });

  @override
  List<Object> get props => [email, password, role];
}

class AuthRegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String? phone;
  final UserRole role;
  final String? location;
  final String? companyName;

  const AuthRegisterRequested({
    required this.name,
    required this.email,
    required this.password,
    this.phone,
    required this.role,
    this.location,
    this.companyName,
  });

  @override
  List<Object?> get props => [name, email, password, phone, role, location, companyName];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthProfileUpdateRequested extends AuthEvent {
  final String? name;
  final String? phone;
  final String? location;
  final String? avatar;

  const AuthProfileUpdateRequested({
    this.name,
    this.phone,
    this.location,
    this.avatar,
  });

  @override
  List<Object?> get props => [name, phone, location, avatar];
}

class AuthTokenRefreshRequested extends AuthEvent {}

class AuthCheckRequested extends AuthEvent {}