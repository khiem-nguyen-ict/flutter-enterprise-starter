import 'package:dio/dio.dart';

/// Failures returned by the network layer.
///
/// The presentation layer catches these instead of dealing with raw
/// [DioException]s, keeping it free of networking specifics.
sealed class ApiFailure implements Exception {
  const ApiFailure(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() => 'ApiFailure($message)';
}

/// No network connectivity or host unreachable.
class NetworkFailure extends ApiFailure {
  const NetworkFailure(super.message, [super.cause]);
}

/// Request timed out before completing.
class TimeoutFailure extends ApiFailure {
  const TimeoutFailure(super.message, [super.cause]);
}

/// 401/403 — missing or invalid credentials.
class UnauthorizedFailure extends ApiFailure {
  const UnauthorizedFailure(super.message, [super.cause]);
}

/// 4xx client error (other than auth).
class ClientFailure extends ApiFailure {
  const ClientFailure(super.message, [super.cause]);

  factory ClientFailure.fromResponse(int statusCode, [String? message]) =>
      ClientFailure(message ?? 'Client error ($statusCode)');
}

/// 5xx server error.
class ServerFailure extends ApiFailure {
  const ServerFailure(super.message, [super.cause]);

  factory ServerFailure.fromResponse(int statusCode, [String? message]) =>
      ServerFailure(message ?? 'Server error ($statusCode)');
}

/// Anything else that does not fit the categories above.
class UnknownFailure extends ApiFailure {
  const UnknownFailure(super.message, [super.cause]);
}

/// Converts a [DioException] into a domain-friendly [ApiFailure].
ApiFailure mapDioException(DioException error) {
  final response = error.response;
  final statusCode = response?.statusCode;

  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return TimeoutFailure(_getMessage(error), error);

    case DioExceptionType.connectionError:
      return NetworkFailure(
        'No internet connection. Please check your network.',
        error,
      );

    case DioExceptionType.badResponse:
      if (statusCode == null) {
        return UnknownFailure(_getMessage(error), error);
      }
      if (statusCode == 401 || statusCode == 403) {
        return UnauthorizedFailure(
          _extractMessage(response) ?? 'Session expired. Please sign in again.',
          error,
        );
      }
      if (statusCode >= 400 && statusCode < 500) {
        return ClientFailure.fromResponse(
          statusCode,
          _extractMessage(response),
        );
      }
      if (statusCode >= 500) {
        return ServerFailure.fromResponse(
          statusCode,
          _extractMessage(response),
        );
      }
      return UnknownFailure(_getMessage(error), error);

    case DioExceptionType.cancel:
      return UnknownFailure('Request was cancelled.', error);

    case DioExceptionType.badCertificate:
      return UnknownFailure('Invalid SSL certificate.', error);

    case DioExceptionType.unknown:
    default:
      return UnknownFailure(_getMessage(error), error);
  }
}

String _getMessage(DioException error) {
  return error.message ?? error.error?.toString() ?? 'Unexpected network error.';
}

String? _extractMessage(Response? response) {
  final data = response?.data;
  if (data is Map<String, dynamic>) {
    final candidate = data['message'] ?? data['error'] ?? data['detail'];
    if (candidate is String) return candidate;
  }
  return null;
}
