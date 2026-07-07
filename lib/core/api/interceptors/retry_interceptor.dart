import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

/// Retries failed requests with exponential backoff.
///
/// Only transient failures are retried: network errors, timeouts and a
/// configurable set of 5xx status codes. Auth (4xx) errors are intentionally
/// left to the [RefreshTokenInterceptor].
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required this.dio,
    this.logger,
    this.maxRetries = 3,
    this.retryableStatusCodes = const {500, 502, 503, 504},
    this.backoff = const Duration(milliseconds: 300),
  });

  final Dio dio;
  final Logger? logger;
  final int maxRetries;
  final Set<int> retryableStatusCodes;
  final Duration backoff;

  static const String _attemptKey = 'x_retry_attempt';

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    final attempt = (options.extra[_attemptKey] as int?) ?? 0;

    if (!_shouldRetry(err, attempt)) {
      return handler.next(err);
    }

    options.extra[_attemptKey] = attempt + 1;
    final delay = backoff * (attempt + 1);
    logger?.w(
      'Retrying ${options.uri} (attempt ${attempt + 1}/$maxRetries) '
      'after ${delay.inMilliseconds}ms',
    );

    await Future<void>.delayed(delay);
    try {
      final response = await dio.fetch(options);
      return handler.resolve(response);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }

  bool _shouldRetry(DioException err, int attempt) {
    if (attempt >= maxRetries) return false;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
      case DioExceptionType.connectionError:
        return true;
      case DioExceptionType.badResponse:
        final status = err.response?.statusCode;
        return status != null && retryableStatusCodes.contains(status);
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return false;
    }
  }
}
