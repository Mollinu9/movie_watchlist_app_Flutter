import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:movie_watchlist_app/services/storage_service.dart';
import 'dart:io' show Platform;

/// Service for handling local push notifications
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static bool _isInitialized = false;

  /// Initialize the notification service
  static Future<void> initialize() async {
    if (_isInitialized) return;

    // Android initialization settings
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        );

    // Windows initialization settings
    const WindowsInitializationSettings windowsSettings =
        WindowsInitializationSettings(
          appName: 'Movie Watchlist',
          appUserModelId: 'com.example.movieWatchlistApp',
          guid: 'a8c49d5e-8c3f-4e5a-9b2d-1f3e4d5c6b7a',
        );

    // Combined initialization settings
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: androidSettings,
          iOS: iosSettings,
          windows: windowsSettings,
        );

    // Initialize the plugin
    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
      },
    );

    _isInitialized = true;
  }

  /// Request notification permissions from the user
  static Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      // Request permissions for Android 13+ (API level 33+)
      final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
          _notificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      if (androidPlugin != null) {
        final bool? granted = await androidPlugin
            .requestNotificationsPermission();
        return granted ?? true;
      }
    } else if (Platform.isIOS) {
      // Request permissions for iOS
      final IOSFlutterLocalNotificationsPlugin? iosPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();

      if (iosPlugin != null) {
        final bool? granted = await iosPlugin.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        return granted ?? false;
      }
    }

    return true; // Default to true for other platforms
  }

  /// Show a notification when a movie is added
  static Future<void> showMovieAddedNotification(String movieTitle) async {
    await _showMovieNotification(
      movieTitle,
      'Movie Added',
      'Successfully added "$movieTitle" to your watchlist',
    );
  }

  /// Show a notification when a movie is edited
  static Future<void> showMovieEditedNotification(String movieTitle) async {
    await _showMovieNotification(
      movieTitle,
      'Movie Updated',
      'Successfully updated "$movieTitle"',
    );
  }

  /// Internal method to show movie notifications
  static Future<void> _showMovieNotification(
    String movieTitle,
    String title,
    String body,
  ) async {
    // Check if notifications are enabled in settings
    if (!await isEnabled()) {
      return;
    }

    // Notification details for Android
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'movie_watchlist_channel',
          'Movie Watchlist',
          channelDescription: 'Notifications for movie additions and updates',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        );

    // Notification details for iOS
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    // Notification details for Windows
    const WindowsNotificationDetails windowsDetails =
        WindowsNotificationDetails();

    // Combined notification details
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      windows: windowsDetails,
    );

    // Show the notification
    await _notificationsPlugin.show(
      0, // Notification ID
      title,
      body,
      notificationDetails,
    );
  }

  /// Check if notifications are enabled in app settings
  static Future<bool> isEnabled() async {
    final settings = await StorageService.instance.loadSettings();
    return settings.notificationsEnabled;
  }
}
