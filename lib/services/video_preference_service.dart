import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VideoPreferenceService {
  static const String _hiddenVideosKey = 'hidden_video_ids';
  
  // 内存存储作为备用方案
  static Set<String> _memoryStorage = <String>{};
  static bool _useMemoryStorage = false;

  static Future<Set<String>> getHiddenVideoIds() async {
    // 如果使用内存存储，直接返回
    if (_useMemoryStorage) {
      return _memoryStorage;
    }
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? hiddenIds = prefs.getStringList(_hiddenVideosKey);
      final result = hiddenIds?.toSet() ?? <String>{};
      // 同步到内存存储
      _memoryStorage = result;
      return result;
    } catch (e) {
      debugPrint('Error getting hidden video ids: $e');
      // 如果出错，切换到内存存储模式
      _useMemoryStorage = true;
      return _memoryStorage;
    }
  }

  static Future<void> hideVideo(String videoId) async {
    // 先更新内存存储
    _memoryStorage.add(videoId);
    
    // 如果使用内存存储，直接返回
    if (_useMemoryStorage) {
      debugPrint('Using memory storage: hiding video $videoId');
      return;
    }
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final Set<String> hiddenIds = await getHiddenVideoIds();
      hiddenIds.add(videoId);
      await prefs.setStringList(_hiddenVideosKey, hiddenIds.toList());
      // 同步到内存存储
      _memoryStorage = hiddenIds;
    } catch (e) {
      debugPrint('Error hiding video: $e, using memory storage');
      // 如果出错，切换到内存存储模式
      _useMemoryStorage = true;
    }
  }

  static Future<bool> isVideoHidden(String videoId) async {
    final hiddenIds = await getHiddenVideoIds();
    return hiddenIds.contains(videoId);
  }

  static Future<void> showVideo(String videoId) async {
    // 先更新内存存储
    _memoryStorage.remove(videoId);
    
    // 如果使用内存存储，直接返回
    if (_useMemoryStorage) {
      debugPrint('Using memory storage: showing video $videoId');
      return;
    }
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final Set<String> hiddenIds = await getHiddenVideoIds();
      hiddenIds.remove(videoId);
      await prefs.setStringList(_hiddenVideosKey, hiddenIds.toList());
      // 同步到内存存储
      _memoryStorage = hiddenIds;
    } catch (e) {
      debugPrint('Error showing video: $e, using memory storage');
      // 如果出错，切换到内存存储模式
      _useMemoryStorage = true;
    }
  }
}

