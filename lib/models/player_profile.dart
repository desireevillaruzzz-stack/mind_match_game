class PlayerProfile {
  final String playerId;
  final String username;
  final String avatar;
  final String createdAt;

  const PlayerProfile({
    required this.playerId,
    required this.username,
    required this.avatar,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'playerId': playerId,
      'username': username,
      'avatar': avatar,
      'createdAt': createdAt,
    };
  }

  factory PlayerProfile.fromMap(Map<dynamic, dynamic> map) {
    return PlayerProfile(
      playerId: map['playerId']?.toString() ?? 'guest_001',
      username: map['username']?.toString() ?? 'Guest',
      avatar: map['avatar']?.toString() ?? '',
      createdAt: map['createdAt']?.toString() ?? '',
    );
  }
}
