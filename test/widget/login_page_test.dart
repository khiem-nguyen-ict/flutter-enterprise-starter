import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_enterprise_starter/config/l10n/app_localizations.dart';
import 'package:flutter_enterprise_starter/features/auth/presentation/pages/login_page.dart';

void main() {
  testWidgets('LoginPage renders login button', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const LoginPage(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
