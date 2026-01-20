import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movie_watchlist_app/managers/movie_manager.dart';
import 'package:movie_watchlist_app/screens/home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final movieManager = MovieManager();
        movieManager
            .loadMockData(); // Loading mock data for testing UI and widget for visual representation
        return movieManager;
      },
      child: MaterialApp(
        title: 'Movie Watchlist',
        theme: ThemeData(
          //setting genre color temporary for now
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
        ),
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}
