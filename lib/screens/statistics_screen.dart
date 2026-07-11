import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipe_provider.dart';
import '../providers/favorite_provider.dart';
import '../providers/statistics_provider.dart';
import '../widgets/statistic_card.dart';
import '../constants/app_colors.dart';

// Full Statistics + Nutrition Dashboard — reachable from Settings.
// All numbers here are computed live via StatisticsProvider, never stored.
class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recipeProvider = context.watch<RecipeProvider>();
    final favoriteProvider = context.watch<FavoriteProvider>();
    final stats = context.read<StatisticsProvider>();
    final theme = Theme.of(context);

    final recipes = recipeProvider.recipes;
    final highestRated = stats.highestRated(recipes);
    final lowestCalorie = stats.lowestCalorie(recipes);

    return Scaffold(
      appBar: AppBar(title: const Text('Statistics & Nutrition')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Overview', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
            children: [
              StatisticCard(
                label: 'Total Recipes',
                value: '${stats.totalRecipes(recipes)}',
                icon: Icons.menu_book,
                color: AppColors.primaryGreen,
              ),
              StatisticCard(
                label: 'Favorites',
                value: '${stats.favoriteCount(favoriteProvider.favoriteIds)}',
                icon: Icons.favorite,
                color: AppColors.secondaryOrange,
              ),
              StatisticCard(
                label: 'Average Rating',
                value: stats.averageRating(recipes).toStringAsFixed(1),
                icon: Icons.star,
                color: AppColors.ratingGold,
              ),
              StatisticCard(
                label: 'Top Category',
                value: stats.mostPopularCategory(recipes),
                icon: Icons.category,
                color: AppColors.lightGreen,
              ),
            ],
          ),
          const SizedBox(height: 24),

          Text('Highlights', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          if (highestRated != null)
            _highlightTile(context, 'Highest Rated', highestRated.name,
                '${highestRated.rating} ★', AppColors.ratingGold, Icons.star),
          if (lowestCalorie != null) ...[
            const SizedBox(height: 10),
            _highlightTile(context, 'Lowest Calories', lowestCalorie.name,
                '${lowestCalorie.calories} kcal', AppColors.primaryGreen, Icons.local_fire_department),
          ],
          const SizedBox(height: 24),

          Text('Nutrition Dashboard (Avg. per recipe)', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
            children: [
              StatisticCard(
                label: 'Total Calories',
                value: '${stats.totalCalories(recipes)}',
                icon: Icons.local_fire_department,
                color: AppColors.secondaryOrange,
              ),
              StatisticCard(
                label: 'Avg Calories',
                value: stats.averageCalories(recipes).toStringAsFixed(0),
                icon: Icons.local_fire_department_outlined,
                color: AppColors.warning,
              ),
              StatisticCard(
                label: 'Avg Protein (g)',
                value: stats.averageProtein(recipes).toStringAsFixed(1),
                icon: Icons.fitness_center,
                color: AppColors.primaryGreen,
              ),
              StatisticCard(
                label: 'Avg Carbs (g)',
                value: stats.averageCarbs(recipes).toStringAsFixed(1),
                icon: Icons.rice_bowl,
                color: AppColors.mediumBadge,
              ),
              StatisticCard(
                label: 'Avg Fat (g)',
                value: stats.averageFat(recipes).toStringAsFixed(1),
                icon: Icons.opacity,
                color: AppColors.error,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _highlightTile(
    BuildContext context,
    String label,
    String recipeName,
    String value,
    Color color,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.bodySmall),
                Text(recipeName, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          Text(value, style: theme.textTheme.titleMedium?.copyWith(color: color, fontSize: 14)),
        ],
      ),
    );
  }
}