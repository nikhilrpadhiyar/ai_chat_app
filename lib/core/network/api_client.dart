import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../storage/secure_storage_service.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  late final Dio _dio;

  static const String _baseUrl = 'https://api.anthropic.com/v1';
  static const Duration _timeout = Duration(seconds: 60);

  void init(SecureStorageService secureStorage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: _timeout,
        receiveTimeout: _timeout,
        headers: {
          'Content-Type': 'application/json',
          'anthropic-version': '2023-06-01',
        },
      ),
    );

    _dio.interceptors.addAll([
      AuthInterceptor(secureStorage),
      ErrorInterceptor(),
      if (kDebugMode) LoggingInterceptor(),
    ]);
  }

  Dio get dio => _dio;

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _dio.post<T>(path, data: data, queryParameters: queryParameters, options: options);

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _dio.get<T>(path, queryParameters: queryParameters, options: options);
}
