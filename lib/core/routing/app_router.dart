import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Central router configuration built on `go_router`.
/// Guarded routes and shell routes can be added here as features grow.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Placeholder(), // TODO: replace with home page
      ),
    ],
  );
});
