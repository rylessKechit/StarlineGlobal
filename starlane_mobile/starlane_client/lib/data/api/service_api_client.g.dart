// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_api_client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateServiceRequest _$CreateServiceRequestFromJson(
        Map<String, dynamic> json) =>
    CreateServiceRequest(
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
    );

Map<String, dynamic> _$CreateServiceRequestToJson(
        CreateServiceRequest instance) =>
    <String, dynamic>{
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
    };

UpdateServiceRequest _$UpdateServiceRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateServiceRequest(
      title: json['title'] as String?,
      description: json['description'] as String?,
      shortDescription: json['shortDescription'] as String?,
      category: json['category'] as String?,
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
      featured: json['featured'] as bool?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$UpdateServiceRequestToJson(
        UpdateServiceRequest instance) =>
    <String, dynamic>{
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
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element

class _ServiceApiClient implements ServiceApiClient {
  _ServiceApiClient(
    this._dio, {
    this.baseUrl,
    this.errorLogger,
  });

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<ApiResponse<List<Service>>> getServices({
    int page = 1,
    int limit = 20,
    String? category,
    bool? featured,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'page': page,
      r'limit': limit,
      r'category': category,
      r'featured': featured,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ApiResponse<List<Service>>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/services',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<List<Service>> _value;
    try {
      _value = ApiResponse<List<Service>>.fromJson(
        _result.data!,
        (json) => json is List<dynamic>
            ? json
                .map<Service>(
                    (i) => Service.fromJson(i as Map<String, dynamic>))
                .toList()
            : List.empty(),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<List<Service>>> getFeaturedServices() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ApiResponse<List<Service>>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/services/featured',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<List<Service>> _value;
    try {
      _value = ApiResponse<List<Service>>.fromJson(
        _result.data!,
        (json) => json is List<dynamic>
            ? json
                .map<Service>(
                    (i) => Service.fromJson(i as Map<String, dynamic>))
                .toList()
            : List.empty(),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<Service>> getServiceById(String id) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ApiResponse<Service>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/services/${id}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<Service> _value;
    try {
      _value = ApiResponse<Service>.fromJson(
        _result.data!,
        (json) => Service.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(
    String dioBaseUrl,
    String? baseUrl,
  ) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
