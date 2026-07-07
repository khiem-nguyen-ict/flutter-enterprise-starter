import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/data/providers/auth_provider.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

const splashRoutePath = '/splash';
const loginRoutePath = '/login';
const homeRoutePath = '/home';
const settingsRoutePath = '/settings';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);
  final isLoggedIn = authState.status == AuthStatus.authenticated;
  final isUnknown = authState.status == AuthStatus.unknown;

  return GoRouter(
    initialLocation: splashRoutePath,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: splashRoutePath,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: loginRoutePath,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: homeRoutePath,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: settingsRoutePath,
        builder: (context, state) => const SettingsPage(),
      ),
    ],
    redirect: (context, state) {
      final location = state.matchedLocation;

      if (isUnknown) {
        return splashRoutePath;
      }

      if (isLoggedIn) {
        if (location == splashRoutePath || location == loginRoutePath) {
          return homeRoutePath;
        }
        if (location == settingsRoutePath || location == homeRoutePath) {
          return null;
        }
        return homeRoutePath;
      }

      if (location == homeRoutePath || location == settingsRoutePath || location == splashRoutePath) {
        return loginRoutePath;
      }

      return null;
    },
  );
});
