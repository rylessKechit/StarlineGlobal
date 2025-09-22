// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Activity _$ActivityFromJson(Map<String, dynamic> json) => Activity(
      id: json['_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: $enumDecode(_$ActivityCategoryEnumMap, json['category']),
      status: $enumDecode(_$ActivityStatusEnumMap, json['status']),
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'EUR',
      location: json['location'] as String,
      city: json['city'] as String,
      country: json['country'] as String,
      providerId: json['providerId'] as String,
      providerName: json['providerName'] as String,
      providerAvatar: json['providerAvatar'] as String?,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      videoUrl: json['videoUrl'] as String?,
      features: (json['features'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      included: (json['included'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      requirements: (json['requirements'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      maxGuests: (json['maxGuests'] as num?)?.toInt() ?? 1,
      duration: (json['duration'] as num?)?.toInt() ?? 60,
      instantBooking: json['instantBooking'] as bool? ?? false,
      availableDates: (json['availableDates'] as List<dynamic>?)
              ?.map((e) => DateTime.parse(e as String))
              .toList() ??
          const [],
      timeSlots: (json['timeSlots'] as List<dynamic>?)
              ?.map((e) => TimeSlot.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      totalBookings: (json['totalBookings'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: (json['reviewsCount'] as num?)?.toInt() ?? 0,
      lastBooking: json['lastBooking'] == null
          ? null
          : DateTime.parse(json['lastBooking'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ActivityToJson(Activity instance) => <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category': _$ActivityCategoryEnumMap[instance.category]!,
      'status': _$ActivityStatusEnumMap[instance.status]!,
      'price': instance.price,
      'currency': instance.currency,
      'location': instance.location,
      'city': instance.city,
      'country': instance.country,
      'providerId': instance.providerId,
      'providerName': instance.providerName,
      'providerAvatar': instance.providerAvatar,
      'images': instance.images,
      'videoUrl': instance.videoUrl,
      'features': instance.features,
      'included': instance.included,
      'requirements': instance.requirements,
      'maxGuests': instance.maxGuests,
      'duration': instance.duration,
      'instantBooking': instance.instantBooking,
      'availableDates':
          instance.availableDates.map((e) => e.toIso8601String()).toList(),
      'timeSlots': instance.timeSlots,
      'totalBookings': instance.totalBookings,
      'rating': instance.rating,
      'reviewsCount': instance.reviewsCount,
      'lastBooking': instance.lastBooking?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$ActivityCategoryEnumMap = {
  ActivityCategory.realEstate: 'real-estate',
  ActivityCategory.airTravel: 'air-travel',
  ActivityCategory.transport: 'transport',
  ActivityCategory.corporate: 'corporate',
  ActivityCategory.lifestyle: 'lifestyle',
  ActivityCategory.events: 'events',
  ActivityCategory.security: 'security',
};

const _$ActivityStatusEnumMap = {
  ActivityStatus.active: 'active',
  ActivityStatus.paused: 'paused',
  ActivityStatus.draft: 'draft',
  ActivityStatus.archived: 'archived',
};

TimeSlot _$TimeSlotFromJson(Map<String, dynamic> json) => TimeSlot(
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      isAvailable: json['isAvailable'] as bool? ?? true,
    );

Map<String, dynamic> _$TimeSlotToJson(TimeSlot instance) => <String, dynamic>{
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'isAvailable': instance.isAvailable,
    };

CreateActivityRequest _$CreateActivityRequestFromJson(
        Map<String, dynamic> json) =>
    CreateActivityRequest(
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'EUR',
      location: json['location'] as String,
      city: json['city'] as String,
      country: json['country'] as String,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      videoUrl: json['videoUrl'] as String?,
      features: (json['features'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      included: (json['included'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      requirements: (json['requirements'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      maxGuests: (json['maxGuests'] as num?)?.toInt() ?? 1,
      duration: (json['duration'] as num?)?.toInt() ?? 60,
      instantBooking: json['instantBooking'] as bool? ?? false,
      availableDates: (json['availableDates'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      timeSlots: (json['timeSlots'] as List<dynamic>?)
              ?.map((e) => TimeSlot.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$CreateActivityRequestToJson(
        CreateActivityRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'price': instance.price,
      'currency': instance.currency,
      'location': instance.location,
      'city': instance.city,
      'country': instance.country,
      'images': instance.images,
      'videoUrl': instance.videoUrl,
      'features': instance.features,
      'included': instance.included,
      'requirements': instance.requirements,
      'maxGuests': instance.maxGuests,
      'duration': instance.duration,
      'instantBooking': instance.instantBooking,
      'availableDates': instance.availableDates,
      'timeSlots': instance.timeSlots,
    };

UpdateActivityRequest _$UpdateActivityRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateActivityRequest(
      title: json['title'] as String?,
      description: json['description'] as String?,
      category: json['category'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      location: json['location'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      videoUrl: json['videoUrl'] as String?,
      features: (json['features'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      included: (json['included'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      requirements: (json['requirements'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      maxGuests: (json['maxGuests'] as num?)?.toInt(),
      duration: (json['duration'] as num?)?.toInt(),
      instantBooking: json['instantBooking'] as bool?,
      status: json['status'] as String?,
      availableDates: (json['availableDates'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      timeSlots: (json['timeSlots'] as List<dynamic>?)
          ?.map((e) => TimeSlot.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UpdateActivityRequestToJson(
        UpdateActivityRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'price': instance.price,
      'currency': instance.currency,
      'location': instance.location,
      'city': instance.city,
      'country': instance.country,
      'images': instance.images,
      'videoUrl': instance.videoUrl,
      'features': instance.features,
      'included': instance.included,
      'requirements': instance.requirements,
      'maxGuests': instance.maxGuests,
      'duration': instance.duration,
      'instantBooking': instance.instantBooking,
      'status': instance.status,
      'availableDates': instance.availableDates,
      'timeSlots': instance.timeSlots,
    };
