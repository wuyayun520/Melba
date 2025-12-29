import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../widgets/common_background.dart';
import '../models/game_data.dart';
import 'game_detail_screen.dart';

class GroupTabScreen extends StatefulWidget {
  const GroupTabScreen({super.key});

  @override
  State<GroupTabScreen> createState() => _GroupTabScreenState();
}

class _GroupTabScreenState extends State<GroupTabScreen> {
  GameData? _gameData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGameData();
  }

  Future<void> _loadGameData() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/mapDecorationCycle/melbagame/gamepro.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      setState(() {
        _gameData = GameData.fromJson(jsonData);
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading game data: $e');
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
            // 顶部标题图片（向下移100，居中，大小214x25）
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Center(
                child: Image.asset(
                  'assets/melba_Activity.webp',
                  width: 214,
                  height: 25,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // 游戏列表内容区域
            Expanded(
              child: SafeArea(
                top: false,
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100, top: 0, left: 16, right: 16),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF71AAFF),
                          ),
                        )
                      : _gameData == null
                          ? const Center(
                              child: Text(
                                'Failed to load game data',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : _buildGameList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameList() {
    if (_gameData == null || _gameData!.arcadeClassicGames.isEmpty) {
      return const Center(
        child: Text(
          'No games available',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: _gameData!.arcadeClassicGames.length,
      itemBuilder: (context, index) {
        final game = _gameData!.arcadeClassicGames[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildGameCard(game),
        );
      },
    );
  }

  Widget _buildGameCard(ArcadeGame game) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final cardWidth = screenWidth; // 减去左右 padding (16 * 2)
        final cardHeight = cardWidth; // 1:1 比例
        
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => GameDetailScreen(game: game),
              ),
            );
          },
          child: Container(
            width: cardWidth,
            height: cardHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              fit: StackFit.expand,
            children: [
              // 背景图片
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/malba_group_card.webp',
                  fit: BoxFit.cover,
                ),
              ),
              // 游戏图标区域（上半部分）
              Positioned(
                top: 120,
                left: 40,
                right: 40,
                bottom: cardHeight * 0.25, // 底部35%用于信息区域
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  child: Image.asset(
                    game.images.icon,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[800],
                        child: const Center(
                          child: Icon(
                            Icons.gamepad,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // 游戏信息区域（下半部分）
              Positioned(
                bottom: 0,
                left: 40,
                right: 40,
                height: cardHeight * 0.25, // 35%的高度用于信息区域
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        game.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        game.description,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 13,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
            ),
          ),
        );
      },
    );
  }
}

