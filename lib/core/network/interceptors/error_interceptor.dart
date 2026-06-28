import 'package:dio/dio.dart';
import '../../error/exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppException mapped;

    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.unknown) {
      mapped = const NetworkException();
    } else if (err.response != null) {
      final status = err.response!.statusCode ?? 0;
      if (status == 401) {
        mapped = const UnauthorizedException();
      } else if (status == 429) {
        mapped = const RateLimitException();
      } else {
        final msg = _extractMessage(err.response);
        mapped = ApiException(msg, statusCode: status);
      }
    } else if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      mapped = const NetworkException('Request timed out');
    } else {
      mapped = ApiException(err.message ?? 'Unexpected error');
    }

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: mapped,
        message: mapped.message,
        response: err.response,
        type: err.type,
      ),
    );
  }

  String _extractMessage(Response? response) {
    try {
      final data = response?.data;
      if (data is Map) {
        return data['error']?['message']?.toString() ??
            data['message']?.toString() ??
            'Server error ${response?.statusCode}';
      }
    } catch (_) {}
    return 'Server error ${response?.statusCode}';
  }
}
