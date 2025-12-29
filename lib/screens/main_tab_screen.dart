import 'package:flutter/material.dart';
import '../widgets/common_background.dart';
import 'home_tab_screen.dart';
import 'group_tab_screen.dart';
import 'ranking_tab_screen.dart';
import 'me_tab_screen.dart';

class MainTabScreen extends StatefulWidget {
  const MainTabScreen({super.key});

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeTabScreen(),
    const GroupTabScreen(),
    const RankingTabScreen(),
    const MeTabScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CommonBackground(
        child: Stack(
          children: [
            _screens[_currentIndex],
            Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              ignoring: false,
              child: SafeArea(
                child: Container(
                  height: 80,
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTabItem(0, 'assets/melba_tab_home.webp'),
                      _buildTabItem(1, 'assets/melba_tab_group.webp'),
                      _buildTabItem(2, 'assets/melba_tab_ranking.webp'),
                      _buildTabItem(3, 'assets/melba_tab_me.webp'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildTabItem(int index, String imagePath) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: Matrix4.translationValues(0, isSelected ? -10 : 0, 0),
        width: 76,
        height: 76,
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

