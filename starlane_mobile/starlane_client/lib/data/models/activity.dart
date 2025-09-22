import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'activity.g.dart';

@JsonSerializable()
class Activity extends Equatable {
  @JsonKey(name: '_id')
  final String id;
  final String title;
  final String description;
  final ActivityCategory category;
  final ActivityStatus status;
  final double price;
  final String currency;
  final String location;
  final String city;
  final String country;
  
  // Provider info
  final String providerId;
  final String providerName;
  final String? providerAvatar;
  
  // Media
  final List<String> images;
  final String? videoUrl;
  
  // Details
  final List<String> features;
  final List<String> included;
  final List<String> requirements;
  final int maxGuests;
  final int duration; // en minutes
  final bool instantBooking;
  
  // Availability
  final List<DateTime> availableDates;
  final List<TimeSlot> timeSlots;
  
  // Statistics
  final int totalBookings;
  final double rating;
  final int reviewsCount;
  final DateTime? lastBooking;
  
  // Metadata
  final DateTime createdAt;
  final DateTime updatedAt;

  const Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.price,
    this.currency = 'EUR',
    required this.location,
    required this.city,
    required this.country,
    required this.providerId,
    required this.providerName,
    this.providerAvatar,
    this.images = const [],
    this.videoUrl,
    this.features = const [],
    this.included = const [],
    this.requirements = const [],
    this.maxGuests = 1,
    this.duration = 60,
    this.instantBooking = false,
    this.availableDates = const [],
    this.timeSlots = const [],
    this.totalBookings = 0,
    this.rating = 0.0,
    this.reviewsCount = 0,
    this.lastBooking,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Activity.fromJson(Map<String, dynamic> json) => _$ActivityFromJson(json);
  Map<String, dynamic> toJson() => _$ActivityToJson(this);

  // Getters
  bool get hasImages => images.isNotEmpty;
  bool get hasVideo => videoUrl != null;
  bool get isActive => status == ActivityStatus.active;
  bool get isPaused => status == ActivityStatus.paused;
  bool get isDraft => status == ActivityStatus.draft;
  bool get hasRating => rating > 0;
  String get formattedPrice => '${price.toStringAsFixed(0)}$currency';
  String get fullLocation => '$location, $city, $country';
  String get durationFormatted => duration >= 60 
    ? '${(duration / 60).floor()}h${duration % 60 > 0 ? ' ${duration % 60}min' : ''}'
    : '${duration}min';

  @override
  List<Object?> get props => [
    id, title, description, category, status, price, currency,
    location, city, country, providerId, providerName, providerAvatar,
    images, videoUrl, features, included, requirements, maxGuests,
    duration, instantBooking, availableDates, timeSlots, totalBookings,
    rating, reviewsCount, lastBooking, createdAt, updatedAt
  ];
}

@JsonEnum()
enum ActivityCategory {
  @JsonValue('real-estate')
  realEstate,
  @JsonValue('air-travel')
  airTravel,
  @JsonValue('transport')
  transport,
  @JsonValue('corporate')
  corporate,
  @JsonValue('lifestyle')
  lifestyle,
  @JsonValue('events')
  events,
  @JsonValue('security')
  security;

  String get displayName {
    switch (this) {
      case ActivityCategory.realEstate:
        return 'Immobilier';
      case ActivityCategory.airTravel:
        return 'Aviation Privée';
      case ActivityCategory.transport:
        return 'Transport';
      case ActivityCategory.corporate:
        return 'Corporate';
      case ActivityCategory.lifestyle:
        return 'Lifestyle';
      case ActivityCategory.events:
        return 'Événements';
      case ActivityCategory.security:
        return 'Sécurité';
    }
  }

  String get description {
    switch (this) {
      case ActivityCategory.realEstate:
        return 'Propriétés exclusives';
      case ActivityCategory.airTravel:
        return 'Voyages en jet privé';
      case ActivityCategory.transport:
        return 'Transport de luxe';
      case ActivityCategory.corporate:
        return 'Services entreprise';
      case ActivityCategory.lifestyle:
        return 'Gestion de style de vie';
      case ActivityCategory.events:
        return 'Événements sur-mesure';
      case ActivityCategory.security:
        return 'Sécurité privée';
    }
  }

  String get iconName {
    switch (this) {
      case ActivityCategory.realEstate:
        return 'home';
      case ActivityCategory.airTravel:
        return 'flight';
      case ActivityCategory.transport:
        return 'car_rental';
      case ActivityCategory.corporate:
        return 'business_center';
      case ActivityCategory.lifestyle:
        return 'spa';
      case ActivityCategory.events:
        return 'celebration';
      case ActivityCategory.security:
        return 'security';
    }
  }
}

@JsonEnum()
enum ActivityStatus {
  @JsonValue('active')
  active,
  @JsonValue('paused')
  paused,
  @JsonValue('draft')
  draft,
  @JsonValue('archived')
  archived;

  String get displayName {
    switch (this) {
      case ActivityStatus.active:
        return 'Actif';
      case ActivityStatus.paused:
        return 'En pause';
      case ActivityStatus.draft:
        return 'Brouillon';
      case ActivityStatus.archived:
        return 'Archivé';
    }
  }
}

@JsonSerializable()
class TimeSlot extends Equatable {
  final String startTime; // Format HH:mm
  final String endTime;   // Format HH:mm
  final bool isAvailable;

  const TimeSlot({
    required this.startTime,
    required this.endTime,
    this.isAvailable = true,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) => _$TimeSlotFromJson(json);
  Map<String, dynamic> toJson() => _$TimeSlotToJson(this);

  String get displayTime => '$startTime - $endTime';

  @override
  List<Object> get props => [startTime, endTime, isAvailable];
}

// Request Models for Activities
@JsonSerializable()
class CreateActivityRequest extends Equatable {
  final String title;
  final String description;
  final String category;
  final double price;
  final String currency;
  final String location;
  final String city;
  final String country;
  final List<String> images;
  final String? videoUrl;
  final List<String> features;
  final List<String> included;
  final List<String> requirements;
  final int maxGuests;
  final int duration;
  final bool instantBooking;
  final List<String> availableDates;
  final List<TimeSlot> timeSlots;

  const CreateActivityRequest({
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    this.currency = 'EUR',
    required this.location,
    required this.city,
    required this.country,
    this.images = const [],
    this.videoUrl,
    this.features = const [],
    this.included = const [],
    this.requirements = const [],
    this.maxGuests = 1,
    this.duration = 60,
    this.instantBooking = false,
    this.availableDates = const [],
    this.timeSlots = const [],
  });

  factory CreateActivityRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateActivityRequestFromJson(json);
  
  Map<String, dynamic> toJson() => _$CreateActivityRequestToJson(this);

  @override
  List<Object?> get props => [
    title, description, category, price, currency, location, city, country,
    images, videoUrl, features, included, requirements, maxGuests, duration,
    instantBooking, availableDates, timeSlots
  ];
}

@JsonSerializable()
class UpdateActivityRequest extends Equatable {
  final String? title;
  final String? description;
  final String? category;
  final double? price;
  final String? currency;
  final String? location;
  final String? city;
  final String? country;
  final List<String>? images;
  final String? videoUrl;
  final List<String>? features;
  final List<String>? included;
  final List<String>? requirements;
  final int? maxGuests;
  final int? duration;
  final bool? instantBooking;
  final String? status;
  final List<String>? availableDates;
  final List<TimeSlot>? timeSlots;

  const UpdateActivityRequest({
    this.title,
    this.description,
    this.category,
    this.price,
    this.currency,
    this.location,
    this.city,
    this.country,
    this.images,
    this.videoUrl,
    this.features,
    this.included,
    this.requirements,
    this.maxGuests,
    this.duration,
    this.instantBooking,
    this.status,
    this.availableDates,
    this.timeSlots,
  });

  factory UpdateActivityRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateActivityRequestFromJson(json);
  
  Map<String, dynamic> toJson() => _$UpdateActivityRequestToJson(this);

  @override
  List<Object?> get props => [
    title, description, category, price, currency, location, city, country,
    images, videoUrl, features, included, requirements, maxGuests, duration,
    instantBooking, status, availableDates, timeSlots
  ];
}