// Path: starlane_mobile/starlane_client/lib/features/client/bloc/service_state.dart
part of 'service_bloc.dart';

abstract class ServiceState extends Equatable {
  const ServiceState();

  @override
  List<Object?> get props => [];
}

class ServiceInitial extends ServiceState {}

class ServiceLoading extends ServiceState {}

class ServiceLoaded extends ServiceState {
  final List<Service> services;

  const ServiceLoaded({required this.services});

  @override
  List<Object> get props => [services];
}

class ServiceFeaturedLoaded extends ServiceState {
  final List<Service> services;

  const ServiceFeaturedLoaded({required this.services});

  @override
  List<Object> get props => [services];
}

class ServiceDetailLoaded extends ServiceState {
  final Service service;

  const ServiceDetailLoaded({required this.service});

  @override
  List<Object> get props => [service];
}

class ServiceCreateSuccess extends ServiceState {
  final Service service;

  const ServiceCreateSuccess({required this.service});

  @override
  List<Object> get props => [service];
}

class ServiceUpdateSuccess extends ServiceState {
  final Service service;

  const ServiceUpdateSuccess({required this.service});

  @override
  List<Object> get props => [service];
}

class ServiceDeleteSuccess extends ServiceState {
  final String serviceId;

  const ServiceDeleteSuccess({required this.serviceId});

  @override
  List<Object> get props => [serviceId];
}

class ServiceError extends ServiceState {
  final String message;
  final List<String>? errors;

  const ServiceError({
    required this.message,
    this.errors,
  });

  @override
  List<Object?> get props => [message, errors];
}

class ServiceDetailLoaded extends ServiceState {
  final Service service;

  const ServiceDetailLoaded({required this.service});

  @override
  List<Object> get props => [service];
}