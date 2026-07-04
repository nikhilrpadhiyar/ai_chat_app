import 'package:ai_chat_app/core/network/interceptors/auth_interceptor.dart';
import 'package:ai_chat_app/core/network/interceptors/error_interceptor.dart';
import 'package:ai_chat_app/core/network/interceptors/logging_interceptor.dart';
import 'package:ai_chat_app/core/storage/secure_storage_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  factory ApiClient() => _instance;
  ApiClient._internal();
  static final ApiClient _instance = ApiClient._internal();

  late final Dio _dio;

  static const String _baseUrl = 'https://api.anthropic.com/v1';
  static const Duration _timeout = Duration(seconds: 60);

  void init(SecureStorageService secureStorage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: _timeout,
        receiveTimeout: _timeout,
        headers: <String, dynamic>{
          'Content-Type': 'application/json',
          'anthropic-version': '2023-06-01',
        },
      ),
    );

    _dio.interceptors.addAll(<Interceptor>[
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
  }) => _dio.post<T>(
    path,
    data: data,
    queryParameters: queryParameters,
    options: options,
  );

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => _dio.get<T>(path, queryParameters: queryParameters, options: options);
}
