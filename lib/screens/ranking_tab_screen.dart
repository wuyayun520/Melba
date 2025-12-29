import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../widgets/common_background.dart';
import '../models/melba_data.dart';
import '../services/like_service.dart';
import 'user_profile_screen.dart';

class RankingTabScreen extends StatefulWidget {
  const RankingTabScreen({super.key});

  @override
  State<RankingTabScreen> createState() => _RankingTabScreenState();
}

class _RankingTabScreenState extends State<RankingTabScreen> {
  String _selectedType = 'weekly'; // 默认选中 weekly
  MelbaData? _melbaData;
  bool _isLoading = true;
  Set<String> _likedUserIds = {}; // 存储已点赞的用户ID

  @override
  void initState() {
    super.initState();
    _loadRankingData();
    _loadLikedUsers();
  }

  Future<void> _loadLikedUsers() async {
    final likedIds = await LikeService.getLikedUserIds();
    if (mounted) {
      setState(() {
        _likedUserIds = likedIds;
      });
    }
  }

  Future<void> _loadRankingData() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/mapDecorationCycle/MelbaData.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      setState(() {
        _melbaData = MelbaData.fromJson(jsonData);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CommonBackground(
        child: Column(
          children: [
            // 顶部图片（从电池栏开始）
            Image.asset(
              'assets/malba_challenge_top.webp',
              fit: BoxFit.contain,
              width: double.infinity,
            ),
            // 分类选项图片（单张图片，左右区域可点击切换）
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 0),
              child: Stack(
                children: [
                  // 显示的图片
                  Image.asset(
                    _selectedType == 'weekly'
                        ? 'assets/melba_challenge_weekly.webp'
                        : 'assets/melba_challenge_monthly.webp',
                    fit: BoxFit.contain,
                    width: double.infinity,
                  ),
                  // 左侧点击区域（切换到 weekly）
                  Positioned.fill(
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedType = 'weekly';
                              });
                            },
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                        // 右侧点击区域（切换到 monthly）
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedType = 'monthly';
                              });
                            },
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // 排行榜内容区域
            Expanded(
              child: SafeArea(
                top: false,
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100, top: 12, left: 16, right: 16),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF71AAFF),
                          ),
                        )
                      : _melbaData == null
                          ? const Center(
                              child: Text(
                                'Failed to load ranking data',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : _buildRankingList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<MelbaUser> _getRankingUsers() {
    if (_melbaData == null) return [];
    // 根据用户数据创建排行榜，使用 likes 作为排序依据
    final users = List<MelbaUser>.from(_melbaData!.users);
    users.sort((a, b) {
      final aLikes = a.posts.isNotEmpty ? a.posts.first.stats.likes : 0;
      final bLikes = b.posts.isNotEmpty ? b.posts.first.stats.likes : 0;
      return bLikes.compareTo(aLikes);
    });
    return users;
  }

  Widget _buildRankingList() {
    final users = _getRankingUsers();
    final displayCount = _selectedType == 'weekly' ? 6 : users.length;
    final displayUsers = users.take(displayCount).toList();

    if (displayUsers.isEmpty) {
      return const Center(
        child: Text(
          'No ranking data available',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: displayUsers.length,
      itemBuilder: (context, index) {
        final melbaUser = displayUsers[index];
        final rank = index + 1;
        final hours = (melbaUser.posts.isNotEmpty ? melbaUser.posts.first.stats.likes : 0) * 0.5 + 50.0;
        final likes = melbaUser.posts.isNotEmpty ? melbaUser.posts.first.stats.likes : 0;
        return _buildRankingCard(rank, melbaUser, hours, likes);
      },
    );
  }

  Widget _buildRankingCard(int rank, MelbaUser melbaUser, double hours, int likes) {
    final user = melbaUser.user;
    // 根据排名选择星星颜色（仅用于第4名及以后）
    Color starColor;
    if (rank == 1) {
      starColor = Colors.yellow;
    } else if (rank == 2) {
      starColor = Colors.purple;
    } else if (rank == 3) {
      starColor = Colors.orange;
    } else {
      starColor = const Color(0xFF87CEEB);
    }

    // 根据排名选择图片
    String? rankImagePath;
    if (rank == 1) {
      rankImagePath = 'assets/melba_pop_one.webp';
    } else if (rank == 2) {
      rankImagePath = 'assets/melba_pop_two.webp';
    } else if (rank == 3) {
      rankImagePath = 'assets/melba_pop_three.webp';
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => UserProfileScreen(melbaUser: melbaUser),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: const DecorationImage(
            image: AssetImage('assets/melba_challengeBG.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
          // 排名图标（前三名使用图片，其他使用圆形图标）
          rankImagePath != null
              ? Image.asset(
                  rankImagePath,
                  width: 43,
                  height: 43,
                  fit: BoxFit.contain,
                )
              : Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: starColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$rank',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
          const SizedBox(width: 12),
          // 用户头像
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                user.avatar,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey[800],
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 24,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          // 用户信息
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.displayName,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 2),
                Text(
                  '${hours.toStringAsFixed(1)}hours',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // 点赞区域
          GestureDetector(
            onTap: () async {
              final isLiked = _likedUserIds.contains(user.id);
              await LikeService.toggleLike(user.id);
              if (mounted) {
                setState(() {
                  if (isLiked) {
                    _likedUserIds.remove(user.id);
                  } else {
                    _likedUserIds.add(user.id);
                  }
                });
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  _likedUserIds.contains(user.id)
                      ? 'assets/melba_like_selete.webp'
                      : 'assets/melba_like_nor.webp',
                  width: 33,
                  height: 33,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E3A5F),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '$likes',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }
}

