import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class UserProfileService {
  static const String _keyDisplayName = 'user_display_name';
  static const String _keyTags = 'user_tags';
  static const String _keyAvatarName = 'user_avatar_name';

  // 获取沙盒路径
  static Future<String> getDocumentsPath() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      return dir.path;
    } catch (e) {
      debugPrint('Error getting documents directory: $e');
      // 使用内存存储作为后备
      return '';
    }
  }

  // 获取头像完整路径
  static Future<String> getAvatarPath(String avatarName) async {
    if (avatarName.isEmpty) return '';
    try {
      final dir = await getApplicationDocumentsDirectory();
      return '${dir.path}/$avatarName';
    } catch (e) {
      debugPrint('Error getting avatar path: $e');
      return '';
    }
  }

  // 保存显示名称
  static Future<void> saveDisplayName(String displayName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyDisplayName, displayName);
    } catch (e) {
      debugPrint('Error saving display name: $e');
    }
  }

  // 获取显示名称
  static Future<String?> getDisplayName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyDisplayName);
    } catch (e) {
      debugPrint('Error getting display name: $e');
      return null;
    }
  }

  // 保存标签
  static Future<void> saveTags(List<String> tags) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_keyTags, tags);
    } catch (e) {
      debugPrint('Error saving tags: $e');
    }
  }

  // 获取标签
  static Future<List<String>> getTags() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_keyTags) ?? [];
    } catch (e) {
      debugPrint('Error getting tags: $e');
      return [];
    }
  }

  // 保存头像名称
  static Future<void> saveAvatarName(String avatarName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyAvatarName, avatarName);
    } catch (e) {
      debugPrint('Error saving avatar name: $e');
    }
  }

  // 获取头像名称
  static Future<String?> getAvatarName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyAvatarName);
    } catch (e) {
      debugPrint('Error getting avatar name: $e');
      return null;
    }
  }

  // 保存头像文件到沙盒
  static Future<String?> saveAvatarFile(File imageFile) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final avatarDir = Directory('${dir.path}/avatars');
      if (!await avatarDir.exists()) {
        await avatarDir.create(recursive: true);
      }
      
      final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await imageFile.copy('${avatarDir.path}/$fileName');
      
      // 保存头像名称
      await saveAvatarName('avatars/$fileName');
      
      return 'avatars/$fileName';
    } catch (e) {
      debugPrint('Error saving avatar file: $e');
      return null;
    }
  }
}

