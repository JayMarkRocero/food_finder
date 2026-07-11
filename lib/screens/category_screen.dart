import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipe_provider.dart';
import '../data/categories_data.dart';
import '../widgets/category_card.dart';
import '../widgets/recipe_tile.dart';
import '../widgets/empty_widget.dart';
import 'recipe_detail_screen.dart';

// Shows either the full category grid (no initialCategory) or a single
// category's recipe list (initialCategory provided) — one screen, two modes,
// similar to how AddEditRecipeScreen handles create vs edit.
class CategoryScreen extends StatefulWidget {
  final String? initialCategory;

  const CategoryScreen({super.key, this.initialCategory});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
  }

  @override
  Widget build(BuildContext context) {
    final recipeProvider = context.watch<RecipeProvider>();

    if (_selectedCategory != null) {
      final recipes = recipeProvider.getByCategory(_selectedCategory!);
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => setState(() => _selectedCategory = null),
          ),
          title: Text(_selectedCategory!),
        ),
        body: recipes.isEmpty
            ? const EmptyWidget(
                title: 'No recipes yet',
                subtitle: 'This category is empty for now.',
                icon: Icons.category_outlined,
              )
            : ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
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

    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.95,
        ),
        itemCount: categoriesData.length,
        itemBuilder: (context, index) {
          final category = categoriesData[index];
          final count = recipeProvider.getByCategory(category.name).length;
          return CategoryCard(
            category: category,
            recipeCount: count,
            onTap: () => setState(() => _selectedCategory = category.name),
          );
        },
      ),
    );
  }
}