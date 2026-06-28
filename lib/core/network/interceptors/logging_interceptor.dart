import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class LoggingInterceptor extends Interceptor {
  final _log = Logger(printer: PrettyPrinter(methodCount: 0));

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _log.d('[REQ] ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _log.i('[RES] ${response.statusCode} ${response.requestOptions.uri}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _log.e('[ERR] ${err.message}', error: err.error);
    handler.next(err);
  }
}
