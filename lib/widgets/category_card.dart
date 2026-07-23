import 'package:flutter/material.dart';
import '../models/category.dart' as model;

// Icon mapping helper — converts our stored icon string key into a real
// Material IconData. Keeping this as a lookup keeps categories_data.dart
// as pure static data (no Flutter imports needed there).
IconData iconForKey(String key) {
  const map = {
    'breakfast_dining': Icons.breakfast_dining,
    'lunch_dining': Icons.lunch_dining,
    'dinner_dining': Icons.dinner_dining,
    'cake': Icons.cake,
    'cookie': Icons.cookie,
    'eco': Icons.eco,
    'grass': Icons.grass,
    'egg': Icons.egg,
    'kebab_dining': Icons.kebab_dining,
    'set_meal': Icons.set_meal,
    'rice_bowl': Icons.rice_bowl,
    'soup_kitchen': Icons.soup_kitchen,
    'ramen_dining': Icons.ramen_dining,
    'local_bar': Icons.local_bar,
    'flag': Icons.flag,
    'local_pizza': Icons.local_pizza,
    'fastfood': Icons.fastfood,
    'restaurant': Icons.restaurant,
  };
  return map[key] ?? Icons.restaurant_menu;
}

// Used in the grid on the Categories screen and the horizontal "Quick
// Categories" row on Home.
class CategoryCard extends StatelessWidget {
  final model.Category category;
  final int recipeCount;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.recipeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(category.colorValue);
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Icon(iconForKey(category.icon), color: Colors.white, size: 22),
            ),
            const SizedBox(height: 10),
            Text(category.name,
                style: theme.textTheme.titleMedium?.copyWith(fontSize: 14)),
            const SizedBox(height: 2),
            Text('$recipeCount recipes', style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}