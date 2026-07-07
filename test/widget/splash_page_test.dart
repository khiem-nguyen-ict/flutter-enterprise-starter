import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_enterprise_starter/config/l10n/app_localizations.dart';
import 'package:flutter_enterprise_starter/features/auth/data/providers/auth_provider.dart';
import 'package:flutter_enterprise_starter/features/auth/presentation/pages/splash_page.dart';

void main() {
  testWidgets('SplashPage shows app title', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SplashPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SplashPage), findsOneWidget);
    expect(find.text('Flutter Enterprise Starter'), findsOneWidget);
  });

  testWidgets('SplashPage triggers checkAuth on init', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SplashPage(),
        ),
      ),
    );

    final container = ProviderScope.containerOf(tester.element(find.byType(SplashPage)));
    expect(container.read(authNotifierProvider).status, AuthStatus.authenticated);
  });
}
