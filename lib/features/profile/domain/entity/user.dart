/// Mock domain entity describing the signed-in user.
///
/// In a real app this would come from a repository backed by the API. For the
/// demo it is supplied as static mock data via [mockUserProvider].
class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final String bio;
  final String location;
  final String joinedDate;
  final int posts;
  final int followers;
  final int following;
  final List<String> interests;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.bio,
    required this.location,
    required this.joinedDate,
    required this.posts,
    required this.followers,
    required this.following,
    this.interests = const [],
  });

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}
