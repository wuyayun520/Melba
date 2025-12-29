class MelbaData {
  final List<MelbaUser> users;

  MelbaData({required this.users});

  factory MelbaData.fromJson(Map<String, dynamic> json) {
    return MelbaData(
      users: (json['users'] as List)
          .map((user) => MelbaUser.fromJson(user))
          .toList(),
    );
  }
}

class MelbaUser {
  final UserInfo user;
  final List<Post> posts;

  MelbaUser({required this.user, required this.posts});

  factory MelbaUser.fromJson(Map<String, dynamic> json) {
    return MelbaUser(
      user: UserInfo.fromJson(json['user']),
      posts: (json['posts'] as List)
          .map((post) => Post.fromJson(post))
          .toList(),
    );
  }
}

class UserInfo {
  final String id;
  final String username;
  final String displayName;
  final String bio;
  final String avatar;
  final String profileBackground;
  final List<String> tags;

  UserInfo({
    required this.id,
    required this.username,
    required this.displayName,
    required this.bio,
    required this.avatar,
    required this.profileBackground,
    required this.tags,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      username: json['username'],
      displayName: json['displayName'],
      bio: json['bio'],
      avatar: json['avatar'],
      profileBackground: json['profileBackground'],
      tags: (json['tags'] as List).map((tag) => tag.toString()).toList(),
    );
  }
}

class Post {
  final String id;
  final String type;
  final PostContent content;
  final PostStats stats;

  Post({
    required this.id,
    required this.type,
    required this.content,
    required this.stats,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      type: json['type'],
      content: PostContent.fromJson(json['content']),
      stats: PostStats.fromJson(json['stats']),
    );
  }
}

class PostContent {
  final String videoUrl;
  final String description;
  final List<String> hashtags;

  PostContent({
    required this.videoUrl,
    required this.description,
    required this.hashtags,
  });

  factory PostContent.fromJson(Map<String, dynamic> json) {
    return PostContent(
      videoUrl: json['videoUrl'],
      description: json['description'],
      hashtags: (json['hashtags'] as List).map((tag) => tag.toString()).toList(),
    );
  }
}

class PostStats {
  final int likes;
  final int? views;

  PostStats({required this.likes, this.views});

  factory PostStats.fromJson(Map<String, dynamic> json) {
    return PostStats(
      likes: json['likes'],
      views: json['views'],
    );
  }
}

