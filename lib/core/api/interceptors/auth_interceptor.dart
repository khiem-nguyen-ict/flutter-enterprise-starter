import 'dart:io';

import 'package:dio/dio.dart';

import '../token/token_manager.dart';

/// Attaches the bearer access token to outgoing requests.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.tokenManager});

  final TokenManager tokenManager;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Allow per-request overrides (e.g. unauthenticated endpoints).
    if (options.headers[HttpHeaders.authorizationHeader] == null) {
      final token = await tokenManager.accessToken;
      if (token != null && token.isNotEmpty) {
        options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
      }
    }
    handler.next(options);
  }
}
