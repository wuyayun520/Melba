import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlockService {
  static const String _blockedUsersKey = 'blocked_user_ids';
  
  // 内存存储作为备用方案
  static Set<String> _memoryStorage = <String>{};
  static bool _useMemoryStorage = false;

  static Future<Set<String>> getBlockedUserIds() async {
    // 如果使用内存存储，直接返回
    if (_useMemoryStorage) {
      return _memoryStorage;
    }
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? blockedIds = prefs.getStringList(_blockedUsersKey);
      final result = blockedIds?.toSet() ?? <String>{};
      // 同步到内存存储
      _memoryStorage = result;
      return result;
    } catch (e) {
      debugPrint('Error getting blocked user ids: $e');
      // 如果出错，切换到内存存储模式
      _useMemoryStorage = true;
      return _memoryStorage;
    }
  }

  static Future<void> blockUser(String userId) async {
    final blockedIds = await getBlockedUserIds();
    
    // 先更新内存存储
    _memoryStorage.add(userId);
    
    // 如果使用内存存储，直接返回
    if (_useMemoryStorage) {
      debugPrint('Using memory storage: blocking user $userId');
      return;
    }
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final Set<String> updatedBlockedIds = Set<String>.from(blockedIds);
      updatedBlockedIds.add(userId);
      await prefs.setStringList(_blockedUsersKey, updatedBlockedIds.toList());
      // 同步到内存存储
      _memoryStorage = updatedBlockedIds;
    } catch (e) {
      debugPrint('Error blocking user: $e, using memory storage');
      // 如果出错，切换到内存存储模式
      _useMemoryStorage = true;
    }
  }

  static Future<void> unblockUser(String userId) async {
    final blockedIds = await getBlockedUserIds();
    
    // 先更新内存存储
    _memoryStorage.remove(userId);
    
    // 如果使用内存存储，直接返回
    if (_useMemoryStorage) {
      debugPrint('Using memory storage: unblocking user $userId');
      return;
    }
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final Set<String> updatedBlockedIds = Set<String>.from(blockedIds);
      updatedBlockedIds.remove(userId);
      await prefs.setStringList(_blockedUsersKey, updatedBlockedIds.toList());
      // 同步到内存存储
      _memoryStorage = updatedBlockedIds;
    } catch (e) {
      debugPrint('Error unblocking user: $e, using memory storage');
      // 如果出错，切换到内存存储模式
      _useMemoryStorage = true;
    }
  }

  static Future<bool> isBlocked(String userId) async {
    final blockedIds = await getBlockedUserIds();
    return blockedIds.contains(userId);
  }
}

