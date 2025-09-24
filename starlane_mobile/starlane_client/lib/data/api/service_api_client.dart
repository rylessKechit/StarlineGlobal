// Path: starlane_mobile/starlane_client/lib/data/api/service_api_client.dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:json_annotation/json_annotation.dart';
import '../models/service.dart';
import 'api_client.dart';

part 'service_api_client.g.dart';

@RestApi()
abstract class ServiceApiClient {
  factory ServiceApiClient(Dio dio) = _ServiceApiClient;

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

  @POST('/services')
  Future<ApiResponse<Service>> createService(
    @Body() CreateServiceRequest request,
  );

  @PUT('/services/{id}')
  Future<ApiResponse<Service>> updateService(
    @Path('id') String id,
    @Body() UpdateServiceRequest request,
  );

  @DELETE('/services/{id}')
  Future<ApiResponse<String>> deleteService(@Path('id') String id);
}