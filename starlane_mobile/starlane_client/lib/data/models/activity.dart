// lib/data/models/activity.dart
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'activity.g.dart';

@JsonSerializable()
class Activity extends Equatable {
  @JsonKey(name: '_id')
  final String id;
  final String title;
  final String description;
  final String? shortDescription;
  
  final String category;
  final String? subCategory;
  final List<String> tags;
  
  @JsonKey(name: 'providerId')
  final ActivityProvider? provider;
  
  final String providerName;
  final String? companyName;
  
  final ActivityLocation location;
  final ActivityPricing pricing;
  final ActivityCapacity? capacity;
  final ActivityAvailability? availability;
  
  final List<ActivityImage> images;
  final List<String> features;
  final bool featured;
  final int priority;
  
  final String status;
  final ActivityStats? stats;
  
  final DateTime createdAt;
  final DateTime updatedAt;

  const Activity({
    required this.id,
    required this.title,
    required this.description,
    this.shortDescription,
    required this.category,
    this.subCategory,
    this.tags = const [],
    this.provider,
    required this.providerName,
    this.companyName,
    required this.location,
    required this.pricing,
    this.capacity,
    this.availability,
    this.images = const [],
    this.features = const [],
    this.featured = false,
    this.priority = 0,
    required this.status,
    this.stats,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    try {
      final now = DateTime.now();
      
      return Activity(
        id: json['_id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        shortDescription: json['shortDescription'] as String?,
        category: json['category'] as String,
        subCategory: json['subCategory'] as String?,
        tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        provider: json['providerId'] != null && json['providerId'] is Map<String, dynamic>
            ? ActivityProvider.fromJson(json['providerId'] as Map<String, dynamic>)
            : null,
        providerName: json['providerName'] as String,
        companyName: json['companyName'] as String?,
        location: ActivityLocation.fromJson(json['location'] as Map<String, dynamic>),
        pricing: ActivityPricing.fromJson(json['pricing'] as Map<String, dynamic>),
        capacity: json['capacity'] != null
            ? ActivityCapacity.fromJson(json['capacity'] as Map<String, dynamic>)
            : null,
        availability: json['availability'] != null
            ? ActivityAvailability.fromJson(json['availability'] as Map<String, dynamic>)
            : null,
        images: (json['images'] as List<dynamic>?)
            ?.map((e) => ActivityImage.fromJson(e as Map<String, dynamic>))
            .toList() ?? const [],
        features: (json['features'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        featured: json['featured'] as bool? ?? false,
        priority: (json['priority'] as num?)?.toInt() ?? 0,
        status: json['status'] as String? ?? 'active',
        stats: json['stats'] != null
            ? ActivityStats.fromJson(json['stats'] as Map<String, dynamic>)
            : null,
        createdAt: json['createdAt'] != null 
            ? DateTime.parse(json['createdAt'] as String)
            : now,
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'] as String)
            : now,
      );
    } catch (e, stackTrace) {
      print('❌ Erreur dans Activity.fromJson:');
      print('JSON reçu: $json');
      print('Erreur: $e');
      print('StackTrace: $stackTrace');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => _$ActivityToJson(this);

  // Getters utiles
  String get city => location.city;
  String get country => location.country;
  double get price => pricing.basePrice;
  String get currency => pricing.currency;
  int get duration => 60; 
  double get rating => stats?.rating?.average ?? 0.0;
  int get reviewsCount => stats?.rating?.count ?? 0;
  
  String? get firstImageUrl => images.isNotEmpty ? images.first.url : null;
  
  String? get primaryImageUrl {
    if (images.isEmpty) return null;
    
    try {
      final primaryImage = images.where((img) => img.isPrimary).firstOrNull;
      if (primaryImage != null) return primaryImage.url;
    } catch (e) {
      // Ignore error and fallback
    }
    
    return images.first.url;
  }

  @override
  List<Object?> get props => [
    id, title, description, shortDescription, category, subCategory,
    tags, provider, providerName, companyName, location, pricing,
    capacity, availability, images, features, featured, priority,
    status, stats, createdAt, updatedAt
  ];
}

@JsonSerializable()
class ActivityProvider extends Equatable {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String email;
  final String? companyName;
  final double? rating;

  const ActivityProvider({
    required this.id,
    required this.name,
    required this.email,
    this.companyName,
    this.rating,
  });

  factory ActivityProvider.fromJson(Map<String, dynamic> json) => _$ActivityProviderFromJson(json);
  Map<String, dynamic> toJson() => _$ActivityProviderToJson(this);

  @override
  List<Object?> get props => [id, name, email, companyName, rating];
}

@JsonSerializable()
class ActivityLocation extends Equatable {
  final String city;
  final String country;
  final String? address;
  final ActivityCoordinates? coordinates;

  const ActivityLocation({
    required this.city,
    required this.country,
    this.address,
    this.coordinates,
  });

  factory ActivityLocation.fromJson(Map<String, dynamic> json) => _$ActivityLocationFromJson(json);
  Map<String, dynamic> toJson() => _$ActivityLocationToJson(this);

  @override
  List<Object?> get props => [city, country, address, coordinates];
}

@JsonSerializable()
class ActivityCoordinates extends Equatable {
  final double lat;
  final double lng;

  const ActivityCoordinates({
    required this.lat,
    required this.lng,
  });

  factory ActivityCoordinates.fromJson(Map<String, dynamic> json) => _$ActivityCoordinatesFromJson(json);
  Map<String, dynamic> toJson() => _$ActivityCoordinatesToJson(this);

  @override
  List<Object?> get props => [lat, lng];
}

@JsonSerializable()
class ActivityPricing extends Equatable {
  final double basePrice;
  final String currency;
  final String priceType;

  const ActivityPricing({
    required this.basePrice,
    this.currency = 'EUR',
    this.priceType = 'fixed',
  });

  factory ActivityPricing.fromJson(Map<String, dynamic> json) {
    return ActivityPricing(
      basePrice: (json['basePrice'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'EUR',
      priceType: json['priceType'] as String? ?? 'fixed',
    );
  }

  Map<String, dynamic> toJson() => _$ActivityPricingToJson(this);

  @override
  List<Object?> get props => [basePrice, currency, priceType];
}

@JsonSerializable()
class ActivityCapacity extends Equatable {
  final int? min;
  final int? max;

  const ActivityCapacity({
    this.min,
    this.max,
  });

  factory ActivityCapacity.fromJson(Map<String, dynamic> json) => _$ActivityCapacityFromJson(json);
  Map<String, dynamic> toJson() => _$ActivityCapacityToJson(this);

  @override
  List<Object?> get props => [min, max];
}

@JsonSerializable()
class ActivityAvailability extends Equatable {
  final bool isActive;

  const ActivityAvailability({
    required this.isActive,
  });

  factory ActivityAvailability.fromJson(Map<String, dynamic> json) {
    return ActivityAvailability(
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => _$ActivityAvailabilityToJson(this);

  @override
  List<Object?> get props => [isActive];
}

@JsonSerializable()
class ActivityImage extends Equatable {
  final String url;
  final String? alt;
  final bool isPrimary;

  const ActivityImage({
    required this.url,
    this.alt,
    this.isPrimary = false,
  });

  factory ActivityImage.fromJson(Map<String, dynamic> json) => _$ActivityImageFromJson(json);
  Map<String, dynamic> toJson() => _$ActivityImageToJson(this);

  @override
  List<Object?> get props => [url, alt, isPrimary];
}

@JsonSerializable()
class ActivityStats extends Equatable {
  final int views;
  final ActivityRating? rating;
  final ActivityBookings? bookings;

  const ActivityStats({
    this.views = 0,
    this.rating,
    this.bookings,
  });

  factory ActivityStats.fromJson(Map<String, dynamic> json) => _$ActivityStatsFromJson(json);
  Map<String, dynamic> toJson() => _$ActivityStatsToJson(this);

  @override
  List<Object?> get props => [views, rating, bookings];
}

@JsonSerializable()
class ActivityRating extends Equatable {
  final double average;
  final int count;

  const ActivityRating({
    required this.average,
    required this.count,
  });

  factory ActivityRating.fromJson(Map<String, dynamic> json) => _$ActivityRatingFromJson(json);
  Map<String, dynamic> toJson() => _$ActivityRatingToJson(this);

  @override
  List<Object?> get props => [average, count];
}

@JsonSerializable()
class ActivityBookings extends Equatable {
  final int total;

  const ActivityBookings({
    required this.total,
  });

  factory ActivityBookings.fromJson(Map<String, dynamic> json) => _$ActivityBookingsFromJson(json);
  Map<String, dynamic> toJson() => _$ActivityBookingsToJson(this);

  @override
  List<Object?> get props => [total];
}

enum ActivityCategory {
  realEstate('realEstate', 'Immobilier'),
  airTravel('airTravel', 'Aviation Privée'),
  transport('transport', 'Transport'),
  corporate('corporate', 'Corporate'),
  lifestyle('lifestyle', 'Lifestyle'),
  events('events', 'Événements'),
  security('security', 'Sécurité');

  const ActivityCategory(this.value, this.displayName);
  final String value;
  final String displayName;

  static ActivityCategory fromString(String value) {
    return ActivityCategory.values.firstWhere(
      (category) => category.value == value,
      orElse: () => ActivityCategory.lifestyle,
    );
  }
}