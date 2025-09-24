// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Activity _$ActivityFromJson(Map<String, dynamic> json) => Activity(
      id: json['_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      shortDescription: json['shortDescription'] as String?,
      category: json['category'] as String,
      subCategory: json['subCategory'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      provider: json['providerId'] == null
          ? null
          : ActivityProvider.fromJson(
              json['providerId'] as Map<String, dynamic>),
      providerName: json['providerName'] as String,
      companyName: json['companyName'] as String?,
      location:
          ActivityLocation.fromJson(json['location'] as Map<String, dynamic>),
      pricing:
          ActivityPricing.fromJson(json['pricing'] as Map<String, dynamic>),
      capacity: json['capacity'] == null
          ? null
          : ActivityCapacity.fromJson(json['capacity'] as Map<String, dynamic>),
      availability: json['availability'] == null
          ? null
          : ActivityAvailability.fromJson(
              json['availability'] as Map<String, dynamic>),
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => ActivityImage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      features: (json['features'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      featured: json['featured'] as bool? ?? false,
      priority: (json['priority'] as num?)?.toInt() ?? 0,
      status: json['status'] as String,
      stats: json['stats'] == null
          ? null
          : ActivityStats.fromJson(json['stats'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ActivityToJson(Activity instance) => <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'shortDescription': instance.shortDescription,
      'category': instance.category,
      'subCategory': instance.subCategory,
      'tags': instance.tags,
      'providerId': instance.provider,
      'providerName': instance.providerName,
      'companyName': instance.companyName,
      'location': instance.location,
      'pricing': instance.pricing,
      'capacity': instance.capacity,
      'availability': instance.availability,
      'images': instance.images,
      'features': instance.features,
      'featured': instance.featured,
      'priority': instance.priority,
      'status': instance.status,
      'stats': instance.stats,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

ActivityProvider _$ActivityProviderFromJson(Map<String, dynamic> json) =>
    ActivityProvider(
      id: json['_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      companyName: json['companyName'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ActivityProviderToJson(ActivityProvider instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'companyName': instance.companyName,
      'rating': instance.rating,
    };

ActivityLocation _$ActivityLocationFromJson(Map<String, dynamic> json) =>
    ActivityLocation(
      city: json['city'] as String,
      country: json['country'] as String,
      address: json['address'] as String?,
      coordinates: json['coordinates'] == null
          ? null
          : ActivityCoordinates.fromJson(
              json['coordinates'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ActivityLocationToJson(ActivityLocation instance) =>
    <String, dynamic>{
      'city': instance.city,
      'country': instance.country,
      'address': instance.address,
      'coordinates': instance.coordinates,
    };

ActivityCoordinates _$ActivityCoordinatesFromJson(Map<String, dynamic> json) =>
    ActivityCoordinates(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );

Map<String, dynamic> _$ActivityCoordinatesToJson(
        ActivityCoordinates instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
    };

ActivityPricing _$ActivityPricingFromJson(Map<String, dynamic> json) =>
    ActivityPricing(
      basePrice: (json['basePrice'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'EUR',
      priceType: json['priceType'] as String? ?? 'fixed',
    );

Map<String, dynamic> _$ActivityPricingToJson(ActivityPricing instance) =>
    <String, dynamic>{
      'basePrice': instance.basePrice,
      'currency': instance.currency,
      'priceType': instance.priceType,
    };

ActivityCapacity _$ActivityCapacityFromJson(Map<String, dynamic> json) =>
    ActivityCapacity(
      min: (json['min'] as num?)?.toInt(),
      max: (json['max'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ActivityCapacityToJson(ActivityCapacity instance) =>
    <String, dynamic>{
      'min': instance.min,
      'max': instance.max,
    };

ActivityAvailability _$ActivityAvailabilityFromJson(
        Map<String, dynamic> json) =>
    ActivityAvailability(
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$ActivityAvailabilityToJson(
        ActivityAvailability instance) =>
    <String, dynamic>{
      'isActive': instance.isActive,
    };

ActivityImage _$ActivityImageFromJson(Map<String, dynamic> json) =>
    ActivityImage(
      url: json['url'] as String,
      alt: json['alt'] as String?,
      isPrimary: json['isPrimary'] as bool? ?? false,
    );

Map<String, dynamic> _$ActivityImageToJson(ActivityImage instance) =>
    <String, dynamic>{
      'url': instance.url,
      'alt': instance.alt,
      'isPrimary': instance.isPrimary,
    };

ActivityStats _$ActivityStatsFromJson(Map<String, dynamic> json) =>
    ActivityStats(
      views: (json['views'] as num?)?.toInt() ?? 0,
      rating: json['rating'] == null
          ? null
          : ActivityRating.fromJson(json['rating'] as Map<String, dynamic>),
      bookings: json['bookings'] == null
          ? null
          : ActivityBookings.fromJson(json['bookings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ActivityStatsToJson(ActivityStats instance) =>
    <String, dynamic>{
      'views': instance.views,
      'rating': instance.rating,
      'bookings': instance.bookings,
    };

ActivityRating _$ActivityRatingFromJson(Map<String, dynamic> json) =>
    ActivityRating(
      average: (json['average'] as num).toDouble(),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$ActivityRatingToJson(ActivityRating instance) =>
    <String, dynamic>{
      'average': instance.average,
      'count': instance.count,
    };

ActivityBookings _$ActivityBookingsFromJson(Map<String, dynamic> json) =>
    ActivityBookings(
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$ActivityBookingsToJson(ActivityBookings instance) =>
    <String, dynamic>{
      'total': instance.total,
    };
