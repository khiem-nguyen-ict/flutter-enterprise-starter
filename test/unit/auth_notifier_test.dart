import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_enterprise_starter/features/auth/data/providers/auth_provider.dart';

void main() {
  group('AuthNotifier', () {
    test('initial state is unknown with no userId', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(authNotifierProvider);

      expect(state.status, AuthStatus.unknown);
      expect(state.userId, isNull);
    });

    test('checkAuth sets authenticated with user_123', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(authNotifierProvider.notifier).checkAuth();
      final state = container.read(authNotifierProvider);

      expect(state.status, AuthStatus.authenticated);
      expect(state.userId, 'user_123');
    });

    test('login sets authenticated and preserves userId', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(authNotifierProvider.notifier).login();
      final state = container.read(authNotifierProvider);

      expect(state.status, AuthStatus.authenticated);
      expect(state.userId, 'user_123');
    });

    test('logout clears userId and sets unauthenticated', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(authNotifierProvider.notifier).login();
      container.read(authNotifierProvider.notifier).logout();
      final state = container.read(authNotifierProvider);

      expect(state.status, AuthStatus.unauthenticated);
      expect(state.userId, isNull);
    });
  });
}
