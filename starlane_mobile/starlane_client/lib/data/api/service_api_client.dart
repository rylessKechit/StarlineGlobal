// Path: starlane_mobile/starlane_client/lib/data/api/service_api_client.dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:json_annotation/json_annotation.dart';
import '../models/service.dart';
import 'api_client.dart';

part 'service_api_client.g.dart';

@RestApi()
abstract class ServiceApiClient {
  factory ServiceApiClient(Dio dio, {String? baseUrl}) = _ServiceApiClient;

  // ========== SERVICE ENDPOINTS ==========
  @GET('/services')
  Future<ApiResponse<List<Service>>> getServices({
    @Query('page') int page = 1,
    @Query('limit') int limit = 20,
    @Query('category') String? category,
    @Query('featured') bool? featured,
  });

  @GET('/services/featured')
  Future<ApiResponse<List<Service>>> getFeaturedServices();

  @GET('/services/{id}')
  Future<ApiResponse<Service>> getServiceById(@Path('id') String id);
}

// ========== REQUEST CLASSES ==========

@JsonSerializable()
class CreateServiceRequest {
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

  const CreateServiceRequest({
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
  });

  factory CreateServiceRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateServiceRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateServiceRequestToJson(this);
}

@JsonSerializable()
class UpdateServiceRequest {
  final String? title;
  final String? description;
  final String? shortDescription;
  final String? category;
  final String? subCategory;
  final List<String>? tags;
  final ServicePricing? pricing;
  final List<ServiceImage>? images;
  final List<String>? features;
  final bool? featured;
  final String? status;

  const UpdateServiceRequest({
    this.title,
    this.description,
    this.shortDescription,
    this.category,
    this.subCategory,
    this.tags,
    this.pricing,
    this.images,
    this.features,
    this.featured,
    this.status,
  });

  factory UpdateServiceRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateServiceRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateServiceRequestToJson(this);
}