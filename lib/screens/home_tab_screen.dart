import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:math';
import '../widgets/common_background.dart';
import '../models/melba_data.dart';
import '../widgets/video_card.dart';
import '../services/video_preference_service.dart';
import 'video_player_screen.dart';

class HomeTabScreen extends StatefulWidget {
  const HomeTabScreen({super.key});

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  MelbaData? _melbaData;
  bool _isLoading = true;
  PageController? _pageController;
  Set<String> _hiddenVideoIds = {};
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadHiddenVideos();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_pageController == null) {
      _pageController = PageController();
    }
  }

  Future<void> _loadHiddenVideos() async {
    final hiddenIds = await VideoPreferenceService.getHiddenVideoIds();
    if (mounted) {
      setState(() {
        _hiddenVideoIds = hiddenIds;
      });
    }
  }

  Future<void> _refreshHiddenVideos() async {
    await _loadHiddenVideos();
    
    if (mounted) {
      final filteredUsers = _getFilteredUsers();
      final newCount = filteredUsers.length;
      
      // 如果当前页面索引超出范围，调整到合适的页面
      if (_currentPageIndex >= newCount && newCount > 0) {
        _currentPageIndex = newCount - 1;
        _pageController?.animateToPage(
          _currentPageIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
      
      // 强制重建整个列表
      setState(() {});
    }
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
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

  String _getDateForPost(int index) {
    final now = DateTime.now();
    final date = now.subtract(Duration(days: index));
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }

  List<MelbaUser> _getFilteredUsers() {
    if (_melbaData == null) return [];
    return _melbaData!.users.where((user) {
      if (user.posts.isEmpty) return false;
      final post = user.posts.first;
      return !_hiddenVideoIds.contains(post.id);
    }).toList();
  }

  void _handleTitleTap() {
    final filteredUsers = _getFilteredUsers();
    if (filteredUsers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No videos available'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final random = Random();
    final randomIndex = random.nextInt(filteredUsers.length);
    final randomUser = filteredUsers[randomIndex];
    
    if (randomUser.posts.isEmpty) {
      return;
    }
    
    final post = randomUser.posts.first;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(
          post: post,
          user: randomUser.user,
        ),
      ),
    ).then((result) {
      if (result == true) {
        _refreshHiddenVideos();
      }
    });
  }

  Widget _buildVideoList() {
    final filteredUsers = _getFilteredUsers();
    
    if (filteredUsers.isEmpty) {
      return const Center(
        child: Text(
          'No videos available',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    // 确保当前页面索引在有效范围内
    if (_currentPageIndex >= filteredUsers.length) {
      _currentPageIndex = filteredUsers.length > 0 ? filteredUsers.length - 1 : 0;
    }

    return PageView.builder(
      key: ValueKey('video_list_${_hiddenVideoIds.length}'), // 使用 key 强制重建
      controller: _pageController,
      itemCount: filteredUsers.length,
      onPageChanged: (index) {
        _currentPageIndex = index;
      },
      itemBuilder: (context, index) {
        final user = filteredUsers[index];
        if (user.posts.isEmpty) {
          return const SizedBox();
        }
        final post = user.posts.first;
        return Center(
          child: VideoCard(
            post: post,
            user: user.user,
            date: _getDateForPost(index),
            onVideoHidden: _refreshHiddenVideos,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CommonBackground(
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 24),
                  child: GestureDetector(
                    onTap: _handleTitleTap,
                    child: Image.asset(
                      'assets/melba_home_title.webp',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF71AAFF),
                          ),
                        )
                      : _melbaData == null
                          ? const Center(
                              child: Text(
                                'Failed to load data',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : _buildVideoList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

