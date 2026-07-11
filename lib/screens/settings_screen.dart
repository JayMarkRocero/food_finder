import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../constants/app_colors.dart';
import 'statistics_screen.dart';
import 'about_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Appearance', style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: SwitchListTile(
              value: themeProvider.isDarkMode,
              onChanged: (_) => themeProvider.toggleTheme(),
              title: const Text('Dark Mode'),
              subtitle: Text(themeProvider.isDarkMode ? 'Enabled' : 'Disabled'),
              activeThumbColor: AppColors.primaryGreen,
              secondary: Icon(
                themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              ),
            ),
          ),
          const SizedBox(height: 24),

          Text('Insights', style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          _settingsTile(
            context,
            icon: Icons.bar_chart,
            label: 'Statistics & Nutrition Dashboard',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const StatisticsScreen()),
            ),
          ),
          const SizedBox(height: 24),

          Text('About', style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          _settingsTile(
            context,
            icon: Icons.info_outline,
            label: 'About This App',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AboutScreen()),
            ),
          ),
          const SizedBox(height: 8),
          _settingsTile(
            context,
            icon: Icons.privacy_tip_outlined,
            label: 'Privacy Policy',
            onTap: () => _showSimpleInfoDialog(
              context,
              'Privacy Policy',
              'Recipe Finder works fully offline. All your recipes, favorites, meal plans, '
                  'and shopping lists are stored only in memory on your device for the current '
                  'session and are never sent anywhere.',
            ),
          ),
          const SizedBox(height: 8),
          _settingsTile(
            context,
            icon: Icons.description_outlined,
            label: 'Terms of Use',
            onTap: () => _showSimpleInfoDialog(
              context,
              'Terms of Use',
              'Recipe Finder is provided as-is for personal, non-commercial use. '
                  'Recipes are for informational purposes only.',
            ),
          ),
          const SizedBox(height: 24),

          Center(
            child: Text('Version 1.0.0', style: theme.textTheme.bodySmall),
          ),
        ],
      ),
    );
  }

  Widget _settingsTile(BuildContext context,
      {required IconData icon, required String label, required VoidCallback onTap}) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primaryGreen),
        title: Text(label),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _showSimpleInfoDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }
}