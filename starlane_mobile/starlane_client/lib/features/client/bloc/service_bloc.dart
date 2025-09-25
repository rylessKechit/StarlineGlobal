// Path: starlane_mobile/starlane_client/lib/features/client/bloc/service_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/service.dart';
import '../repositories/service_repository.dart';

// Events
abstract class ServiceEvent extends Equatable {
  const ServiceEvent();
  
  @override
  List<Object?> get props => [];
}

class ServiceLoadRequested extends ServiceEvent {
  final int page;
  final int limit;
  final String? category;
  final String? search;
  final String? sortBy;
  
  const ServiceLoadRequested({
    this.page = 1,
    this.limit = 20,
    this.category,
    this.search,
    this.sortBy,
  });
  
  @override
  List<Object?> get props => [page, limit, category, search, sortBy];
}

class ServiceFeaturedLoadRequested extends ServiceEvent {}

class ServiceSearchRequested extends ServiceEvent {
  final String query;
  final String? category;
  final String? sortBy;
  
  const ServiceSearchRequested({
    required this.query,
    this.category,
    this.sortBy,
  });
  
  @override
  List<Object?> get props => [query, category, sortBy];
}

class ServiceFilterChanged extends ServiceEvent {
  final String? category;
  final String? search;
  final String? sortBy;
  
  const ServiceFilterChanged({
    this.category,
    this.search,
    this.sortBy,
  });
  
  @override
  List<Object?> get props => [category, search, sortBy];
}

class ServiceRefreshRequested extends ServiceEvent {
  final String? category;
  final String? search;
  final String? sortBy;
  
  const ServiceRefreshRequested({
    this.category,
    this.search,
    this.sortBy,
  });
  
  @override
  List<Object?> get props => [category, search, sortBy];
}

// ✅ NOUVELLE CLASSE AJOUTÉE
class ServiceDetailRequested extends ServiceEvent {
  final String serviceId;

  const ServiceDetailRequested({required this.serviceId});

  @override
  List<Object> get props => [serviceId];
}

// States
abstract class ServiceState extends Equatable {
  const ServiceState();
  
  @override
  List<Object?> get props => [];
}

class ServiceInitial extends ServiceState {}

class ServiceLoading extends ServiceState {}

class ServiceLoaded extends ServiceState {
  final List<Service> services;
  final bool hasReachedMax;
  
  const ServiceLoaded({
    required this.services,
    this.hasReachedMax = false,
  });
  
  @override
  List<Object?> get props => [services, hasReachedMax];
}

class ServiceFeaturedLoaded extends ServiceState {
  final List<Service> services;
  
  const ServiceFeaturedLoaded({required this.services});
  
  @override
  List<Object?> get props => [services];
}

class ServiceError extends ServiceState {
  final String message;
  
  const ServiceError({required this.message});
  
  @override
  List<Object?> get props => [message];
}

// ✅ NOUVELLE CLASSE AJOUTÉE
class ServiceDetailLoaded extends ServiceState {
  final Service service;

  const ServiceDetailLoaded({required this.service});

  @override
  List<Object> get props => [service];
}

// Bloc
class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final ServiceRepository _serviceRepository;
  
  ServiceBloc({required ServiceRepository serviceRepository})
      : _serviceRepository = serviceRepository,
        super(ServiceInitial()) {
    on<ServiceLoadRequested>(_onLoadRequested);
    on<ServiceFeaturedLoadRequested>(_onFeaturedLoadRequested);
    on<ServiceSearchRequested>(_onSearchRequested);
    on<ServiceFilterChanged>(_onFilterChanged);
    on<ServiceRefreshRequested>(_onRefreshRequested);
    on<ServiceDetailRequested>(_onServiceDetailRequested); // ✅ AJOUTÉ
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
        search: event.search,
        sortBy: event.sortBy,
      );
      
      emit(ServiceLoaded(
        services: services,
        hasReachedMax: services.length < event.limit,
      ));
    } catch (e) {
      emit(ServiceError(message: e.toString()));
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
      emit(ServiceError(message: e.toString()));
    }
  }

  Future<void> _onSearchRequested(
    ServiceSearchRequested event,
    Emitter<ServiceState> emit,
  ) async {
    emit(ServiceLoading());
    
    try {
      final services = await _serviceRepository.getServices(
        search: event.query,
        category: event.category,
        sortBy: event.sortBy,
      );
      
      emit(ServiceLoaded(
        services: services,
        hasReachedMax: true,
      ));
    } catch (e) {
      emit(ServiceError(message: e.toString()));
    }
  }

  Future<void> _onFilterChanged(
    ServiceFilterChanged event,
    Emitter<ServiceState> emit,
  ) async {
    emit(ServiceLoading());
    
    try {
      final services = await _serviceRepository.getServices(
        category: event.category,
        search: event.search,
        sortBy: event.sortBy,
      );
      
      emit(ServiceLoaded(
        services: services,
        hasReachedMax: true,
      ));
    } catch (e) {
      emit(ServiceError(message: e.toString()));
    }
  }

  Future<void> _onRefreshRequested(
    ServiceRefreshRequested event,
    Emitter<ServiceState> emit,
  ) async {
    try {
      final services = await _serviceRepository.getServices(
        category: event.category,
        search: event.search,
        sortBy: event.sortBy,
      );
      
      emit(ServiceLoaded(
        services: services,
        hasReachedMax: true,
      ));
    } catch (e) {
      emit(ServiceError(message: e.toString()));
    }
  }

  // ✅ NOUVELLE MÉTHODE AJOUTÉE
  Future<void> _onServiceDetailRequested(
    ServiceDetailRequested event,
    Emitter<ServiceState> emit,
  ) async {
    emit(ServiceLoading());
    
    try {
      final service = await _serviceRepository.getServiceById(event.serviceId);
      emit(ServiceDetailLoaded(service: service));
    } catch (error) {
      emit(ServiceError(message: 'Erreur lors du chargement des détails du service'));
      print('🚨 Erreur ServiceDetailRequested: $error');
    }
  }
}