// Path: starlane_mobile/starlane_client/lib/features/client/bloc/service_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// ✅ AJOUT DE L'IMPORT MANQUANT POUR ApiException
import '../../../data/api/api_client.dart';
import '../../../data/models/service.dart';
import '../repositories/service_repository.dart';

part 'service_event.dart';
part 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final ServiceRepository _serviceRepository;

  ServiceBloc({required ServiceRepository serviceRepository})
      : _serviceRepository = serviceRepository,
        super(ServiceInitial()) {
    
    on<ServiceLoadRequested>(_onServiceLoadRequested);
    on<ServiceFeaturedLoadRequested>(_onServiceFeaturedLoadRequested);
    on<ServiceDetailLoadRequested>(_onServiceDetailLoadRequested);
    on<ServiceCreateRequested>(_onServiceCreateRequested);
    on<ServiceUpdateRequested>(_onServiceUpdateRequested);
    on<ServiceDeleteRequested>(_onServiceDeleteRequested);
  }

  Future<void> _onServiceLoadRequested(
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
      
      emit(ServiceLoaded(services: services));
    } catch (e) {
      emit(ServiceError(
        message: _getErrorMessage(e),
        // ✅ CORRIGÉ: ApiException est maintenant reconnu
        errors: e is ApiException ? e.errors : null,
      ));
    }
  }

  Future<void> _onServiceFeaturedLoadRequested(
    ServiceFeaturedLoadRequested event,
    Emitter<ServiceState> emit,
  ) async {
    emit(ServiceLoading());
    
    try {
      final featuredServices = await _serviceRepository.getFeaturedServices();
      emit(ServiceFeaturedLoaded(services: featuredServices));
    } catch (e) {
      emit(ServiceError(
        message: _getErrorMessage(e),
        // ✅ CORRIGÉ: ApiException est maintenant reconnu
        errors: e is ApiException ? e.errors : null,
      ));
    }
  }

  Future<void> _onServiceDetailLoadRequested(
    ServiceDetailLoadRequested event,
    Emitter<ServiceState> emit,
  ) async {
    emit(ServiceLoading());
    
    try {
      final service = await _serviceRepository.getServiceById(event.serviceId);
      emit(ServiceDetailLoaded(service: service));
    } catch (e) {
      emit(ServiceError(
        message: _getErrorMessage(e),
        // ✅ CORRIGÉ: ApiException est maintenant reconnu
        errors: e is ApiException ? e.errors : null,
      ));
    }
  }

  Future<void> _onServiceCreateRequested(
    ServiceCreateRequested event,
    Emitter<ServiceState> emit,
  ) async {
    emit(ServiceLoading());
    
    try {
      final createdService = await _serviceRepository.createService(event.request);
      emit(ServiceCreateSuccess(service: createdService));
    } catch (e) {
      emit(ServiceError(
        message: _getErrorMessage(e),
        // ✅ CORRIGÉ: ApiException est maintenant reconnu
        errors: e is ApiException ? e.errors : null,
      ));
    }
  }

  Future<void> _onServiceUpdateRequested(
    ServiceUpdateRequested event,
    Emitter<ServiceState> emit,
  ) async {
    emit(ServiceLoading());
    
    try {
      final updatedService = await _serviceRepository.updateService(
        event.serviceId,
        event.request,
      );
      emit(ServiceUpdateSuccess(service: updatedService));
    } catch (e) {
      emit(ServiceError(
        message: _getErrorMessage(e),
        // ✅ CORRIGÉ: ApiException est maintenant reconnu
        errors: e is ApiException ? e.errors : null,
      ));
    }
  }

  Future<void> _onServiceDeleteRequested(
    ServiceDeleteRequested event,
    Emitter<ServiceState> emit,
  ) async {
    emit(ServiceLoading());
    
    try {
      await _serviceRepository.deleteService(event.serviceId);
      emit(ServiceDeleteSuccess(serviceId: event.serviceId));
    } catch (e) {
      emit(ServiceError(
        message: _getErrorMessage(e),
        // ✅ CORRIGÉ: ApiException est maintenant reconnu
        errors: e is ApiException ? e.errors : null,
      ));
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error is ApiException) {
      return error.message;
    }
    return error.toString();
  }
}