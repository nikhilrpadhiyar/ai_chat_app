import 'package:ai_chat_app/core/constants/app_constants.dart';
import 'package:ai_chat_app/core/storage/secure_storage_service.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._secureStorage);
  final SecureStorageService _secureStorage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final String? apiKey = await _secureStorage.read(AppConstants.apiKeyKey);
    if (apiKey != null) {
      options.headers['x-api-key'] = apiKey;
      options.headers['anthropic-version'] = '2023-06-01';
    }
    handler.next(options);
  }
}
