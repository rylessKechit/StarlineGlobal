// Path: starlane_mobile/starlane_client/lib/features/client/bloc/service_event.dart
part of 'service_bloc.dart';

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

class ServiceDetailLoadRequested extends ServiceEvent {
  final String serviceId;

  const ServiceDetailLoadRequested({required this.serviceId});

  @override
  List<Object> get props => [serviceId];
}

class ServiceCreateRequested extends ServiceEvent {
  final CreateServiceRequest request;

  const ServiceCreateRequested({required this.request});

  @override
  List<Object> get props => [request];
}

class ServiceUpdateRequested extends ServiceEvent {
  final String serviceId;
  final UpdateServiceRequest request;

  const ServiceUpdateRequested({
    required this.serviceId,
    required this.request,
  });

  @override
  List<Object> get props => [serviceId, request];
}

class ServiceDeleteRequested extends ServiceEvent {
  final String serviceId;

  const ServiceDeleteRequested({required this.serviceId});

  @override
  List<Object> get props => [serviceId];
}