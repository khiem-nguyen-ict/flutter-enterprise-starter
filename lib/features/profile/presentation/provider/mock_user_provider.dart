import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/user.dart';

/// Supplies the mock [User] used by the demo profile screen.
///
/// Swap this provider for a real repository call when wiring up the backend.
final mockUserProvider = Provider<User>((ref) {
  return const User(
    id: 'user_123',
    name: 'Ada Lovelace',
    email: 'ada.lovelace@example.com',
    role: 'Product Designer',
    bio:
        'Crafting delightful mobile experiences. Coffee-driven builder who loves '
        'turning complex problems into simple, elegant interfaces.',
    location: 'Helsinki, Finland',
    joinedDate: 'March 2023',
    posts: 128,
    followers: 5240,
    following: 312,
    interests: ['Design', 'Flutter', 'Coffee', 'Photography', 'Hiking'],
  );
});
