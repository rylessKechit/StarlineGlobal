// Path: starlane_mobile/starlane_client/lib/features/client/bloc/service_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/service.dart';
import '../repositories/service_repository.dart';

// ========== EVENTS ==========
abstract class ServiceEvent extends Equatable {
  const ServiceEvent();

  @override
  List<Object?> get props => [];
}

class ServiceLoadRequested extends ServiceEvent {
  final int page;
  final int limit;
  final String? category;
  final bool? featured;

  const ServiceLoadRequested({
    this.page = 1,
    this.limit = 20,
    this.category,
    this.featured,
  });

  @override
  List<Object?> get props => [page, limit, category, featured];
}

class ServiceFeaturedLoadRequested extends ServiceEvent {}

class ServiceCategoryFilterChanged extends ServiceEvent {
  final String? category;

  const ServiceCategoryFilterChanged({this.category});

  @override
  List<Object?> get props => [category];
}

class ServiceRefreshRequested extends ServiceEvent {
  final String? category;
  final bool? featured;

  const ServiceRefreshRequested({
    this.category,
    this.featured,
  });

  @override
  List<Object?> get props => [category, featured];
}

class ServiceDetailsRequested extends ServiceEvent {
  final String serviceId;

  const ServiceDetailsRequested({required this.serviceId});

  @override
  List<Object?> get props => [serviceId];
}

// ========== STATES ==========
abstract class ServiceState extends Equatable {
  const ServiceState();

  @override
  List<Object> get props => [];
}

class ServiceInitial extends ServiceState {}

class ServiceLoading extends ServiceState {}

class ServiceLoaded extends ServiceState {
  final List<Service> services;
  final bool hasReachedMax;
  final String? currentCategory;

  const ServiceLoaded({
    required this.services,
    required this.hasReachedMax,
    this.currentCategory,
  });

  ServiceLoaded copyWith({
    List<Service>? services,
    bool? hasReachedMax,
    String? currentCategory,
  }) {
    return ServiceLoaded(
      services: services ?? this.services,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentCategory: currentCategory ?? this.currentCategory,
    );
  }

  @override
  List<Object> get props => [services, hasReachedMax];
}

class ServiceFeaturedLoaded extends ServiceState {
  final List<Service> services;

  const ServiceFeaturedLoaded({required this.services});

  @override
  List<Object> get props => [services];
}

class ServiceDetailsLoaded extends ServiceState {
  final Service service;

  const ServiceDetailsLoaded({required this.service});

  @override
  List<Object> get props => [service];
}

class ServiceError extends ServiceState {
  final String message;
  final List<String>? errors;

  const ServiceError({
    required this.message,
    this.errors,
  });

  @override
  List<Object> get props => [message];
}

// ========== BLOC ==========
class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final ServiceRepository _serviceRepository;

  ServiceBloc({required ServiceRepository serviceRepository})
      : _serviceRepository = serviceRepository,
        super(ServiceInitial()) {
    
    on<ServiceLoadRequested>(_onLoadRequested);
    on<ServiceFeaturedLoadRequested>(_onFeaturedLoadRequested);
    on<ServiceCategoryFilterChanged>(_onCategoryFilterChanged);
    on<ServiceRefreshRequested>(_onRefreshRequested);
    on<ServiceDetailsRequested>(_onDetailsRequested);
  }

  Future<void> _onLoadRequested(
    ServiceLoadRequested event,
    Emitter<ServiceState> emit,
  ) async {
    emit(ServiceLoading());
    
    try {
      final services = await _serviceRepository.getServices(
        page: event.page,
        limit: event.limit,
        category: event.category,
        featured: event.featured,
      );
      
      emit(ServiceLoaded(
        services: services,
        hasReachedMax: services.length < event.limit,
        currentCategory: event.category,
      ));
    } catch (e) {
      emit(ServiceError(
        message: e.toString(),
        errors: e is ApiException ? e.errors : null,
      ));
    }
  }

  Future<void> _onFeaturedLoadRequested(
    ServiceFeaturedLoadRequested event,
    Emitter<ServiceState> emit,
  ) async {
    emit(ServiceLoading());
    
    try {
      final featuredServices = await _serviceRepository.getFeaturedServices();
      
      emit(ServiceFeaturedLoaded(services: featuredServices));
    } catch (e) {
      emit(ServiceError(
        message: e.toString(),
        errors: e is ApiException ? e.errors : null,
      ));
    }
  }

  Future<void> _onCategoryFilterChanged(
    ServiceCategoryFilterChanged event,
    Emitter<ServiceState> emit,
  ) async {
    emit(ServiceLoading());
    
    try {
      final services = await _serviceRepository.getServices(
        category: event.category,
      );
      
      emit(ServiceLoaded(
        services: services,
        hasReachedMax: true,
        currentCategory: event.category,
      ));
    } catch (e) {
      emit(ServiceError(
        message: e.toString(),
        errors: e is ApiException ? e.errors : null,
      ));
    }
  }

  Future<void> _onRefreshRequested(
    ServiceRefreshRequested event,
    Emitter<ServiceState> emit,
  ) async {
    try {
      final services = await _serviceRepository.getServices(
        category: event.category,
        featured: event.featured,
      );
      
      emit(ServiceLoaded(
        services: services,
        hasReachedMax: true,
        currentCategory: event.category,
      ));
    } catch (e) {
      emit(ServiceError(
        message: e.toString(),
        errors: e is ApiException ? e.errors : null,
      ));
    }
  }

  Future<void> _onDetailsRequested(
    ServiceDetailsRequested event,
    Emitter<ServiceState> emit,
  ) async {
    emit(ServiceLoading());
    
    try {
      final service = await _serviceRepository.getServiceById(event.serviceId);
      
      emit(ServiceDetailsLoaded(service: service));
    } catch (e) {
      emit(ServiceError(
        message: e.toString(),
        errors: e is ApiException ? e.errors : null,
      ));
    }
  }
}