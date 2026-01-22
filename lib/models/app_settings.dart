class AppSettings {
  final bool isDarkMode;
  final bool notificationsEnabled;

  AppSettings({required this.isDarkMode, required this.notificationsEnabled});

  // Convert AppSettings to JSON
  Map<String, dynamic> toJson() {
    return {
      'isDarkMode': isDarkMode,
      'notificationsEnabled': notificationsEnabled,
    };
  }

  // Create AppSettings from JSON
  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      isDarkMode: json['isDarkMode'] as bool? ?? false,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
    );
  }

  // Create a copy with updated fields
  AppSettings copyWith({bool? isDarkMode, bool? notificationsEnabled}) {
    return AppSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  // Default settings
  factory AppSettings.defaultSettings() {
    return AppSettings(isDarkMode: false, notificationsEnabled: true);
  }
}
