// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Service _$ServiceFromJson(Map<String, dynamic> json) => Service(
      id: json['_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      shortDescription: json['shortDescription'] as String?,
      category: $enumDecode(_$ServiceCategoryEnumMap, json['category']),
      serviceType: json['serviceType'] as String,
      pricing: ServicePricing.fromJson(json['pricing'] as Map<String, dynamic>),
      icon: json['icon'] as String,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => ServiceImage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      features: (json['features'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      included: (json['included'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isActive: json['isActive'] as bool? ?? true,
      isFeatured: json['isFeatured'] as bool? ?? false,
      priority: (json['priority'] as num?)?.toInt() ?? 0,
      serviceDetails: json['serviceDetails'] == null
          ? null
          : ServiceDetails.fromJson(
              json['serviceDetails'] as Map<String, dynamic>),
      stats: ServiceStats.fromJson(json['stats'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ServiceToJson(Service instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'shortDescription': instance.shortDescription,
      'category': _$ServiceCategoryEnumMap[instance.category]!,
      'serviceType': instance.serviceType,
      'pricing': instance.pricing,
      'icon': instance.icon,
      'images': instance.images,
      'features': instance.features,
      'included': instance.included,
      'isActive': instance.isActive,
      'isFeatured': instance.isFeatured,
      'priority': instance.priority,
      'serviceDetails': instance.serviceDetails,
      'stats': instance.stats,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$ServiceCategoryEnumMap = {
  ServiceCategory.airTravel: 'airTravel',
  ServiceCategory.transport: 'transport',
  ServiceCategory.realEstate: 'realEstate',
  ServiceCategory.corporate: 'corporate',
};

ServicePricing _$ServicePricingFromJson(Map<String, dynamic> json) =>
    ServicePricing(
      basePrice: (json['basePrice'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'EUR',
      priceType: $enumDecodeNullable(_$PriceTypeEnumMap, json['priceType']) ??
          PriceType.fixed,
      isCustomQuote: json['isCustomQuote'] as bool? ?? false,
    );

Map<String, dynamic> _$ServicePricingToJson(ServicePricing instance) =>
    <String, dynamic>{
      'basePrice': instance.basePrice,
      'currency': instance.currency,
      'priceType': _$PriceTypeEnumMap[instance.priceType]!,
      'isCustomQuote': instance.isCustomQuote,
    };

const _$PriceTypeEnumMap = {
  PriceType.fixed: 'fixed',
  PriceType.perHour: 'per_hour',
  PriceType.perDay: 'per_day',
  PriceType.custom: 'custom',
};

ServiceImage _$ServiceImageFromJson(Map<String, dynamic> json) => ServiceImage(
      url: json['url'] as String,
      alt: json['alt'] as String?,
      isPrimary: json['isPrimary'] as bool? ?? false,
    );

Map<String, dynamic> _$ServiceImageToJson(ServiceImage instance) =>
    <String, dynamic>{
      'url': instance.url,
      'alt': instance.alt,
      'isPrimary': instance.isPrimary,
    };

ServiceDetails _$ServiceDetailsFromJson(Map<String, dynamic> json) =>
    ServiceDetails(
      airTravelType: json['airTravelType'] as String?,
      transportType: json['transportType'] as String?,
      realEstateType: json['realEstateType'] as String?,
      corporateType: json['corporateType'] as String?,
    );

Map<String, dynamic> _$ServiceDetailsToJson(ServiceDetails instance) =>
    <String, dynamic>{
      'airTravelType': instance.airTravelType,
      'transportType': instance.transportType,
      'realEstateType': instance.realEstateType,
      'corporateType': instance.corporateType,
    };

ServiceStats _$ServiceStatsFromJson(Map<String, dynamic> json) => ServiceStats(
      orders: (json['orders'] as num?)?.toInt() ?? 0,
      revenue: (json['revenue'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$ServiceStatsToJson(ServiceStats instance) =>
    <String, dynamic>{
      'orders': instance.orders,
      'revenue': instance.revenue,
    };

CreateServiceRequest _$CreateServiceRequestFromJson(
        Map<String, dynamic> json) =>
    CreateServiceRequest(
      name: json['name'] as String,
      description: json['description'] as String,
      shortDescription: json['shortDescription'] as String?,
      category: $enumDecode(_$ServiceCategoryEnumMap, json['category']),
      serviceType: json['serviceType'] as String,
      pricing: ServicePricing.fromJson(json['pricing'] as Map<String, dynamic>),
      icon: json['icon'] as String,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => ServiceImage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      features: (json['features'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      included: (json['included'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isFeatured: json['isFeatured'] as bool? ?? false,
      priority: (json['priority'] as num?)?.toInt() ?? 0,
      serviceDetails: json['serviceDetails'] == null
          ? null
          : ServiceDetails.fromJson(
              json['serviceDetails'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateServiceRequestToJson(
        CreateServiceRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'shortDescription': instance.shortDescription,
      'category': _$ServiceCategoryEnumMap[instance.category]!,
      'serviceType': instance.serviceType,
      'pricing': instance.pricing,
      'icon': instance.icon,
      'images': instance.images,
      'features': instance.features,
      'included': instance.included,
      'isFeatured': instance.isFeatured,
      'priority': instance.priority,
      'serviceDetails': instance.serviceDetails,
    };

UpdateServiceRequest _$UpdateServiceRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateServiceRequest(
      name: json['name'] as String?,
      description: json['description'] as String?,
      shortDescription: json['shortDescription'] as String?,
      category: $enumDecodeNullable(_$ServiceCategoryEnumMap, json['category']),
      serviceType: json['serviceType'] as String?,
      pricing: json['pricing'] == null
          ? null
          : ServicePricing.fromJson(json['pricing'] as Map<String, dynamic>),
      icon: json['icon'] as String?,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => ServiceImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      features: (json['features'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      included: (json['included'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isFeatured: json['isFeatured'] as bool?,
      priority: (json['priority'] as num?)?.toInt(),
      serviceDetails: json['serviceDetails'] == null
          ? null
          : ServiceDetails.fromJson(
              json['serviceDetails'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateServiceRequestToJson(
        UpdateServiceRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'shortDescription': instance.shortDescription,
      'category': _$ServiceCategoryEnumMap[instance.category],
      'serviceType': instance.serviceType,
      'pricing': instance.pricing,
      'icon': instance.icon,
      'images': instance.images,
      'features': instance.features,
      'included': instance.included,
      'isFeatured': instance.isFeatured,
      'priority': instance.priority,
      'serviceDetails': instance.serviceDetails,
    };
