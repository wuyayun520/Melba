import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../widgets/common_background.dart';
import '../models/melba_data.dart';
import '../services/user_profile_service.dart';
import 'privacy_policy_screen.dart';
import 'terms_of_service_screen.dart';
import 'about_us_screen.dart';
import 'melba_wallet_screen.dart';

class MeTabScreen extends StatefulWidget {
  const MeTabScreen({super.key});

  @override
  State<MeTabScreen> createState() => _MeTabScreenState();
}

class _MeTabScreenState extends State<MeTabScreen> {
  MelbaUser? _currentUser;
  bool _isLoading = true;
  String _displayName = '';
  List<String> _tags = [];
  String? _avatarName;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      // 从 JSON 加载初始数据
      final String jsonString =
          await rootBundle.loadString('assets/mapDecorationCycle/MelbaData.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final melbaData = MelbaData.fromJson(jsonData);
      final defaultUser = melbaData.users.isNotEmpty ? melbaData.users[0] : null;
      
      // 从本地存储加载用户信息
      final savedDisplayName = await UserProfileService.getDisplayName();
      final savedTags = await UserProfileService.getTags();
      final savedAvatarName = await UserProfileService.getAvatarName();
      
      setState(() {
        _currentUser = defaultUser;
        _displayName = savedDisplayName ?? defaultUser?.user.displayName ?? '';
        _tags = savedTags.isNotEmpty ? savedTags : (defaultUser?.user.tags.take(2).toList() ?? []);
        _avatarName = savedAvatarName;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 获取头像路径
  Future<String?> _getAvatarPath() async {
    if (_avatarName == null || _avatarName!.isEmpty) {
      // 如果没有保存的头像，使用默认头像
      return _currentUser?.user.avatar;
    }
    final dir = await getApplicationDocumentsDirectory();
    final avatarPath = '${dir.path}/$_avatarName';
    final file = File(avatarPath);
    if (await file.exists()) {
      return avatarPath;
    }
    // 如果文件不存在，返回默认头像
    return _currentUser?.user.avatar;
  }

  // 统一编辑功能
  Future<void> _editProfile() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => _EditProfileDialog(
        displayName: _displayName,
        tags: List<String>.from(_tags),
        avatarName: _avatarName,
      ),
    );
    
    if (result != null) {
      // 更新显示名称
      if (result['displayName'] != null) {
        await UserProfileService.saveDisplayName(result['displayName']);
        setState(() {
          _displayName = result['displayName'];
        });
      }
      
      // 更新标签
      if (result['tags'] != null) {
        await UserProfileService.saveTags(result['tags']);
        setState(() {
          _tags = result['tags'];
        });
      }
      
      // 更新头像
      if (result['avatarName'] != null) {
        setState(() {
          _avatarName = result['avatarName'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CommonBackground(
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100, top: 40),
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF71AAFF),
                      ),
                    )
                  : _currentUser == null
                      ? const Center(
                          child: Text(
                            'No user data',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : _buildContent(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        
        child: ClipRRect(
          child: Stack(
            children: [
              // 背景图片 melba_me_card.webp（填充整个区域）
              Positioned.fill(
                child: Image.asset(
                  'assets/melba_me_card.webp',
                  fit: BoxFit.fill,
                ),
              ),
              // 所有内容层
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 用户信息区域（有padding）
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 用户信息区域
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 用户头像（往下移40，往右移20）
                            Padding(
                              padding: const EdgeInsets.only(top: 40, left: 20),
                              child: GestureDetector(
                                onTap: _editProfile,
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 84,
                                      height: 84,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 4,
                                        ),
                                      ),
                                      child: ClipOval(
                                        child: FutureBuilder<String?>(
                                          future: _getAvatarPath(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData || snapshot.data == null) {
                                              return Container(
                                                color: Colors.grey[800],
                                                child: const Icon(
                                                  Icons.person,
                                                  color: Colors.white,
                                                  size: 50,
                                                ),
                                              );
                                            }
                                            final avatarPath = snapshot.data!;
                                            // 判断是 asset 路径还是文件路径
                                            if (avatarPath.startsWith('assets/')) {
                                              return Image.asset(
                                                avatarPath,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Container(
                                                    color: Colors.grey[800],
                                                    child: const Icon(
                                                      Icons.person,
                                                      color: Colors.white,
                                                      size: 50,
                                                    ),
                                                  );
                                                },
                                              );
                                            } else {
                                              return Image.file(
                                                File(avatarPath),
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Container(
                                                    color: Colors.grey[800],
                                                    child: const Icon(
                                                      Icons.person,
                                                      color: Colors.white,
                                                      size: 50,
                                                    ),
                                                  );
                                                },
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF71AAFF),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            // 用户名和标签
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 12),
                                  // 用户名（可编辑）
                                  GestureDetector(
                                    onTap: _editProfile,
                                    child: Text(
                                      _displayName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  // 标签（只显示两个）
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: _tags.map((tag) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF8B5A9F),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          tag,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 54),
                        // Functions 图片
                        Image.asset(
                          'assets/melba_me_functions.webp',
                          fit: BoxFit.contain,
                          width: 146,
                          height: 56,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  // 功能区域（距离左右12）
                  Padding(
                    padding: const EdgeInsets.only(left: 36, right: 36, bottom: 20),
                    child: _buildFunctionsGrid(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFunctionsGrid() {
    final functionImages = [
      'assets/melba_privacy_policy.webp',
      'assets/melba_me_about_us.webp',
      'assets/melba_user_agreement.webp',
      'assets/melba_me_wallet.webp',
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFBFBDFF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1,
            ),
        itemCount: functionImages.length,
        itemBuilder: (context, index) {
          final imagePath = functionImages[index];
          return GestureDetector(
            onTap: () {
              // 根据图片路径跳转到对应页面
              if (imagePath == 'assets/melba_privacy_policy.webp') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PrivacyPolicyScreen(),
                  ),
                );
              } else if (imagePath == 'assets/melba_user_agreement.webp') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const TermsOfServiceScreen(),
                  ),
                );
              } else if (imagePath == 'assets/melba_me_about_us.webp') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AboutUsScreen(),
                  ),
                );
              } else if (imagePath == 'assets/melba_me_wallet.webp') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MelbaWalletScreen(),
                  ),
                );
              }
            },
            child: Image.asset(
              functionImages[index],
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.error_outline,
                    color: Colors.grey,
                    size: 40,
                  ),
                );
              },
            ),
          );
          },
        ),
        ),
      ),
    );
  }
}

// 统一编辑对话框
class _EditProfileDialog extends StatefulWidget {
  final String displayName;
  final List<String> tags;
  final String? avatarName;

  const _EditProfileDialog({
    required this.displayName,
    required this.tags,
    this.avatarName,
  });

  @override
  State<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<_EditProfileDialog> {
  late TextEditingController _nameController;
  late List<TextEditingController> _tagControllers;
  final TextEditingController _newTagController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  String? _newAvatarName;
  String? _currentAvatarPath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.displayName);
    _tagControllers = widget.tags
        .map((tag) => TextEditingController(text: tag))
        .toList();
    _loadCurrentAvatar();
  }

  Future<void> _loadCurrentAvatar() async {
    if (widget.avatarName != null && widget.avatarName!.isNotEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      final avatarPath = '${dir.path}/${widget.avatarName}';
      final file = File(avatarPath);
      if (await file.exists()) {
        setState(() {
          _currentAvatarPath = avatarPath;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    for (var controller in _tagControllers) {
      controller.dispose();
    }
    _newTagController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (image != null) {
        final savedPath = await UserProfileService.saveAvatarFile(File(image.path));
        if (savedPath != null) {
          final dir = await getApplicationDocumentsDirectory();
          setState(() {
            _newAvatarName = savedPath;
            _currentAvatarPath = '${dir.path}/$savedPath';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('选择头像失败: $e')),
        );
      }
    }
  }

  void _addTag() {
    final newTag = _newTagController.text.trim();
    if (newTag.isNotEmpty && _tagControllers.length < 2) {
      setState(() {
        _tagControllers.add(TextEditingController(text: newTag));
        _newTagController.clear();
      });
    }
  }

  void _removeTag(int index) {
    setState(() {
      _tagControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1E3A5F),
      title: const Text(
        '编辑资料',
        style: TextStyle(color: Colors.white),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 头像编辑
            Center(
              child: GestureDetector(
                onTap: _pickAvatar,
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF71AAFF),
                          width: 3,
                        ),
                      ),
                      child: ClipOval(
                        child: _currentAvatarPath != null
                            ? Image.file(
                                File(_currentAvatarPath!),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[800],
                                    child: const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                  );
                                },
                              )
                            : Container(
                                color: Colors.grey[800],
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 50,
                                ),
                              ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Color(0xFF71AAFF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // 名称编辑
            const Text(
              '名称',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: '请输入名称',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF71AAFF)),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF71AAFF), width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // 标签编辑
            const Text(
              '标签（最多2个）',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 8),
            ...List.generate(_tagControllers.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _tagControllers[index],
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: '标签 ${index + 1}',
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Color(0xFF71AAFF)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Color(0xFF71AAFF), width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _removeTag(index),
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),
              );
            }),
            if (_tagControllers.length < 2)
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _newTagController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: '添加新标签',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFF71AAFF)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFF71AAFF), width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onSubmitted: (_) => _addTag(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _addTag,
                    icon: const Icon(Icons.add, color: Color(0xFF71AAFF)),
                  ),
                ],
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            '取消',
            style: TextStyle(color: Colors.white70),
          ),
        ),
        TextButton(
          onPressed: () {
            final result = <String, dynamic>{
              'displayName': _nameController.text.trim(),
              'tags': _tagControllers
                  .map((c) => c.text.trim())
                  .where((t) => t.isNotEmpty)
                  .toList(),
            };
            if (_newAvatarName != null) {
              result['avatarName'] = _newAvatarName;
            }
            Navigator.of(context).pop(result);
          },
          child: const Text(
            '确定',
            style: TextStyle(color: Color(0xFF71AAFF)),
          ),
        ),
      ],
    );
  }
}


