import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);
  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'No internet connection']) : super(message);
}

class ApiFailure extends Failure {
  final int? statusCode;
  const ApiFailure(String message, {this.statusCode}) : super(message);
  @override
  List<Object?> get props => [message, statusCode];
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([String message = 'Invalid or missing API key'])
      : super(message);
}

class RateLimitFailure extends Failure {
  const RateLimitFailure([String message = 'Rate limit exceeded. Please wait.'])
      : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Local storage error']) : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}

class StreamFailure extends Failure {
  const StreamFailure([String message = 'Streaming response error']) : super(message);
}
