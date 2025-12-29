import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FollowService {
  static const String _followedUsersKey = 'followed_user_ids';
  
  // 内存存储作为备用方案
  static Set<String> _memoryStorage = <String>{};
  static bool _useMemoryStorage = false;

  static Future<Set<String>> getFollowedUserIds() async {
    // 如果使用内存存储，直接返回
    if (_useMemoryStorage) {
      return _memoryStorage;
    }
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? followedIds = prefs.getStringList(_followedUsersKey);
      final result = followedIds?.toSet() ?? <String>{};
      // 同步到内存存储
      _memoryStorage = result;
      return result;
    } catch (e) {
      debugPrint('Error getting followed user ids: $e');
      // 如果出错，切换到内存存储模式
      _useMemoryStorage = true;
      return _memoryStorage;
    }
  }

  static Future<void> toggleFollow(String userId) async {
    final followedIds = await getFollowedUserIds();
    final isCurrentlyFollowed = followedIds.contains(userId);
    
    // 先更新内存存储
    if (isCurrentlyFollowed) {
      _memoryStorage.remove(userId);
    } else {
      _memoryStorage.add(userId);
    }
    
    // 如果使用内存存储，直接返回
    if (_useMemoryStorage) {
      debugPrint('Using memory storage: toggling follow for user $userId');
      return;
    }
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final Set<String> updatedFollowedIds = Set<String>.from(followedIds);
      if (isCurrentlyFollowed) {
        updatedFollowedIds.remove(userId);
      } else {
        updatedFollowedIds.add(userId);
      }
      await prefs.setStringList(_followedUsersKey, updatedFollowedIds.toList());
      // 同步到内存存储
      _memoryStorage = updatedFollowedIds;
    } catch (e) {
      debugPrint('Error toggling follow: $e, using memory storage');
      // 如果出错，切换到内存存储模式
      _useMemoryStorage = true;
    }
  }

  static Future<bool> isFollowed(String userId) async {
    final followedIds = await getFollowedUserIds();
    return followedIds.contains(userId);
  }

  static Future<void> setFollow(String userId, bool isFollowed) async {
    final followedIds = await getFollowedUserIds();
    
    // 先更新内存存储
    if (isFollowed) {
      _memoryStorage.add(userId);
    } else {
      _memoryStorage.remove(userId);
    }
    
    // 如果使用内存存储，直接返回
    if (_useMemoryStorage) {
      debugPrint('Using memory storage: setting follow for user $userId to $isFollowed');
      return;
    }
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final Set<String> updatedFollowedIds = Set<String>.from(followedIds);
      if (isFollowed) {
        updatedFollowedIds.add(userId);
      } else {
        updatedFollowedIds.remove(userId);
      }
      await prefs.setStringList(_followedUsersKey, updatedFollowedIds.toList());
      // 同步到内存存储
      _memoryStorage = updatedFollowedIds;
    } catch (e) {
      debugPrint('Error setting follow: $e, using memory storage');
      // 如果出错，切换到内存存储模式
      _useMemoryStorage = true;
    }
  }
}

