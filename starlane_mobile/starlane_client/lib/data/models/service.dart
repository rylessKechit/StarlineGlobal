import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'service.g.dart';

@JsonSerializable()
class Service extends Equatable {
  final String id;
  final String title;
  final String description;
  final String? shortDescription;
  final String category;
  final String? subCategory;
  final List<String>? tags;
  final ServicePricing? pricing;
  final List<ServiceImage>? images;
  final List<String>? features;
  final bool featured;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Service({
    required this.id,
    required this.title,
    required this.description,
    this.shortDescription,
    required this.category,
    this.subCategory,
    this.tags,
    this.pricing,
    this.images,
    this.features,
    this.featured = false,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    try {
      // CORRECTION - Adaptation pour votre backend avec gestion robuste des nulls
      return Service(
        id: (json['_id'] ?? json['id'] ?? '').toString(),
        title: (json['name'] ?? json['title'] ?? 'Service sans nom').toString(),
        description: (json['description'] ?? '').toString(),
        shortDescription: json['shortDescription']?.toString(),
        category: (json['category'] ?? 'default').toString(),
        subCategory: json['subCategory']?.toString(),
        tags: json['tags'] != null 
            ? (json['tags'] as List).map((e) => e.toString()).toList()
            : null,
        pricing: json['pricing'] != null
            ? ServicePricing.fromJson(json['pricing'] as Map<String, dynamic>)
            : null,
        images: json['images'] != null
            ? (json['images'] as List)
                .map((img) => ServiceImage.fromJson(img as Map<String, dynamic>))
                .toList()
            : null,
        features: json['features'] != null
            ? (json['features'] as List).map((e) => e.toString()).toList()
            : json['included'] != null
                ? (json['included'] as List).map((e) => e.toString()).toList()
                : null,
        featured: json['isFeatured'] == true || json['featured'] == true,
        status: (json['isActive'] == true || json['status'] == 'active') ? 'active' : 'inactive',
        createdAt: DateTime.parse((json['createdAt'] ?? DateTime.now().toIso8601String()).toString()),
        updatedAt: DateTime.parse((json['updatedAt'] ?? DateTime.now().toIso8601String()).toString()),
      );
    } catch (e) {
      print('🔍 ERREUR Service.fromJson: $e');
      print('🔍 JSON problématique: $json');
      // Retour d'un service par défaut en cas d'erreur
      return Service(
        id: (json['_id'] ?? json['id'] ?? 'unknown').toString(),
        title: 'Service indisponible',
        description: 'Erreur lors du chargement du service',
        category: 'default',
        featured: false,
        status: 'inactive',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }

  Map<String, dynamic> toJson() => _$ServiceToJson(this);

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        shortDescription,
        category,
        subCategory,
        tags,
        pricing,
        images,
        features,
        featured,
        status,
        createdAt,
        updatedAt,
      ];

  Service copyWith({
    String? id,
    String? title,
    String? description,
    String? shortDescription,
    String? category,
    String? subCategory,
    List<String>? tags,
    ServicePricing? pricing,
    List<ServiceImage>? images,
    List<String>? features,
    bool? featured,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Service(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      shortDescription: shortDescription ?? this.shortDescription,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      tags: tags ?? this.tags,
      pricing: pricing ?? this.pricing,
      images: images ?? this.images,
      features: features ?? this.features,
      featured: featured ?? this.featured,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@JsonSerializable()
class ServicePricing extends Equatable {
  final double basePrice;
  final String currency;
  final String? unit;
  final String? priceType;

  const ServicePricing({
    required this.basePrice,
    required this.currency,
    this.unit,
    this.priceType,
  });

  factory ServicePricing.fromJson(Map<String, dynamic> json) =>
      _$ServicePricingFromJson(json);

  Map<String, dynamic> toJson() => _$ServicePricingToJson(this);

  @override
  List<Object?> get props => [basePrice, currency, unit, priceType];
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

// Enum pour les catégories de services
enum ServiceCategory {
  @JsonValue('concierge')
  concierge,
  @JsonValue('luxury')
  luxury,
  @JsonValue('travel')
  travel,
  @JsonValue('lifestyle')
  lifestyle,
  @JsonValue('business')
  business,
  @JsonValue('security')
  security,
  @JsonValue('airTravel') // AJOUTÉ pour votre backend
  airTravel,
}

// Enum pour les statuts de services
enum ServiceStatus {
  @JsonValue('active')
  active,
  @JsonValue('inactive')
  inactive,
  @JsonValue('maintenance')
  maintenance,
}

// Extensions pour les enums
extension ServiceCategoryExtension on ServiceCategory {
  String get displayName {
    switch (this) {
      case ServiceCategory.concierge:
        return 'Conciergerie';
      case ServiceCategory.luxury:
        return 'Luxe';
      case ServiceCategory.travel:
        return 'Voyage';
      case ServiceCategory.lifestyle:
        return 'Lifestyle';
      case ServiceCategory.business:
        return 'Business';
      case ServiceCategory.security:
        return 'Sécurité';
      case ServiceCategory.airTravel:
        return 'Aviation Privée';
    }
  }

  String get value {
    switch (this) {
      case ServiceCategory.concierge:
        return 'concierge';
      case ServiceCategory.luxury:
        return 'luxury';
      case ServiceCategory.travel:
        return 'travel';
      case ServiceCategory.lifestyle:
        return 'lifestyle';
      case ServiceCategory.business:
        return 'business';
      case ServiceCategory.security:
        return 'security';
      case ServiceCategory.airTravel:
        return 'airTravel';
    }
  }
}

extension ServiceStatusExtension on ServiceStatus {
  String get displayName {
    switch (this) {
      case ServiceStatus.active:
        return 'Actif';
      case ServiceStatus.inactive:
        return 'Inactif';
      case ServiceStatus.maintenance:
        return 'Maintenance';
    }
  }

  String get value {
    switch (this) {
      case ServiceStatus.active:
        return 'active';
      case ServiceStatus.inactive:
        return 'inactive';
      case ServiceStatus.maintenance:
        return 'maintenance';
    }
  }
}