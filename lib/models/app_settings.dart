class AppSettings {
  final bool musicOn;
  final bool soundOn;
  final bool vibrationOn;
  final String selectedDifficulty;

  const AppSettings({
    required this.musicOn,
    required this.soundOn,
    required this.vibrationOn,
    required this.selectedDifficulty,
  });

  Map<String, dynamic> toMap() {
    return {
      'musicOn': musicOn,
      'soundOn': soundOn,
      'vibrationOn': vibrationOn,
      'selectedDifficulty': selectedDifficulty,
    };
  }

  factory AppSettings.fromMap(Map<dynamic, dynamic> map) {
    return AppSettings(
      musicOn: map['musicOn'] ?? true,
      soundOn: map['soundOn'] ?? true,
      vibrationOn: map['vibrationOn'] ?? true,
      selectedDifficulty: map['selectedDifficulty']?.toString() ?? 'medium',
    );
  }
}
