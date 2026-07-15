import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppColors.primaryGreen, AppColors.lightGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(Icons.restaurant_menu, color: Colors.white, size: 44),
            ),
          ),
          const SizedBox(height: 16),
          Center(child: Text('Recipe Finder', style: theme.textTheme.headlineSmall)),
          const SizedBox(height: 4),
          Center(
            child: Text('Discover, cook, and plan your meals.',
                style: theme.textTheme.bodyMedium),
          ),
          const SizedBox(height: 28),

          _infoCard(context, [
            _infoRow(context, 'Version', '1.0.0'),
            _infoRow(context, 'Flutter', '3.x'),
            _infoRow(context, 'Dart', '3.x'),
            _infoRow(context, 'Developer', 'Me, My Self, and I'),
          ]),
          const SizedBox(height: 24),

          Text(
            'Recipe Finder is a fully offline recipe companion app. Browse dozens of '
            'hand-picked recipes across cuisines, save your favorites, plan your week, '
            'generate shopping lists automatically, and track nutrition (eme lang to track nutrition) — all without '
            'needing an internet connection.',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _infoCard(BuildContext context, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  Widget _infoRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodySmall),
          Text(value, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}