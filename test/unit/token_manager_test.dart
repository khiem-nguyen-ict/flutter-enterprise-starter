import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_enterprise_starter/core/api/token/token_manager.dart';
import 'package:flutter_enterprise_starter/core/api/token/token_storage.dart';

class MockTokenStorage extends Mock implements TokenStorage {}
class MockDio extends Mock implements Dio {}

void main() {
  group('TokenManagerImpl', () {
    late MockTokenStorage mockStorage;
    late MockDio mockRefreshDio;
    late TokenManagerImpl tokenManager;

    setUp(() {
      mockStorage = MockTokenStorage();
      mockRefreshDio = MockDio();
      tokenManager = TokenManagerImpl(
        storage: mockStorage,
        refreshDio: mockRefreshDio,
        refreshPath: '/auth/refresh',
      );
    });

    test('accessToken delegates to storage', () async {
      when(() => mockStorage.readAccessToken()).thenAnswer((_) async => 'at_123');

      expect(await tokenManager.accessToken, 'at_123');
    });

    test('refreshToken delegates to storage', () async {
      when(() => mockStorage.readRefreshToken()).thenAnswer((_) async => 'rt_123');

      expect(await tokenManager.refreshToken, 'rt_123');
    });

    test('save persists tokens via storage', () async {
      when(() => mockStorage.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          )).thenAnswer((_) async {});

      await tokenManager.save(accessToken: 'at_456', refreshToken: 'rt_456');

      verify(() => mockStorage.saveTokens(accessToken: 'at_456', refreshToken: 'rt_456')).called(1);
    });

    test('clear delegates to storage', () async {
      when(() => mockStorage.clear()).thenAnswer((_) async {});

      await tokenManager.clear();

      verify(() => mockStorage.clear()).called(1);
    });

    group('refresh', () {
      test('returns null and returns early when refresh token is null', () async {
        when(() => mockStorage.readRefreshToken()).thenAnswer((_) async => null);

        final result = await tokenManager.refresh();

        expect(result, isNull);
        verifyNever(() => mockRefreshDio.post(any()));
      });

      test('returns null when refresh token is empty', () async {
        when(() => mockStorage.readRefreshToken()).thenAnswer((_) async => '');

        final result = await tokenManager.refresh();

        expect(result, isNull);
      });

      test('returns new access token and persists on successful refresh', () async {
        when(() => mockStorage.readRefreshToken()).thenAnswer((_) async => 'rt_123');
        when(() => mockStorage.saveTokens(
              accessToken: any(named: 'accessToken'),
              refreshToken: any(named: 'refreshToken'),
            )).thenAnswer((_) async {});
        when(() => mockRefreshDio.post(
              any(),
              data: any(named: 'data'),
            )).thenAnswer(
          (_) async => Response<Map<String, dynamic>>(
            requestOptions: RequestOptions(path: '/auth/refresh'),
            statusCode: 200,
            data: {
              'access_token': 'new_at',
              'refresh_token': 'new_rt',
            },
          ),
        );

        final result = await tokenManager.refresh();

        expect(result, 'new_at');
        verify(() => mockStorage.saveTokens(accessToken: 'new_at', refreshToken: 'new_rt')).called(1);
        verify(
            () => mockRefreshDio.post(
                  any(),
                  data: any(named: 'data'),
                ))
            .called(1);
      });

      test('returns old refresh token when response omits new refresh token', () async {
        when(() => mockStorage.readRefreshToken()).thenAnswer((_) async => 'rt_123');
        when(() => mockStorage.saveTokens(
              accessToken: any(named: 'accessToken'),
              refreshToken: any(named: 'refreshToken'),
            )).thenAnswer((_) async {});
        when(() => mockRefreshDio.post(
              any(),
              data: any(named: 'data'),
            )).thenAnswer(
          (_) async => Response<Map<String, dynamic>>(
            requestOptions: RequestOptions(path: '/auth/refresh'),
            statusCode: 200,
            data: {
              'access_token': 'new_at',
            },
          ),
        );

        final result = await tokenManager.refresh();

        expect(result, 'new_at');
        verify(() => mockStorage.saveTokens(accessToken: 'new_at', refreshToken: 'rt_123')).called(1);
      });

      test('returns null when response status is not 200', () async {
        when(() => mockStorage.readRefreshToken()).thenAnswer((_) async => 'rt_123');
        when(() => mockRefreshDio.post(
              any(),
              data: any(named: 'data'),
            )).thenAnswer(
          (_) async => Response<Map<String, dynamic>>(
            requestOptions: RequestOptions(path: '/auth/refresh'),
            statusCode: 500,
          ),
        );

        final result = await tokenManager.refresh();

        expect(result, isNull);
      });

      test('returns null when new access token is missing', () async {
        when(() => mockStorage.readRefreshToken()).thenAnswer((_) async => 'rt_123');
        when(() => mockRefreshDio.post(
              any(),
              data: any(named: 'data'),
            )).thenAnswer(
          (_) async => Response<Map<String, dynamic>>(
            requestOptions: RequestOptions(path: '/auth/refresh'),
            statusCode: 200,
            data: {},
          ),
        );

        final result = await tokenManager.refresh();

        expect(result, isNull);
      });

      test('returns null when DioException is thrown', () async {
        when(() => mockStorage.readRefreshToken()).thenAnswer((_) async => 'rt_123');
        when(() => mockRefreshDio.post(
              any(),
              data: any(named: 'data'),
            )).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/auth/refresh'),
            type: DioExceptionType.connectionError,
          ),
        );

        final result = await tokenManager.refresh();

        expect(result, isNull);
      });

      test('deduplicates concurrent refresh calls', () async {
        when(() => mockStorage.readRefreshToken()).thenAnswer((_) async => 'rt_123');
        when(() => mockStorage.saveTokens(
              accessToken: any(named: 'accessToken'),
              refreshToken: any(named: 'refreshToken'),
            )).thenAnswer((_) async {});
        when(() => mockRefreshDio.post(
              any(),
              data: any(named: 'data'),
            )).thenAnswer(
          (_) async => Response<Map<String, dynamic>>(
            requestOptions: RequestOptions(path: '/auth/refresh'),
            statusCode: 200,
            data: {
              'access_token': 'new_at',
              'refresh_token': 'new_rt',
            },
          ),
        );

        final future1 = tokenManager.refresh();
        final future2 = tokenManager.refresh();

        final results = await Future.wait([future1, future2]);

        expect(results, ['new_at', 'new_at']);
        verify(
            () => mockRefreshDio.post(
                  any(),
                  data: any(named: 'data'),
                ))
            .called(1);
      });
    });
  });
}
