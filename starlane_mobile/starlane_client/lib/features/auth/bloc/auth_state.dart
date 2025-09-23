part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;
  final String token;

  const AuthAuthenticated({
    required this.user,
    required this.token,
  });

  @override
  List<Object> get props => [user, token];
}

class AuthUnauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String error;

  const AuthFailure({required this.error});

  @override
  List<Object> get props => [error];
}