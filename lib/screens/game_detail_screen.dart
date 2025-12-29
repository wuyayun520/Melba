import 'package:flutter/material.dart';
import '../models/game_data.dart';
import '../widgets/common_background.dart';

class GameDetailScreen extends StatelessWidget {
  final ArcadeGame game;

  const GameDetailScreen({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CommonBackground(
        child: SafeArea(
          child: Column(
            children: [
              // 顶部导航栏
              Padding(
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
                    IconButton(
                      icon: const Icon(
                        Icons.error_outline,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () => _showReportDialog(context),
                      tooltip: 'Report',
                    ),
                  ],
                ),
              ),
              // 内容区域
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 游戏图标
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            game.images.icon,
                            width: double.infinity,
                            height: 250,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: double.infinity,
                                height: 200,
                                color: Colors.grey[800],
                                child: const Center(
                                  child: Icon(
                                    Icons.gamepad,
                                    color: Colors.white,
                                    size: 64,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // 游戏名称
                      Text(
                        game.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // 中文名
                      Text(
                        game.chineseName,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // 基本信息
                      Row(
                        children: [
                          _buildInfoChip('${game.releaseYear}', Icons.calendar_today),
                          const SizedBox(width: 12),
                          _buildInfoChip(game.genre, Icons.category),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // 描述
                      _buildSection(
                        'Description',
                        game.description,
                      ),
                      const SizedBox(height: 24),
                      // 详细描述
                      _buildSection(
                        'Detailed Description',
                        game.detailedDescription,
                      ),
                      const SizedBox(height: 24),
                      // 游戏机制
                      _buildListSection(
                        'Gameplay Mechanics',
                        game.gameplayMechanics,
                      ),
                      const SizedBox(height: 24),
                      // 标志性特性
                      _buildListSection(
                        'Iconic Features',
                        game.iconicFeatures,
                      ),
                      const SizedBox(height: 24),
                      // 技术细节
                      _buildTechnicalDetails(),
                      const SizedBox(height: 24),
                      // 文化影响
                      _buildSection(
                        'Cultural Impact',
                        game.culturalImpact,
                      ),
                      const SizedBox(height: 24),
                      // 传承
                      _buildSection(
                        'Legacy',
                        game.legacy,
                      ),
                      const SizedBox(height: 24),
                      // 奖项
                      if (game.awards.isNotEmpty)
                        _buildListSection(
                          'Awards',
                          game.awards,
                        ),
                      const SizedBox(height: 24),
                      // 平台
                      _buildPlatforms(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF71AAFF).withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF71AAFF),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 15,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildListSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6, right: 12),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF71AAFF),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 15,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildTechnicalDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Technical Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (game.technicalDetails.resolution != null)
          _buildDetailRow('Resolution', game.technicalDetails.resolution!),
        if (game.technicalDetails.cpu != null)
          _buildDetailRow('CPU', game.technicalDetails.cpu!),
        if (game.technicalDetails.sound != null)
          _buildDetailRow('Sound', game.technicalDetails.sound!),
        if (game.technicalDetails.display != null)
          _buildDetailRow('Display', game.technicalDetails.display!),
        if (game.technicalDetails.originalPlatform != null)
          _buildDetailRow('Original Platform', game.technicalDetails.originalPlatform!),
        if (game.technicalDetails.firstArcadeVersion != null)
          _buildDetailRow('First Arcade Version', game.technicalDetails.firstArcadeVersion!),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatforms() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Platforms',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: game.platforms.map((platform) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF71AAFF).withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF71AAFF),
                  width: 1,
                ),
              ),
              child: Text(
                platform,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Report Game',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Why are you reporting this game?',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            _buildReportOption(context, 'Inappropriate Content'),
            _buildReportOption(context, 'Spam or Misleading'),
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
  }

  Widget _buildReportOption(BuildContext context, String reason) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          _handleReport(context, reason);
        },
        child: Container(
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Colors.white70,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleReport(BuildContext context, String reason) {
    // 这里可以添加实际的举报逻辑，比如发送到服务器
    debugPrint('Report submitted for game: ${game.name}');
    debugPrint('Reason: $reason');
    
    // 显示确认消息
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Report submitted: $reason'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.grey[800],
      ),
    );
  }
}

