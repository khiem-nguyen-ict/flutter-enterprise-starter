import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final String? userId;

  const AuthState({this.status = AuthStatus.unknown, this.userId});

  AuthState copyWith({AuthStatus? status, String? userId}) {
    return AuthState(
      status: status ?? this.status,
      userId: userId ?? this.userId,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  void checkAuth() {
    state = const AuthState(status: AuthStatus.authenticated, userId: 'user_123');
  }

  void login() {
    state = state.copyWith(status: AuthStatus.authenticated, userId: 'user_123');
  }

  void logout() {
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
