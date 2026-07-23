import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../constants/app_colors.dart';

// Displays a recipe's nutrition breakdown in a clean grid of stat chips.
// Used on the Detail screen.
class NutritionCard extends StatelessWidget {
  final Recipe recipe;

  const NutritionCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final stats = [
      _NutritionStat('Calories', '${recipe.calories}', 'kcal', AppColors.secondaryOrange),
      _NutritionStat('Protein', recipe.protein.toStringAsFixed(0), 'g', AppColors.primaryGreen),
      _NutritionStat('Carbs', recipe.carbohydrates.toStringAsFixed(0), 'g', AppColors.warning),
      _NutritionStat('Fat', recipe.fat.toStringAsFixed(0), 'g', AppColors.error),
      _NutritionStat('Fiber', recipe.fiber.toStringAsFixed(0), 'g', AppColors.lightGreen),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nutrition Facts', style: theme.textTheme.titleMedium),
          const SizedBox(height: 14),
          Row(
            children: stats
                .map((s) => Expanded(child: _buildStat(context, s)))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(BuildContext context, _NutritionStat stat) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: stat.color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              stat.value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: stat.color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(stat.unit, style: theme.textTheme.bodySmall?.copyWith(fontSize: 10)),
        Text(stat.label, style: theme.textTheme.bodySmall?.copyWith(fontSize: 11)),
      ],
    );
  }
}

class _NutritionStat {
  final String label;
  final String value;
  final String unit;
  final Color color;
  _NutritionStat(this.label, this.value, this.unit, this.color);
}