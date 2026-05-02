import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../services/cloudinary_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = false;

  Future<void> _pickAndUploadAvatar() async {
    final picker = ImagePicker();

    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );

    if (pickedImage == null) return;

    setState(() => isLoading = true);

    try {
      final imageFile = File(pickedImage.path);

      final imageUrl = await CloudinaryService().uploadImage(imageFile);

      await context.read<AuthService>().updateAvatarUrl(imageUrl);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile picture updated!')),
      );

      setState(() {});
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  Widget _avatarWidget(String avatarUrl) {
    if (avatarUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 58,
        backgroundColor: Colors.white,
        backgroundImage: NetworkImage(avatarUrl),
      );
    }

    return const CircleAvatar(
      radius: 58,
      backgroundColor: Colors.white,
      child: Icon(
        Icons.person,
        size: 70,
        color: Color(0xFF1E88E5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E88E5),
      appBar: AppBar(
        title: const Text(
          'PROFILE',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: context.read<AuthService>().getCurrentUserProfile(),
        builder: (context, snapshot) {
          final data = snapshot.data;
          final username = data?['username']?.toString() ?? 'Player';
          final email = data?['email']?.toString() ?? '';
          final avatarUrl = data?['avatar']?.toString() ?? '';

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        _avatarWidget(avatarUrl),
                        InkWell(
                          onTap: isLoading ? null : _pickAndUploadAvatar,
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            padding: const EdgeInsets.all(9),
                            decoration: const BoxDecoration(
                              color: Color(0xFF0D47A1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      username,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      email,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: 230,
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed: isLoading ? null : _pickAndUploadAvatar,
                        icon: isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.image),
                        label: Text(
                          isLoading ? 'UPLOADING...' : 'CHANGE AVATAR',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D47A1),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                            side: const BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
