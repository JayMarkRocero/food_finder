import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../constants/app_colors.dart';
import 'favorite_button.dart';

// The main recipe card used in horizontal carousels (Featured, Trending,
// Recommended, etc. on the Home screen). Image on top, info below.
class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;
  final double width;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.onTap,
    this.width = 190,
  });

  Color _difficultyColor() {
    switch (recipe.difficulty) {
      case 'Easy':
        return AppColors.easyBadge;
      case 'Medium':
        return AppColors.mediumBadge;
      default:
        return AppColors.hardBadge;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image area — uses a gradient + icon placeholder since we have
            // no real asset images. Swap this Container for Image.asset(...)
            // later if you add real photos to assets/images/.
            Hero(
              tag: 'recipe_${recipe.id}',
              child: Stack(
                children: [
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(20)),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryGreen.withOpacity(0.85),
                          AppColors.lightGreen.withOpacity(0.65),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Center(
                      child: Icon(Icons.restaurant_menu,
                          color: Colors.white, size: 40),
                    ),
                  ),
                  Positioned(top: 8, right: 8, child: FavoriteButton(recipeId: recipe.id)),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _difficultyColor(),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        recipe.difficulty,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppColors.ratingGold, size: 14),
                      const SizedBox(width: 3),
                      Text(recipe.rating.toStringAsFixed(1),
                          style: theme.textTheme.bodySmall?.copyWith(fontSize: 12)),
                      const SizedBox(width: 10),
                      Icon(Icons.access_time, size: 14, color: theme.textTheme.bodySmall?.color),
                      const SizedBox(width: 3),
                      Text('${recipe.totalTime}m',
                          style: theme.textTheme.bodySmall?.copyWith(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}