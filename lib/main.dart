import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movie_watchlist_app/managers/movie_manager.dart';
import 'package:movie_watchlist_app/managers/theme_manager.dart';
import 'package:movie_watchlist_app/screens/home_screen.dart';
import 'package:movie_watchlist_app/services/storage_service.dart';
import 'package:movie_watchlist_app/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize StorageService before running the app
  await StorageService.initialize();

  // Initialize NotificationService
  await NotificationService.initialize();

  // Request notification permissions on first launch
  await NotificationService.requestPermissions();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            final movieManager = MovieManager();
            // Initialize MovieManager to load movies from storage
            movieManager.initialize();
            return movieManager;
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            final themeManager = ThemeManager();
            // Initialize ThemeManager to load settings from storage
            themeManager.initialize();
            return themeManager;
          },
        ),
      ],
      child: Consumer<ThemeManager>(
        builder: (context, themeManager, child) {
          return MaterialApp(
            title: 'Movie Watchlist',
            theme: themeManager.getCurrentTheme(),
            debugShowCheckedModeBanner: false,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
