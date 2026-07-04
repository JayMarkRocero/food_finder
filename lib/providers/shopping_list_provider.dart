import 'package:flutter/foundation.dart';
import '../models/recipe.dart';
import '../models/shopping_item.dart';

// Builds and manages the shopping list, merging duplicate ingredients
// across multiple selected recipes into a single checkable item.
class ShoppingListProvider extends ChangeNotifier {
  final List<ShoppingItem> _items = [];

  List<ShoppingItem> get items => List.unmodifiable(_items);

  int get uncheckedCount => _items.where((i) => !i.isChecked).length;

  // Pass in the recipes the user picked (e.g. from meal planner or manually
  // selected). Ingredient strings are normalized so "2 cloves garlic" and
  // "3 cloves garlic, minced" both merge under one shopping entry.
  void generateFromRecipes(List<Recipe> recipes) {
    final Map<String, ShoppingItem> merged = {};

    for (final recipe in recipes) {
      for (final ingredient in recipe.ingredients) {
        final key = _normalize(ingredient);
        if (merged.containsKey(key)) {
          merged[key]!.fromRecipeIds.add(recipe.id);
        } else {
          merged[key] = ShoppingItem(
            id: key,
            name: ingredient,
            fromRecipeIds: [recipe.id],
          );
        }
      }
    }

    _items
      ..clear()
      ..addAll(merged.values);
    notifyListeners();
  }

  // Strips quantities/descriptors so similar ingredients merge together.
  // This is a simple heuristic, not perfect NLP — good enough for static data.
  String _normalize(String ingredient) {
    return ingredient
        .toLowerCase()
        .replaceAll(RegExp(r'^[\d/.\s]+'), '') // leading numbers/fractions
        .replaceAll(RegExp(r',.*$'), '') // trailing ", minced" etc.
        .trim();
  }

  void toggleChecked(String id) {
    final item = _items.firstWhere((i) => i.id == id);
    item.isChecked = !item.isChecked;
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((i) => i.id == id);
    notifyListeners();
  }

  void clearAll() {
    _items.clear();
    notifyListeners();
  }
}