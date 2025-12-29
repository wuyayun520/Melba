import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LikeService {
  static const String _likedUsersKey = 'liked_user_ids';
  
  // 内存存储作为备用方案
  static Set<String> _memoryStorage = <String>{};
  static bool _useMemoryStorage = false;

  static Future<Set<String>> getLikedUserIds() async {
    // 如果使用内存存储，直接返回
    if (_useMemoryStorage) {
      return _memoryStorage;
    }
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? likedIds = prefs.getStringList(_likedUsersKey);
      final result = likedIds?.toSet() ?? <String>{};
      // 同步到内存存储
      _memoryStorage = result;
      return result;
    } catch (e) {
      debugPrint('Error getting liked user ids: $e');
      // 如果出错，切换到内存存储模式
      _useMemoryStorage = true;
      return _memoryStorage;
    }
  }

  static Future<void> toggleLike(String userId) async {
    final likedIds = await getLikedUserIds();
    final isCurrentlyLiked = likedIds.contains(userId);
    
    // 先更新内存存储
    if (isCurrentlyLiked) {
      _memoryStorage.remove(userId);
    } else {
      _memoryStorage.add(userId);
    }
    
    // 如果使用内存存储，直接返回
    if (_useMemoryStorage) {
      debugPrint('Using memory storage: toggling like for user $userId');
      return;
    }
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final Set<String> updatedLikedIds = Set<String>.from(likedIds);
      if (isCurrentlyLiked) {
        updatedLikedIds.remove(userId);
      } else {
        updatedLikedIds.add(userId);
      }
      await prefs.setStringList(_likedUsersKey, updatedLikedIds.toList());
      // 同步到内存存储
      _memoryStorage = updatedLikedIds;
    } catch (e) {
      debugPrint('Error toggling like: $e, using memory storage');
      // 如果出错，切换到内存存储模式
      _useMemoryStorage = true;
    }
  }

  static Future<bool> isLiked(String userId) async {
    final likedIds = await getLikedUserIds();
    return likedIds.contains(userId);
  }

  static Future<void> setLike(String userId, bool isLiked) async {
    final likedIds = await getLikedUserIds();
    
    // 先更新内存存储
    if (isLiked) {
      _memoryStorage.add(userId);
    } else {
      _memoryStorage.remove(userId);
    }
    
    // 如果使用内存存储，直接返回
    if (_useMemoryStorage) {
      debugPrint('Using memory storage: setting like for user $userId to $isLiked');
      return;
    }
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final Set<String> updatedLikedIds = Set<String>.from(likedIds);
      if (isLiked) {
        updatedLikedIds.add(userId);
      } else {
        updatedLikedIds.remove(userId);
      }
      await prefs.setStringList(_likedUsersKey, updatedLikedIds.toList());
      // 同步到内存存储
      _memoryStorage = updatedLikedIds;
    } catch (e) {
      debugPrint('Error setting like: $e, using memory storage');
      // 如果出错，切换到内存存储模式
      _useMemoryStorage = true;
    }
  }
}

