abstract class AppException implements Exception {
  const AppException(this.message, {this.statusCode});
  final String message;
  final int? statusCode;
  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException([String message = 'No internet connection'])
    : super(message);
}

class ApiException extends AppException {
  const ApiException(String message, {int? statusCode})
    : super(message, statusCode: statusCode);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([String message = 'Invalid or missing API key'])
    : super(message, statusCode: 401);
}

class RateLimitException extends AppException {
  const RateLimitException([
    String message = 'Rate limit exceeded. Please wait.',
  ]) : super(message, statusCode: 429);
}

class CacheException extends AppException {
  const CacheException([String message = 'Local storage error'])
    : super(message);
}

class ValidationException extends AppException {
  const ValidationException(String message) : super(message);
}

class StreamException extends AppException {
  const StreamException([String message = 'Streaming response error'])
    : super(message);
}
