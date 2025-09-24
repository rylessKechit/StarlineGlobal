// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Service _$ServiceFromJson(Map<String, dynamic> json) => Service(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      shortDescription: json['shortDescription'] as String?,
      category: json['category'] as String,
      subCategory: json['subCategory'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      pricing: json['pricing'] == null
          ? null
          : ServicePricing.fromJson(json['pricing'] as Map<String, dynamic>),
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => ServiceImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      features: (json['features'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      featured: json['featured'] as bool? ?? false,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ServiceToJson(Service instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'shortDescription': instance.shortDescription,
      'category': instance.category,
      'subCategory': instance.subCategory,
      'tags': instance.tags,
      'pricing': instance.pricing,
      'images': instance.images,
      'features': instance.features,
      'featured': instance.featured,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

ServicePricing _$ServicePricingFromJson(Map<String, dynamic> json) =>
    ServicePricing(
      basePrice: (json['basePrice'] as num).toDouble(),
      currency: json['currency'] as String,
      unit: json['unit'] as String?,
      priceType: json['priceType'] as String?,
    );

Map<String, dynamic> _$ServicePricingToJson(ServicePricing instance) =>
    <String, dynamic>{
      'basePrice': instance.basePrice,
      'currency': instance.currency,
      'unit': instance.unit,
      'priceType': instance.priceType,
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
