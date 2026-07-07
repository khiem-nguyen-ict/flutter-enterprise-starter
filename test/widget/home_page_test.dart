import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_enterprise_starter/config/l10n/app_localizations.dart';
import 'package:flutter_enterprise_starter/features/home/presentation/pages/home_page.dart';

void main() {
  testWidgets('HomePage renders home title and settings button', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const HomePage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Go to Settings'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
  });
}
