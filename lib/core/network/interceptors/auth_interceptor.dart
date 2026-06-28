import 'package:dio/dio.dart';
import '../../storage/secure_storage_service.dart';
import '../../constants/app_constants.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorageService _secureStorage;

  AuthInterceptor(this._secureStorage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final apiKey = await _secureStorage.read(AppConstants.apiKeyKey);
    if (apiKey != null) {
      options.headers['x-api-key'] = apiKey;
      options.headers['anthropic-version'] = '2023-06-01';
    }
    handler.next(options);
  }
}
