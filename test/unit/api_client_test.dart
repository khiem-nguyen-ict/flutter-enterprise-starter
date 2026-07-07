import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_enterprise_starter/core/api/api_client_helper.dart';
import 'package:flutter_enterprise_starter/core/api/failures.dart';

class MockDio extends Mock implements Dio {}

void main() {
  group('ApiClient', () {
    late MockDio mockDio;
    late ApiClient apiClient;

    setUp(() {
      mockDio = MockDio();
      apiClient = ApiClient(mockDio);
    });

    test('get returns data on success', () async {
      when(() => mockDio.get<List>(
            any(),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          )).thenAnswer(
        (_) async => Response<List>(
          requestOptions: RequestOptions(path: '/test'),
          data: ['item1'],
        ),
      );

      final result = await apiClient.get<List>('/test');

      expect(result, ['item1']);
    });

    test('post returns data on success', () async {
      when(() => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          )).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: '/test'),
          data: {'id': 1},
        ),
      );

      final result = await apiClient.post<Map<String, dynamic>>('/test', data: {'key': 'value'});

      expect(result, {'id': 1});
    });

    test('put returns data on success', () async {
      when(() => mockDio.put<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          )).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: '/test'),
          data: {'updated': true},
        ),
      );

      final result = await apiClient.put<Map<String, dynamic>>('/test', data: {'key': 'value'});

      expect(result, {'updated': true});
    });

    test('patch returns data on success', () async {
      when(() => mockDio.patch<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          )).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: '/test'),
          data: {'patched': true},
        ),
      );

      final result = await apiClient.patch<Map<String, dynamic>>('/test', data: {'key': 'value'});

      expect(result, {'patched': true});
    });

    test('delete returns data on success', () async {
      when(() => mockDio.delete<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          )).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: '/test'),
          data: {'deleted': true},
        ),
      );

      final result = await apiClient.delete<Map<String, dynamic>>('/test');

      expect(result, {'deleted': true});
    });

    group('_run maps DioException to ApiFailure', () {
      test('connection timeout maps to TimeoutFailure', () async {
        when(() => mockDio.get<List>(
              any(),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
            )).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.connectionTimeout,
          ),
        );

        await expectLater(apiClient.get<List>('/test'), throwsA(isA<TimeoutFailure>()));
      });

      test('bad response 401 maps to UnauthorizedFailure', () async {
        when(() => mockDio.get<List>(
              any(),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
            )).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.badResponse,
            response: Response<List>(
              requestOptions: RequestOptions(path: '/test'),
              statusCode: 401,
            ),
          ),
        );

        await expectLater(apiClient.get<List>('/test'), throwsA(isA<UnauthorizedFailure>()));
      });

      test('bad response 403 maps to UnauthorizedFailure', () async {
        when(() => mockDio.get<List>(
              any(),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
            )).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.badResponse,
            response: Response<List>(
              requestOptions: RequestOptions(path: '/test'),
              statusCode: 403,
            ),
          ),
        );

        await expectLater(apiClient.get<List>('/test'), throwsA(isA<UnauthorizedFailure>()));
      });

      test('bad response 404 maps to ClientFailure', () async {
        when(() => mockDio.get<List>(
              any(),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
            )).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.badResponse,
            response: Response<List>(
              requestOptions: RequestOptions(path: '/test'),
              statusCode: 404,
            ),
          ),
        );

        await expectLater(apiClient.get<List>('/test'), throwsA(isA<ClientFailure>()));
      });

      test('bad response 500 maps to ServerFailure', () async {
        when(() => mockDio.get<List>(
              any(),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
            )).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.badResponse,
            response: Response<List>(
              requestOptions: RequestOptions(path: '/test'),
              statusCode: 500,
            ),
          ),
        );

        await expectLater(apiClient.get<List>('/test'), throwsA(isA<ServerFailure>()));
      });

      test('connection error maps to NetworkFailure', () async {
        when(() => mockDio.get<List>(
              any(),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
            )).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.connectionError,
          ),
        );

        await expectLater(apiClient.get<List>('/test'), throwsA(isA<NetworkFailure>()));
      });
    });
  });
}
