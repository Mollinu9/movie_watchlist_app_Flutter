class UserProfile {
  final String username;

  UserProfile({required this.username});

  // Convert UserProfile to JSON
  Map<String, dynamic> toJson() {
    return {'username': username};
  }

  // Create UserProfile from JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(username: json['username'] as String? ?? '');
  }

  // Create a copy with updated fields
  UserProfile copyWith({String? username}) {
    return UserProfile(username: username ?? this.username);
  }

  // Default profile
  factory UserProfile.defaultProfile() {
    return UserProfile(username: '');
  }
}
