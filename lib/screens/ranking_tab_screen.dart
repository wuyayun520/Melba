import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/common_background.dart';
import '../models/melba_data.dart';
import '../services/like_service.dart';
import 'user_profile_screen.dart';
import 'melba_wallet_screen.dart';

class RankingTabScreen extends StatefulWidget {
  const RankingTabScreen({super.key});

  @override
  State<RankingTabScreen> createState() => _RankingTabScreenState();
}

class _RankingTabScreenState extends State<RankingTabScreen> {
  static const int _unlockCost = 34;
  String _selectedType = 'weekly';
  MelbaData? _melbaData;
  bool _isLoading = true;
  Set<String> _likedUserIds = {};
  Set<String> _unlockedUserIds = {};
  int _melbaCoins = 0;

  @override
  void initState() {
    super.initState();
    _loadRankingData();
    _loadLikedUsers();
    _loadUnlockedUsers();
    _loadMelbaCoins();
  }

  Future<void> _loadLikedUsers() async {
    final likedIds = await LikeService.getLikedUserIds();
    if (mounted) {
      setState(() {
        _likedUserIds = likedIds;
      });
    }
  }

  Future<void> _loadUnlockedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final unlockedList = prefs.getStringList('unlockedUserIds') ?? [];
    if (mounted) {
      setState(() {
        _unlockedUserIds = unlockedList.toSet();
      });
    }
  }

  Future<void> _loadMelbaCoins() async {
    final prefs = await SharedPreferences.getInstance();
    final coins = prefs.getInt('melbaCoins') ?? 0;
    if (mounted) {
      setState(() {
        _melbaCoins = coins;
      });
    }
  }

  Future<void> _saveUnlockedUser(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    _unlockedUserIds.add(userId);
    await prefs.setStringList('unlockedUserIds', _unlockedUserIds.toList());
  }

  Future<void> _consumeMelbaCoins(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    _melbaCoins -= amount;
    await prefs.setInt('melbaCoins', _melbaCoins);
  }

  Future<void> _checkAndUnlockUser(MelbaUser melbaUser) async {
    final userId = melbaUser.user.id;
    
    if (_unlockedUserIds.contains(userId)) {
      _navigateToUserProfile(melbaUser);
      return;
    }

    await _loadMelbaCoins();

    if (_melbaCoins < _unlockCost) {
      _showInsufficientCoinsDialog();
      return;
    }

    _showUnlockConfirmDialog(melbaUser);
  }

  void _showInsufficientCoinsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E3A5F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Insufficient Coins',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF71AAFF).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.monetization_on,
                size: 50,
                color: Color(0xFF71AAFF),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'You need $_unlockCost coins to unlock this profile.\nCurrent balance: $_melbaCoins coins',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MelbaWalletScreen(),
                ),
              ).then((_) => _loadMelbaCoins());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF71AAFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Recharge',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showUnlockConfirmDialog(MelbaUser melbaUser) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E3A5F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Unlock Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                melbaUser.user.avatar,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Unlock ${melbaUser.user.displayName}\'s profile?',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.monetization_on,
                  size: 24,
                  color: Color(0xFF71AAFF),
                ),
                const SizedBox(width: 8),
                Text(
                  '$_unlockCost Coins',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Current balance: $_melbaCoins coins',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _consumeMelbaCoins(_unlockCost);
              await _saveUnlockedUser(melbaUser.user.id);
              setState(() {});
              _navigateToUserProfile(melbaUser);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF71AAFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Unlock',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToUserProfile(MelbaUser melbaUser) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UserProfileScreen(melbaUser: melbaUser),
      ),
    );
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
      onTap: () => _checkAndUnlockUser(melbaUser),
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

