// Path: starlane_mobile/starlane_client/lib/data/models/service.dart
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'service.g.dart';

@JsonSerializable()
class Service extends Equatable {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String description;
  final String? shortDescription;
  final ServiceCategory category;
  final String serviceType;
  final ServicePricing pricing;
  final String icon;
  final List<ServiceImage> images;
  final List<String> features;
  final List<String> included;
  final bool isActive;
  final bool isFeatured;
  final int priority;
  final ServiceDetails? serviceDetails;
  final ServiceStats stats;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Service({
    required this.id,
    required this.name,
    required this.description,
    this.shortDescription,
    required this.category,
    required this.serviceType,
    required this.pricing,
    required this.icon,
    this.images = const [],
    this.features = const [],
    this.included = const [],
    this.isActive = true,
    this.isFeatured = false,
    this.priority = 0,
    this.serviceDetails,
    required this.stats,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) => _$ServiceFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceToJson(this);

  // Getters utilitaires
  String get displayDescription => shortDescription ?? description;
  
  String get formattedPrice {
    if (pricing.isCustomQuote) {
      return 'Sur devis';
    }
    
    const symbols = {'EUR': '€', 'USD': '\$', 'GBP': '£'};
    final symbol = symbols[pricing.currency] ?? pricing.currency;
    
    String suffix = '';
    switch(pricing.priceType) {
      case PriceType.perHour:
        suffix = '/h';
        break;
      case PriceType.perDay:
        suffix = '/jour';
        break;
      case PriceType.fixed:
        suffix = '';
        break;
      case PriceType.custom:
        suffix = '';
        break;
    }
    
    return '${pricing.basePrice.toStringAsFixed(0)}$symbol$suffix';
  }

  @override
  List<Object?> get props => [
    id, name, description, shortDescription, category, serviceType,
    pricing, icon, images, features, included, isActive, isFeatured,
    priority, serviceDetails, stats, createdAt, updatedAt
  ];
}

@JsonEnum()
enum ServiceCategory {
  @JsonValue('airTravel')
  airTravel,
  @JsonValue('transport')
  transport,
  @JsonValue('realEstate')
  realEstate,
  @JsonValue('corporate')
  corporate;

  String get displayName {
    switch (this) {
      case ServiceCategory.airTravel:
        return 'Aviation Privée';
      case ServiceCategory.transport:
        return 'Transport';
      case ServiceCategory.realEstate:
        return 'Immobilier';
      case ServiceCategory.corporate:
        return 'Corporate';
    }
  }

  String get description {
    switch (this) {
      case ServiceCategory.airTravel:
        return 'Services aériens de luxe';
      case ServiceCategory.transport:
        return 'Transport premium';
      case ServiceCategory.realEstate:
        return 'Services immobiliers';
      case ServiceCategory.corporate:
        return 'Solutions entreprise';
    }
  }

  String get iconName {
    switch (this) {
      case ServiceCategory.airTravel:
        return 'flight';
      case ServiceCategory.transport:
        return 'directions_car';
      case ServiceCategory.realEstate:
        return 'home';
      case ServiceCategory.corporate:
        return 'business';
    }
  }
}

@JsonEnum()
enum PriceType {
  @JsonValue('fixed')
  fixed,
  @JsonValue('per_hour')
  perHour,
  @JsonValue('per_day')
  perDay,
  @JsonValue('custom')
  custom;
}

@JsonSerializable()
class ServicePricing extends Equatable {
  final double basePrice;
  final String currency;
  final PriceType priceType;
  final bool isCustomQuote;

  const ServicePricing({
    required this.basePrice,
    this.currency = 'EUR',
    this.priceType = PriceType.fixed,
    this.isCustomQuote = false,
  });

  factory ServicePricing.fromJson(Map<String, dynamic> json) => 
      _$ServicePricingFromJson(json);
  Map<String, dynamic> toJson() => _$ServicePricingToJson(this);

  @override
  List<Object?> get props => [basePrice, currency, priceType, isCustomQuote];
}

@JsonSerializable()
class ServiceImage extends Equatable {
  final String url;
  final String? alt;
  final bool isPrimary;

  const ServiceImage({
    required this.url,
    this.alt,
    this.isPrimary = false,
  });

  factory ServiceImage.fromJson(Map<String, dynamic> json) => 
      _$ServiceImageFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceImageToJson(this);

  @override
  List<Object?> get props => [url, alt, isPrimary];
}

@JsonSerializable()
class ServiceDetails extends Equatable {
  final String? airTravelType;
  final String? transportType;
  final String? realEstateType;
  final String? corporateType;

  const ServiceDetails({
    this.airTravelType,
    this.transportType,
    this.realEstateType,
    this.corporateType,
  });

  factory ServiceDetails.fromJson(Map<String, dynamic> json) => 
      _$ServiceDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceDetailsToJson(this);

  @override
  List<Object?> get props => [
    airTravelType, transportType, realEstateType, corporateType
  ];
}

@JsonSerializable()
class ServiceStats extends Equatable {
  final int orders;
  final double revenue;

  const ServiceStats({
    this.orders = 0,
    this.revenue = 0.0,
  });

  factory ServiceStats.fromJson(Map<String, dynamic> json) => 
      _$ServiceStatsFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceStatsToJson(this);

  @override
  List<Object?> get props => [orders, revenue];
}

// Request Models
@JsonSerializable()
class CreateServiceRequest extends Equatable {
  final String name;
  final String description;
  final String? shortDescription;
  final ServiceCategory category;
  final String serviceType;
  final ServicePricing pricing;
  final String icon;
  final List<ServiceImage> images;
  final List<String> features;
  final List<String> included;
  final bool isFeatured;
  final int priority;
  final ServiceDetails? serviceDetails;

  const CreateServiceRequest({
    required this.name,
    required this.description,
    this.shortDescription,
    required this.category,
    required this.serviceType,
    required this.pricing,
    required this.icon,
    this.images = const [],
    this.features = const [],
    this.included = const [],
    this.isFeatured = false,
    this.priority = 0,
    this.serviceDetails,
  });

  factory CreateServiceRequest.fromJson(Map<String, dynamic> json) => 
      _$CreateServiceRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateServiceRequestToJson(this);

  @override
  List<Object?> get props => [
    name, description, shortDescription, category, serviceType,
    pricing, icon, images, features, included, isFeatured, priority, serviceDetails
  ];
}

@JsonSerializable()
class UpdateServiceRequest extends Equatable {
  final String? name;
  final String? description;
  final String? shortDescription;
  final ServiceCategory? category;
  final String? serviceType;
  final ServicePricing? pricing;
  final String? icon;
  final List<ServiceImage>? images;
  final List<String>? features;
  final List<String>? included;
  final bool? isFeatured;
  final int? priority;
  final ServiceDetails? serviceDetails;

  const UpdateServiceRequest({
    this.name,
    this.description,
    this.shortDescription,
    this.category,
    this.serviceType,
    this.pricing,
    this.icon,
    this.images,
    this.features,
    this.included,
    this.isFeatured,
    this.priority,
    this.serviceDetails,
  });

  factory UpdateServiceRequest.fromJson(Map<String, dynamic> json) => 
      _$UpdateServiceRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateServiceRequestToJson(this);

  @override
  List<Object?> get props => [
    name, description, shortDescription, category, serviceType,
    pricing, icon, images, features, included, isFeatured, priority, serviceDetails
  ];
}