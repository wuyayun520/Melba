import 'package:flutter/material.dart';
import '../widgets/common_background.dart';
import '../models/melba_data.dart';
import '../widgets/video_card.dart';
import '../services/follow_service.dart';
import '../services/block_service.dart';
import 'melba_chat_screen.dart';

class UserProfileScreen extends StatefulWidget {
  final MelbaUser melbaUser;

  const UserProfileScreen({
    super.key,
    required this.melbaUser,
  });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _isFollowed = false;
  bool _isBlocked = false;

  @override
  void initState() {
    super.initState();
    _loadFollowStatus();
    _loadBlockStatus();
  }

  Future<void> _loadFollowStatus() async {
    final isFollowed = await FollowService.isFollowed(widget.melbaUser.user.id);
    if (mounted) {
      setState(() {
        _isFollowed = isFollowed;
      });
    }
  }

  Future<void> _loadBlockStatus() async {
    final isBlocked = await BlockService.isBlocked(widget.melbaUser.user.id);
    if (mounted) {
      setState(() {
        _isBlocked = isBlocked;
      });
    }
  }

  Future<void> _handleFollowToggle() async {
    await FollowService.toggleFollow(widget.melbaUser.user.id);
    if (mounted) {
      setState(() {
        _isFollowed = !_isFollowed;
      });
    }
  }

  Future<void> _handleBlock() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Block User',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to block this user? You won\'t see their content anymore.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Block',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await BlockService.blockUser(widget.melbaUser.user.id);
      if (mounted) {
        setState(() {
          _isBlocked = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User has been blocked'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleUnblock() async {
    await BlockService.unblockUser(widget.melbaUser.user.id);
    if (mounted) {
      setState(() {
        _isBlocked = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User has been unblocked'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _handleReport() async {
    final reason = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Report User',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildReportOption(context, 'Inappropriate Content'),
            _buildReportOption(context, 'Spam or Misleading'),
            _buildReportOption(context, 'Harassment or Bullying'),
            _buildReportOption(context, 'Fake Account'),
            _buildReportOption(context, 'Copyright Violation'),
            _buildReportOption(context, 'Other'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );

    if (reason != null && reason.isNotEmpty) {
      // 这里可以添加实际的举报逻辑，比如发送到服务器
      debugPrint('Report submitted for user: ${widget.melbaUser.user.id}');
      debugPrint('Reason: $reason');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Report submitted: $reason'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.grey[800],
          ),
        );
      }
    }
  }

  Widget _buildReportOption(BuildContext context, String reason) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(reason),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                reason,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.melbaUser.user;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CommonBackground(
        child: Stack(
          children: [
            // 可滚动的内容区域
            SingleChildScrollView(
          child: Column(
            children: [
                  // 顶部大背景图
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Image.asset(
                      user.profileBackground,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[800],
                        );
                      },
                ),
              ),
                  // 用户信息区域（往下移）
                  Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _isBlocked
                        ? _buildBlockedView()
                        : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        const SizedBox(height: 40),
                        // 用户头像、关注按钮和聊天按钮
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                              border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 3,
                              ),
                            ),
                                  child: ClipOval(
                              child: Image.asset(
                                user.avatar,
                                      width: 90,
                                      height: 90,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                          width: 90,
                                          height: 90,
                                    color: Colors.grey[800],
                                    child: const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                            size: 45,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: _handleFollowToggle,
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: _isFollowed 
                                            ? Colors.green 
                                            : const Color(0xFF71AAFF),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                      child: Icon(
                                        _isFollowed ? Icons.check : Icons.add,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            // 聊天按钮
                          Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => MelbaChatScreen(
                                            userId: user.id,
                                            userName: user.displayName,
                                            userAvatar: user.avatar,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Image.asset(
                                      'assets/melba_message.webp',
                                      width: 100,
                                      height: 76,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: 100,
                                          height: 76,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF71AAFF),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: const Icon(
                                            Icons.message,
                                            color: Colors.white,
                                            size: 40,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // 用户名和性别
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                            Expanded(
                              child: Text(
                                  user.displayName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black54,
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                  ),
                                ),
                            
                          ],
                        ),
                        // 用户名（username）
                        if (user.username.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  '@${user.username}',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 14,
                                  ),
                                ),
                        ],
                        const SizedBox(height: 12),
                        // 用户简介（完整显示）
                        if (user.bio.isNotEmpty) ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                                      ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.bio,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.95),
                                    fontSize: 15,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                      ],
                        // 用户标签
                      if (user.tags.isNotEmpty) ...[
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: user.tags.map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                  color: const Color(0xFF71AAFF).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFF71AAFF),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                tag,
                                style: const TextStyle(
                                  color: Colors.white,
                                    fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                          const SizedBox(height: 16),
                      ],
                        // Project 标题
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E3A5F),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.folder_open,
                                color: Color(0xFF71AAFF),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                        const Text(
                                'Project',
                          style: TextStyle(
                            color: Colors.white,
                                  fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                              const Spacer(),
                              Text(
                                '${widget.melbaUser.posts.length}',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Project 时间线
                        _buildProjectTimeline(),
                        const SizedBox(height: 100), // 底部留白
                            ],
                          ),
                        ),
                ],
              ),
            ),
            // 固定在顶部的导航栏
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Spacer(),
                    PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 28,
                      ),
                      color: Colors.grey[900],
                      onSelected: (value) {
                        if (value == 'block') {
                          _handleBlock();
                        } else if (value == 'unblock') {
                          _handleUnblock();
                        } else if (value == 'report') {
                          _handleReport();
                        }
                      },
                      itemBuilder: (context) => [
                        if (_isBlocked)
                          const PopupMenuItem<String>(
                            value: 'unblock',
                            child: Row(
                              children: [
                                Icon(Icons.block, color: Colors.green, size: 20),
                                SizedBox(width: 8),
                                Text('Unblock User', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          )
                        else ...[
                          const PopupMenuItem<String>(
                            value: 'block',
                            child: Row(
                              children: [
                                Icon(Icons.block, color: Colors.red, size: 20),
                                SizedBox(width: 8),
                                Text('Block User', style: TextStyle(color: Colors.white)),
                              ],
                                  ),
                                ),
                          const PopupMenuItem<String>(
                            value: 'report',
                            child: Row(
                                  children: [
                                Icon(Icons.flag, color: Colors.orange, size: 20),
                                SizedBox(width: 8),
                                Text('Report User', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
                                                ),
                                              ),
                                            );
  }

  Widget _buildProjectTimeline() {
    if (widget.melbaUser.posts.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            'No projects yet',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
                                        ),
                                      ),
                                    ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.melbaUser.posts.length,
      itemBuilder: (context, index) {
        final post = widget.melbaUser.posts[index];
        
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                      // 视频卡片
                      VideoCard(
                        post: post,
                        user: widget.melbaUser.user,
                        date: _formatDate(post.id),
                      ),
                    const SizedBox(height: 12),
                    // 描述
                    if (post.content.description.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                                            ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                            Icon(
                              Icons.description,
                              color: Colors.white.withOpacity(0.7),
                              size: 18,
                                              ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                post.content.description,
                                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                  height: 1.4,
                                              ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    // 点赞数和标签
                    Row(
                      children: [
                       
                        if (post.content.hashtags.isNotEmpty) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: post.content.hashtags.take(3).map((hashtag) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '#$hashtag',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                              }).toList(),
                            ),
                        ),
                      ],
                    ],
                  ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(String postId) {
    // 从 postId 或使用当前日期，这里简化处理
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  Widget _buildBlockedView() {
    return Column(
      children: [
        const SizedBox(height: 100),
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.grey[900]!.withOpacity(0.8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.red.withOpacity(0.5),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.block,
                color: Colors.red,
                size: 64,
              ),
              const SizedBox(height: 16),
              const Text(
                'This user has been blocked',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'You won\'t see their content anymore.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _handleUnblock,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Unblock User',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 100),
      ],
    );
  }
}
