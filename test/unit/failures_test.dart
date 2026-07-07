import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_enterprise_starter/core/api/failures.dart';

void main() {
  group('mapDioException', () {
    Response<List> response(int statusCode) => Response<List>(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: statusCode,
          data: <String>['error'],
        );

    DioException exception(DioExceptionType type, {Response? response}) =>
        DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: type,
          response: response,
        );

    test('maps connectionTimeout to TimeoutFailure', () {
      final failure = mapDioException(exception(DioExceptionType.connectionTimeout));

      expect(failure, isA<TimeoutFailure>());
    });

    test('maps sendTimeout to TimeoutFailure', () {
      final failure = mapDioException(exception(DioExceptionType.sendTimeout));

      expect(failure, isA<TimeoutFailure>());
    });

    test('maps receiveTimeout to TimeoutFailure', () {
      final failure = mapDioException(exception(DioExceptionType.receiveTimeout));

      expect(failure, isA<TimeoutFailure>());
    });

    test('maps connectionError to NetworkFailure', () {
      final failure = mapDioException(exception(DioExceptionType.connectionError));

      expect(failure, isA<NetworkFailure>());
    });

    test('maps 401 badResponse to UnauthorizedFailure', () {
      final failure = mapDioException(
        exception(
          DioExceptionType.badResponse,
          response: response(401),
        ),
      );

      expect(failure, isA<UnauthorizedFailure>());
    });

    test('maps 403 badResponse to UnauthorizedFailure', () {
      final failure = mapDioException(
        exception(
          DioExceptionType.badResponse,
          response: response(403),
        ),
      );

      expect(failure, isA<UnauthorizedFailure>());
    });

    test('maps 404 badResponse to ClientFailure', () {
      final failure = mapDioException(
        exception(
          DioExceptionType.badResponse,
          response: response(404),
        ),
      );

      expect(failure, isA<ClientFailure>());
    });

    test('maps 500 badResponse to ServerFailure', () {
      final failure = mapDioException(
        exception(
          DioExceptionType.badResponse,
          response: response(500),
        ),
      );

      expect(failure, isA<ServerFailure>());
    });

    test('maps cancel to UnknownFailure', () {
      final failure = mapDioException(exception(DioExceptionType.cancel));

      expect(failure, isA<UnknownFailure>());
    });

    test('maps badCertificate to UnknownFailure', () {
      final failure = mapDioException(exception(DioExceptionType.badCertificate));

      expect(failure, isA<UnknownFailure>());
    });

    test('maps unknown to UnknownFailure', () {
      final failure = mapDioException(exception(DioExceptionType.unknown));

      expect(failure, isA<UnknownFailure>());
    });

    test('returns message from response data map', () {
      final failure = mapDioException(
        exception(
          DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 400,
            data: {'message': 'Bad request'},
          ),
        ),
      );

      expect(failure.message, 'Bad request');
    });

    test('returns status code message when response data is non-map', () {
      final failure = mapDioException(
        exception(
          DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 400,
            data: 'plain text',
          ),
        ),
      );

      expect(failure.message, 'Client error (400)');
    });
  });
}
