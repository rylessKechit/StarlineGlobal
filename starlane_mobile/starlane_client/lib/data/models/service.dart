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
      // CORRECTION - Fonction helper pour cast sécurisé en String
      String? safeStringCast(dynamic value) {
        if (value == null) return null;
        return value.toString();
      }
      
      String safeStringCastRequired(dynamic value, String fieldName) {
        if (value == null) {
          throw FormatException('Champ requis "$fieldName" est null dans: ${json.keys.toList()}');
        }
        return value.toString();
      }

      // CORRECTION - Validation avec cast sécurisé
      final String rawId = safeStringCastRequired(json['_id'] ?? json['id'], 'id');
      final String rawTitle = safeStringCastRequired(json['name'] ?? json['title'], 'name/title');

      // CORRECTION - Gestion robuste des dates avec fallback
      DateTime parseDateTime(dynamic dateValue) {
        if (dateValue == null) return DateTime.now();
        try {
          return DateTime.parse(dateValue.toString());
        } catch (e) {
          print('⚠️ Date invalide: $dateValue, utilisation de DateTime.now()');
          return DateTime.now();
        }
      }

      // CORRECTION - Parsing sécurisé des listes
      List<String>? parseStringList(dynamic listValue) {
        if (listValue == null) return null;
        if (listValue is! List) return null;
        try {
          return listValue.map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty).toList();
        } catch (e) {
          print('⚠️ Erreur parsing liste: $e');
          return null;
        }
      }

      // CORRECTION - Parsing sécurisé des images
      List<ServiceImage>? parseImageList(dynamic imageValue) {
        if (imageValue == null) return null;
        if (imageValue is! List) return null;
        try {
          return imageValue
              .map((img) {
                try {
                  return ServiceImage.fromJson(img as Map<String, dynamic>);
                } catch (e) {
                  print('⚠️ Image invalide ignorée: $e');
                  return null;
                }
              })
              .where((img) => img != null)
              .cast<ServiceImage>()
              .toList();
        } catch (e) {
          print('⚠️ Erreur parsing images: $e');
          return null;
        }
      }

      return Service(
        id: rawId,
        title: rawTitle,
        description: safeStringCast(json['description']) ?? '',
        shortDescription: safeStringCast(json['shortDescription']),
        category: safeStringCast(json['category']) ?? 'default',
        subCategory: safeStringCast(json['subCategory']),
        tags: parseStringList(json['tags']),
        pricing: json['pricing'] != null
            ? ServicePricing.fromJson(json['pricing'] as Map<String, dynamic>)
            : null,
        images: parseImageList(json['images']),
        features: parseStringList(json['features']) ?? parseStringList(json['included']),
        featured: json['isFeatured'] == true || json['featured'] == true,
        status: (json['isActive'] == true || json['status'] == 'active') ? 'active' : 'inactive',
        createdAt: parseDateTime(json['createdAt']),
        updatedAt: parseDateTime(json['updatedAt']),
      );
    } catch (e) {
      // AMÉLIORATION - Logging détaillé ET relancement de l'erreur
      print('🚨 ERREUR Service.fromJson: $e');
      print('📋 JSON reçu: $json');
      print('📋 Clés disponibles: ${json.keys.toList()}');
      
      // Relancer l'erreur pour que le repository puisse la gérer
      rethrow;
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

  // AJOUT - Méthodes utilitaires pour l'UI
  String get primaryImageUrl {
    if (images != null && images!.isNotEmpty) {
      // Chercher l'image primaire en premier
      final primaryImage = images!.firstWhere(
        (img) => img.isPrimary,
        orElse: () => images!.first,
      );
      return primaryImage.url;
    }
    return 'https://via.placeholder.com/400x200?text=Service+Image'; // Placeholder
  }

  String get formattedPrice {
    if (pricing == null) return 'Prix sur demande';
    
    final symbols = {'EUR': '€', 'USD': '\$', 'GBP': '£'};
    final symbol = symbols[pricing!.currency] ?? pricing!.currency;
    
    String suffix = '';
    switch (pricing!.priceType) {
      case 'per_hour':
        suffix = '/h';
        break;
      case 'per_day':
        suffix = '/jour';
        break;
      case 'fixed':
        suffix = '';
        break;
    }
    
    return '${pricing!.basePrice.toStringAsFixed(0)}$symbol$suffix';
  }

  bool get isActive => status == 'active';
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

  factory ServicePricing.fromJson(Map<String, dynamic> json) {
    try {
      return ServicePricing(
        basePrice: (json['basePrice'] as num?)?.toDouble() ?? 0.0,
        currency: json['currency']?.toString() ?? 'EUR',
        unit: json['unit']?.toString(),
        priceType: json['priceType']?.toString(),
      );
    } catch (e) {
      print('🚨 Erreur ServicePricing.fromJson: $e');
      print('📋 JSON: $json');
      // Retourner une valeur par défaut au lieu de crasher
      return const ServicePricing(
        basePrice: 0.0,
        currency: 'EUR',
      );
    }
  }

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

  factory ServiceImage.fromJson(Map<String, dynamic> json) {
    try {
      final String imageUrl = json['url']?.toString() ?? '';
      if (imageUrl.isEmpty) {
        throw FormatException('URL d\'image manquante');
      }
      
      return ServiceImage(
        url: imageUrl,
        alt: json['alt']?.toString(),
        isPrimary: json['isPrimary'] == true,
      );
    } catch (e) {
      print('🚨 Erreur ServiceImage.fromJson: $e');
      print('📋 JSON: $json');
      rethrow;
    }
  }

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
  @JsonValue('transport')
  transport,
  @JsonValue('realEstate')
  realEstate,
  @JsonValue('corporate')
  corporate,
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
      case ServiceCategory.transport:
        return 'Transport VIP';
      case ServiceCategory.realEstate:
        return 'Immobilier Premium';
      case ServiceCategory.corporate:
        return 'Corporate';
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
      case ServiceCategory.transport:
        return 'transport';
      case ServiceCategory.realEstate:
        return 'realEstate';
      case ServiceCategory.corporate:
        return 'corporate';
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