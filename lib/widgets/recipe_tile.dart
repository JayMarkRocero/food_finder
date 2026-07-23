import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../constants/app_colors.dart';
import 'favorite_button.dart';

// A horizontal list-style tile used in search results, category listings,
// and favorites — more compact than RecipeCard, good for long scrolling lists.
class RecipeTile extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;

  const RecipeTile({super.key, required this.recipe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Hero(
              tag: 'recipe_tile_${recipe.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  recipe.imageUrl,
                  width: 76,
                  height: 76,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryGreen.withValues(alpha: 0.85),
                          AppColors.lightGreen.withValues(alpha: 0.65),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Icon(Icons.restaurant, color: Colors.white, size: 28),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    recipe.categories.join(', '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppColors.ratingGold, size: 14),
                      const SizedBox(width: 3),
                      Text(recipe.rating.toStringAsFixed(1), style: theme.textTheme.bodySmall),
                      const SizedBox(width: 10),
                      Icon(Icons.local_fire_department, size: 14, color: theme.textTheme.bodySmall?.color),
                      const SizedBox(width: 3),
                      Text('${recipe.calories} cal', style: theme.textTheme.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
            FavoriteButton(recipeId: recipe.id, size: 20),
          ],
        ),
      ),
    );
  }
}