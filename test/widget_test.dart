import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_enterprise_starter/main.dart';

void main() {
  testWidgets('App builds and renders without throwing', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pumpAndSettle();

    expect(find.byType(App), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
