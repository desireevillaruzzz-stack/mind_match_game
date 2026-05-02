import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_settings.dart';
import '../models/player_profile.dart';
import '../services/audio_service.dart';
import '../services/haptic_service.dart';
import '../services/local_storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _musicOn = true;
  bool _soundOn = true;
  bool _vibrationOn = true;
  bool _isLoaded = false;

  String _playerId = '';
  String _createdAt = '';
  String _selectedDifficulty = 'medium';
  late final TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isLoaded) {
      _loadData();
    }
    context
        .read<AudioService>()
        .ensureBackgroundMusicPlaying(forceRestart: true);
  }

  Future<void> _loadData() async {
    final storage = context.read<LocalStorageService>();
    final settings = storage.getAppSettings();
    final player = await storage.ensurePlayerProfile();

    if (!mounted) return;

    setState(() {
      _musicOn = settings.musicOn;
      _soundOn = settings.soundOn;
      _vibrationOn = settings.vibrationOn;
      _selectedDifficulty = settings.selectedDifficulty;
      _playerId = player.playerId;
      _createdAt = player.createdAt;
      _usernameController.text = player.username;
      _isLoaded = true;
    });
  }

  Future<void> _saveSettings() async {
    final storage = context.read<LocalStorageService>();
    final audioService = context.read<AudioService>();
    final hapticService = context.read<HapticService>();
    final trimmedUsername = _usernameController.text.trim();

    await storage.saveAppSettings(
      AppSettings(
        musicOn: _musicOn,
        soundOn: _soundOn,
        vibrationOn: _vibrationOn,
        selectedDifficulty: _selectedDifficulty,
      ),
    );

    await storage.savePlayerProfile(
      PlayerProfile(
        playerId: _playerId.isEmpty
            ? 'player_${DateTime.now().millisecondsSinceEpoch}'
            : _playerId,
        username: trimmedUsername.isEmpty ? 'Guest' : trimmedUsername,
        avatar: '',
        createdAt:
            _createdAt.isEmpty ? DateTime.now().toIso8601String() : _createdAt,
      ),
    );

    await audioService.updateMusicSetting(_musicOn);
    await audioService.updateSoundSetting(_soundOn);
    await hapticService.updateVibrationSetting(_vibrationOn);

    if (_musicOn) {
      await audioService.ensureBackgroundMusicPlaying(forceRestart: true);
    }

    if (_soundOn) {
      await audioService.playClickSound();
    }

    if (_vibrationOn) {
      await hapticService.lightTap();
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved offline')),
    );
  }

  Future<void> _resetGame() async {
    final storage = context.read<LocalStorageService>();
    final audioService = context.read<AudioService>();
    final hapticService = context.read<HapticService>();

    await storage.clearAllData();
    await audioService.updateMusicSetting(true);
    await audioService.updateSoundSetting(true);
    await hapticService.updateVibrationSetting(true);

    if (!mounted) return;

    setState(() {
      _musicOn = true;
      _soundOn = true;
      _vibrationOn = true;
      _selectedDifficulty = 'medium';
      _playerId = '';
      _createdAt = '';
      _usernameController.text = 'Guest';
    });

    await audioService.ensureBackgroundMusicPlaying(forceRestart: true);
    await audioService.playClickSound();
    await hapticService.lightTap();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Offline data reset')),
    );
  }

  Future<void> _toggleMusic(bool value) async {
    final storage = context.read<LocalStorageService>();
    final audioService = context.read<AudioService>();
    final hapticService = context.read<HapticService>();

    setState(() {
      _musicOn = value;
    });

    await audioService.updateMusicSetting(value);

    await storage.saveAppSettings(
      AppSettings(
        musicOn: _musicOn,
        soundOn: _soundOn,
        vibrationOn: _vibrationOn,
        selectedDifficulty: _selectedDifficulty,
      ),
    );

    if (_vibrationOn) {
      await hapticService.lightTap();
    }

    if (_musicOn) {
      await audioService.ensureBackgroundMusicPlaying(forceRestart: true);
    }
  }

  Future<void> _toggleSound(bool value) async {
    final storage = context.read<LocalStorageService>();
    final audioService = context.read<AudioService>();
    final hapticService = context.read<HapticService>();

    setState(() {
      _soundOn = value;
    });

    await audioService.updateSoundSetting(value);

    await storage.saveAppSettings(
      AppSettings(
        musicOn: _musicOn,
        soundOn: _soundOn,
        vibrationOn: _vibrationOn,
        selectedDifficulty: _selectedDifficulty,
      ),
    );

    if (_musicOn) {
      await audioService.ensureBackgroundMusicPlaying(forceRestart: true);
    }

    if (_vibrationOn) {
      await hapticService.lightTap();
    }

    if (_soundOn) {
      await audioService.playClickSound();
    }
  }

  Future<void> _toggleVibration(bool value) async {
    final storage = context.read<LocalStorageService>();
    final hapticService = context.read<HapticService>();
    final audioService = context.read<AudioService>();

    setState(() {
      _vibrationOn = value;
    });

    await hapticService.updateVibrationSetting(value);

    await storage.saveAppSettings(
      AppSettings(
        musicOn: _musicOn,
        soundOn: _soundOn,
        vibrationOn: _vibrationOn,
        selectedDifficulty: _selectedDifficulty,
      ),
    );

    if (_musicOn) {
      await audioService.ensureBackgroundMusicPlaying(forceRestart: true);
    }

    if (_soundOn) {
      await audioService.playClickSound();
    }

    if (value) {
      await hapticService.lightTap();
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/settings.bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF1E88E5).withOpacity(0.75),
              const Color(0xFF42A5F5).withOpacity(0.60),
              const Color(0xFF90CAF9).withOpacity(0.45),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text(
              'SETTINGS',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
          body: !_isLoaded
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/LOGO.png',
                          height: 230,
                          width: 230,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: 280,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.55),
                              width: 1.5,
                            ),
                          ),
                          child: TextField(
                            controller: _usernameController,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                            decoration: const InputDecoration(
                              icon: Icon(Icons.person, color: Colors.white),
                              hintText: 'Enter username',
                              hintStyle: TextStyle(color: Colors.white70),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        _SwitchTile(
                          icon: Icons.music_note,
                          label: 'Music',
                          value: _musicOn,
                          onChanged: _toggleMusic,
                        ),
                        const SizedBox(height: 14),
                        _SwitchTile(
                          icon: Icons.volume_up,
                          label: 'Sound',
                          value: _soundOn,
                          onChanged: _toggleSound,
                        ),
                        const SizedBox(height: 14),
                        _SwitchTile(
                          icon: Icons.vibration,
                          label: 'Vibration',
                          value: _vibrationOn,
                          onChanged: _toggleVibration,
                        ),
                        const SizedBox(height: 24),
                        _SettingsButton(
                          text: 'SAVE SETTINGS',
                          onPressed: _saveSettings,
                        ),
                        const SizedBox(height: 16),
                        _SettingsButton(
                          text: 'RESET GAME',
                          onPressed: _resetGame,
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(0.55),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 28, color: Colors.white),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: Colors.white30,
          ),
        ],
      ),
    );
  }
}

class _SettingsButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _SettingsButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.18),
          foregroundColor: Colors.white,
          shadowColor: Colors.black45,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: BorderSide(
              color: Colors.white.withOpacity(0.6),
              width: 1.5,
            ),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
