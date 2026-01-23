import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../managers/theme_manager.dart';
import '../managers/movie_manager.dart';
import '../models/movie.dart';
import '../services/storage_service.dart';
import '../models/user_profile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _usernameController = TextEditingController();
  bool _notificationsEnabled = true;
  bool _isLoadingProfile = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await StorageService.instance.loadProfile();
    debugPrint('DEBUG: Loaded profile with username: "${profile.username}"');
    if (mounted) {
      setState(() {
        _usernameController.text = profile.username;
        _isLoadingProfile = false;
      });
    }
  }

  Future<void> _saveUsername(String value) async {
    // Only save if we've finished loading the profile
    if (!_isLoadingProfile) {
      debugPrint('DEBUG: Saving username: "$value"');
      final profile = UserProfile(username: value);
      await StorageService.instance.saveProfile(profile);
      debugPrint('DEBUG: Username saved successfully');
    } else {
      debugPrint('DEBUG: Skipping save - still loading profile');
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildListView());
  }

  ListView _buildListView() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildProfileSection(),
        const SizedBox(height: 24),
        _buildMovieStatistics(),
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 16),
        _buildPreferencesSection(),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 16),
        _buildNotificationsSection(),
        const SizedBox(height: 24),
      ],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Settings'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Profile',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _usernameController,
          onChanged: _saveUsername,
          decoration: const InputDecoration(
            labelText: 'Username',
            hintText: 'Enter your username',
            prefixIcon: Icon(Icons.person),
          ),
        ),
      ],
    );
  }

  Widget _buildMovieStatistics() {
    return Consumer<MovieManager>(
      builder: (context, movieManager, child) {
        final totalCount = movieManager.getMovieCount();
        final toWatchCount = movieManager.getMovieCountByStatus(
          MovieStatus.toWatch,
        );
        final watchedCount = movieManager.getMovieCountByStatus(
          MovieStatus.watched,
        );

        return Column(
          children: [
            _buildStatisticTile(Icons.movie, 'Total Movies', totalCount),
            _buildStatisticTile(Icons.visibility_off, 'To Watch', toWatchCount),
            _buildStatisticTile(Icons.check_circle, 'Watched', watchedCount),
          ],
        );
      },
    );
  }

  Widget _buildStatisticTile(IconData icon, String title, int count) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Text(
        count.toString(),
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildPreferencesSection() {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Preferences',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Enable dark theme'),
              secondary: const Icon(Icons.dark_mode),
              value: themeManager.isDarkMode,
              onChanged: (bool value) async {
                await themeManager.toggleTheme();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildNotificationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Notifications',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Enable Notifications'),
          subtitle: const Text('Receive notifications when adding movies'),
          secondary: const Icon(Icons.notifications),
          value: _notificationsEnabled,
          onChanged: (bool value) {
            setState(() {
              _notificationsEnabled = value;
            });
            // Placeholder - will be implemented in Phase 8
          },
        ),
      ],
    );
  }
}
