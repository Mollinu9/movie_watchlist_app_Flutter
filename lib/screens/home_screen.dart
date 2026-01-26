import 'package:flutter/material.dart';
import 'package:movie_watchlist_app/screens/movie_forms_screen.dart';
import 'package:provider/provider.dart';
import 'package:movie_watchlist_app/managers/movie_manager.dart';
import 'package:movie_watchlist_app/models/movie.dart';
import 'package:movie_watchlist_app/widgets/movie_card.dart';
import 'package:movie_watchlist_app/screens/movie_detail_screen.dart';
import 'package:movie_watchlist_app/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movieManager = context.watch<MovieManager>();

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Watchlist')),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'To Watch'),
            Tab(text: 'Watched'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMovieGrid(movieManager.getAllMovies()),
          _buildMovieGrid(movieManager.getMoviesByStatus(MovieStatus.toWatch)),
          _buildMovieGrid(movieManager.getMoviesByStatus(MovieStatus.watched)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const MovieFormsScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMovieGrid(List<dynamic> movies) {
    if (movies.isEmpty) {
      return const Center(
        child: Text(
          'No movie found',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return _KeepAliveGrid(movies: movies);
  }
}

// Separate widget to keep grid alive when switching tabs
class _KeepAliveGrid extends StatefulWidget {
  final List<dynamic> movies;

  const _KeepAliveGrid({required this.movies});

  @override
  State<_KeepAliveGrid> createState() => _KeepAliveGridState();
}

class _KeepAliveGridState extends State<_KeepAliveGrid>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: widget.movies.length,
      itemBuilder: (context, index) {
        final movie = widget.movies[index];
        return MovieCard(
          key: ValueKey(movie.id), // Add key for better widget reuse
          movie: movie,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MovieDetailScreen(movie: movie),
              ),
            );
          },
        );
      },
    );
  }
}
