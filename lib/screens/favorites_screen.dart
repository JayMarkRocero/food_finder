import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipe_provider.dart';
import '../providers/favorite_provider.dart';
import '../widgets/recipe_tile.dart';
import '../widgets/empty_widget.dart';
import '../widgets/confirmation_dialog.dart';
import 'recipe_detail_screen.dart';
import 'main_shell.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recipeProvider = context.watch<RecipeProvider>();
    final favoriteProvider = context.watch<FavoriteProvider>();

    final favoriteRecipes = recipeProvider.recipes
        .where((r) => favoriteProvider.isFavorite(r.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites (${favoriteProvider.count})'),
        actions: [
          if (favoriteRecipes.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              onPressed: () => _handleClearAll(context, favoriteProvider),
            ),
        ],
      ),
      body: favoriteRecipes.isEmpty
          ? EmptyWidget(
              title: 'No favorites yet',
              subtitle: 'Tap the heart icon on any recipe to save it here.',
              icon: Icons.favorite_border,
              action: OutlinedButton(
                onPressed: () {
                  // Navigating back to the shell root resets to Home tab.
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('Browse Recipes'),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: favoriteRecipes.length,
              itemBuilder: (context, index) {
                final recipe = favoriteRecipes[index];
                return RecipeTile(
                  recipe: recipe,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipeId: recipe.id)),
                  ),
                );
              },
            ),
    );
  }

  Future<void> _handleClearAll(BuildContext context, FavoriteProvider favoriteProvider) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Clear All Favorites?',
      message: 'This will remove all recipes from your favorites list.',
      confirmLabel: 'Clear All',
      isDestructive: true,
    );
    if (confirmed) favoriteProvider.clearAll();
  }
}