import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipe_provider.dart';
import '../providers/meal_planner_provider.dart';
import '../providers/shopping_list_provider.dart';
import '../widgets/confirmation_dialog.dart';
import 'shopping_list_screen.dart';

class MealPlannerScreen extends StatelessWidget {
  const MealPlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mealPlanner = context.watch<MealPlannerProvider>();
    final recipeProvider = context.watch<RecipeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Planner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            onPressed: () => _handleClearPlanner(context, mealPlanner),
          ),
        ],
      ),
      floatingActionButton: mealPlanner.plans.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => _generateShoppingList(context, mealPlanner, recipeProvider),
              icon: const Icon(Icons.shopping_cart_outlined),
              label: const Text('Shopping List'),
            )
          : null,
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: weekDays.length,
        itemBuilder: (context, dayIndex) {
          final day = weekDays[dayIndex];
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(day, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10),
                ...mealTypes.map((mealType) {
                  final plan = mealPlanner.planFor(day, mealType);
                  final recipe = plan != null ? recipeProvider.getById(plan.recipeId) : null;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 76,
                          child: Text(mealType, style: Theme.of(context).textTheme.bodySmall),
                        ),
                        Expanded(
                          child: Text(
                            recipe?.name ?? 'No recipe assigned',
                            style: recipe != null
                                ? Theme.of(context).textTheme.bodyMedium
                                : Theme.of(context).textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (recipe != null)
                          IconButton(
                            icon: const Icon(Icons.close, size: 18),
                            onPressed: () => mealPlanner.removeSlot(day, mealType),
                          ),
                        TextButton(
                          onPressed: () => _showRecipePicker(context, day, mealType, mealPlanner, recipeProvider),
                          child: Text(recipe != null ? 'Change' : 'Add'),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showRecipePicker(
    BuildContext context,
    String day,
    String mealType,
    MealPlannerProvider mealPlanner,
    RecipeProvider recipeProvider,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Choose a recipe for $mealType', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: recipeProvider.recipes.length,
                      itemBuilder: (context, index) {
                        final recipe = recipeProvider.recipes[index];
                        return ListTile(
                          title: Text(recipe.name),
                          subtitle: Text(recipe.categories.join(', ')),
                          onTap: () {
                            mealPlanner.assignRecipe(day, mealType, recipe.id);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _handleClearPlanner(BuildContext context, MealPlannerProvider mealPlanner) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Clear Meal Planner?',
      message: 'This will remove all scheduled meals for the week.',
      confirmLabel: 'Clear',
      isDestructive: true,
    );
    if (confirmed) mealPlanner.clearPlanner();
  }

  void _generateShoppingList(
    BuildContext context,
    MealPlannerProvider mealPlanner,
    RecipeProvider recipeProvider,
  ) {
    final recipes = mealPlanner.scheduledRecipeIds
        .map((id) => recipeProvider.getById(id))
        .whereType<dynamic>()
        .toList();

    context.read<ShoppingListProvider>().generateFromRecipes(recipes.cast());

    Navigator.push(context, MaterialPageRoute(builder: (_) => const ShoppingListScreen()));
  }
}