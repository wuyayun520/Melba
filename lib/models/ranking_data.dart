class RankingData {
  final List<RankingUser> users;

  RankingData({required this.users});

  factory RankingData.fromJson(Map<String, dynamic> json) {
    return RankingData(
      users: (json['users'] as List)
          .map((user) => RankingUser.fromJson(user))
          .toList(),
    );
  }
}

class RankingUser {
  final int rank;
  final String id;
  final String name;
  final String avatar;
  final double hours;
  final int likes;

  RankingUser({
    required this.rank,
    required this.id,
    required this.name,
    required this.avatar,
    required this.hours,
    required this.likes,
  });

  factory RankingUser.fromJson(Map<String, dynamic> json) {
    return RankingUser(
      rank: json['rank'],
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      hours: (json['hours'] as num).toDouble(),
      likes: json['likes'],
    );
  }
}

