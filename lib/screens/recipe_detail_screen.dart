import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipe_provider.dart';
import '../constants/app_colors.dart';
import '../widgets/favorite_button.dart';
import '../widgets/nutrition_card.dart';
import '../widgets/recipe_card.dart';
import '../widgets/confirmation_dialog.dart';
import 'add_edit_recipe_screen.dart';
import '../utils/recipe_image.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String recipeId;

  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  // Tracks which ingredient indices are checked off — local UI state only,
  // used for the "Ingredient Checklist" feature while cooking.
  final Set<int> _checkedIngredients = {};

  @override
  void initState() {
    super.initState();
    // Mark as viewed right when the screen opens, not on every rebuild.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RecipeProvider>().markAsViewed(widget.recipeId);
    });
  }

  Color _difficultyColor(String difficulty) {
    switch (difficulty) {
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
    final recipeProvider = context.watch<RecipeProvider>();
    final recipe = recipeProvider.getById(widget.recipeId);
    final theme = Theme.of(context);

    if (recipe == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Recipe not found.')),
      );
    }

    final related = recipeProvider.relatedTo(recipe);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ---------- Hero image + app bar ----------
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddEditRecipeScreen(existingRecipe: recipe)),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _handleDelete(context, recipe),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'recipe_${recipe.id}',
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      recipe.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.primaryGreen, AppColors.lightGreen],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Center(
                          child: Icon(Icons.restaurant_menu, color: Colors.white, size: 80),
                        ),
                      ),
                    ),
                    // Subtle bottom scrim so the back button and collapsed
                    // title stay legible over any photo.
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.black.withValues(alpha: 0.35), Colors.transparent],
                            begin: Alignment.bottomCenter,
                            end: Alignment.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ---------- Content ----------
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + favorite + share/print
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(recipe.name, style: theme.textTheme.headlineSmall),
                      ),
                      FavoriteButton(recipeId: recipe.id, size: 26),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Category + difficulty badges
                  // Category + difficulty badges
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...recipe.categories.map((c) => _badge(c, AppColors.primaryGreen)),
                      _badge(recipe.difficulty, _difficultyColor(recipe.difficulty)),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Text(recipe.description, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 16),

                  // Rating + share + print row
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppColors.ratingGold, size: 18),
                      const SizedBox(width: 4),
                      Text('${recipe.rating} (${recipe.reviewCount} reviews)',
                          style: theme.textTheme.bodyMedium),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.share_outlined),
                        onPressed: () => _simulate(context, 'Sharing recipe...'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.print_outlined),
                        onPressed: () => _simulate(context, 'Preparing to print...'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Cooking info row
                  _cookingInfoRow(context, recipe),
                  const SizedBox(height: 20),

                  NutritionCard(recipe: recipe),
                  const SizedBox(height: 24),

                  // Ingredients checklist
                  Text('Ingredients', style: theme.textTheme.titleLarge?.copyWith(fontSize: 18)),
                  const SizedBox(height: 10),
                  ...List.generate(recipe.ingredients.length, (i) {
                    final checked = _checkedIngredients.contains(i);
                    return CheckboxListTile(
                      value: checked,
                      onChanged: (_) => setState(() {
                        checked ? _checkedIngredients.remove(i) : _checkedIngredients.add(i);
                      }),
                      title: Text(
                        recipe.ingredients[i],
                        style: TextStyle(
                          decoration: checked ? TextDecoration.lineThrough : null,
                          color: checked ? theme.textTheme.bodySmall?.color : null,
                        ),
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      activeColor: AppColors.primaryGreen,
                    );
                  }),
                  const SizedBox(height: 12),

                  // Steps
                  Text('Cooking Steps', style: theme.textTheme.titleLarge?.copyWith(fontSize: 18)),
                  const SizedBox(height: 10),
                  ...List.generate(recipe.steps.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: AppColors.primaryGreen,
                            child: Text('${i + 1}',
                                style: const TextStyle(color: Colors.white, fontSize: 12)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Text(recipe.steps[i], style: theme.textTheme.bodyMedium)),
                        ],
                      ),
                    );
                  }),

                  // Tips
                  if (recipe.tips.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text('Cooking Tips', style: theme.textTheme.titleLarge?.copyWith(fontSize: 18)),
                    const SizedBox(height: 10),
                    ...recipe.tips.map((tip) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.lightbulb_outline,
                                  color: AppColors.secondaryOrange, size: 18),
                              const SizedBox(width: 10),
                              Expanded(child: Text(tip, style: theme.textTheme.bodyMedium)),
                            ],
                          ),
                        )),
                  ],
                  const SizedBox(height: 20),

                  // Author / dates
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: theme.cardTheme.color,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoRow(context, 'Author', recipe.author),
                        _infoRow(context, 'Created', _formatDate(recipe.dateCreated)),
                        _infoRow(context, 'Updated', _formatDate(recipe.dateUpdated)),
                      ],
                    ),
                  ),

                  // Related recipes
                  if (related.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text('Related Recipes', style: theme.textTheme.titleLarge?.copyWith(fontSize: 18)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 210,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: related.length,
                        itemBuilder: (context, index) {
                          final r = related[index];
                          return RecipeCard(
                            recipe: r,
                            onTap: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipeId: r.id)),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(50)),
      child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12)),
    );
  }

  Widget _cookingInfoRow(BuildContext context, recipe) {
    final theme = Theme.of(context);
    Widget item(IconData icon, String label, String value) {
      return Expanded(
        child: Column(
          children: [
            Icon(icon, color: AppColors.primaryGreen, size: 22),
            const SizedBox(height: 6),
            Text(value, style: theme.textTheme.titleMedium?.copyWith(fontSize: 14)),
            Text(label, style: theme.textTheme.bodySmall?.copyWith(fontSize: 11)),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          item(Icons.timer_outlined, 'Prep', '${recipe.preparationTime}m'),
          item(Icons.local_fire_department_outlined, 'Cook', '${recipe.cookingTime}m'),
          item(Icons.access_time, 'Total', '${recipe.totalTime}m'),
          item(Icons.people_outline, 'Serves', '${recipe.servings}'),
        ],
      ),
    );
  }

  Widget _infoRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodySmall),
          Text(value, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _simulate(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _handleDelete(BuildContext context, recipe) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Delete Recipe?',
      message: 'Are you sure you want to delete "${recipe.name}"? This cannot be undone unless you tap Undo.',
      confirmLabel: 'Delete',
      isDestructive: true,
    );
    if (!confirmed || !context.mounted) return;

    final recipeProvider = context.read<RecipeProvider>();
    final index = recipeProvider.recipes.indexWhere((r) => r.id == recipe.id);
    final removed = recipeProvider.deleteRecipe(recipe.id);

    if (removed != null && context.mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"${removed.name}" deleted'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () => recipeProvider.restoreRecipe(removed, index),
          ),
        ),
      );
    }
  }
}