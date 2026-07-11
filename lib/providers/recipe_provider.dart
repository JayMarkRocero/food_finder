import 'package:flutter/foundation.dart';
import '../models/recipe.dart';
import '../data/recipes_data.dart';

// Manages the master list of recipes: CRUD, recently viewed, and lookups.
// This is the single source of truth for recipe data across the app.
class RecipeProvider extends ChangeNotifier {
  // Start with a mutable copy of the static data so we can add/edit/delete
  // during runtime without touching the original const-like source list.
  final List<Recipe> _recipes = List<Recipe>.from(recipesData);

  // Tracks IDs of recently viewed recipes, most recent first.
  final List<String> _recentlyViewedIds = [];

  List<Recipe> get recipes => List.unmodifiable(_recipes);

  List<Recipe> get recentlyViewed => _recentlyViewedIds
      .map((id) => getById(id))
      .whereType<Recipe>()
      .toList();

  Recipe? getById(String id) {
    try {
      return _recipes.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Recipe> getByCategory(String category) {
    return _recipes.where((r) => r.categories.contains(category)).toList();
  }

  List<Recipe> get recommended => _recipes.where((r) => r.recommended).toList();

  List<Recipe> get highestRated {
    final sorted = List<Recipe>.from(_recipes)
      ..sort((a, b) => b.rating.compareTo(a.rating));
    return sorted;
  }

  List<Recipe> get newest {
    final sorted = List<Recipe>.from(_recipes)
      ..sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
    return sorted;
  }

  List<Recipe> get healthyChoices =>
      _recipes.where((r) => r.categories.contains('Healthy') || r.calories < 300).toList();

  // Call this whenever a user opens a recipe detail screen.
  void markAsViewed(String id) {
    _recentlyViewedIds.remove(id); // avoid duplicates
    _recentlyViewedIds.insert(0, id);
    if (_recentlyViewedIds.length > 10) {
      _recentlyViewedIds.removeLast();
    }
    notifyListeners();
  }

  Recipe randomRecipe() {
    final index = (DateTime.now().millisecondsSinceEpoch % _recipes.length);
    return _recipes[index];
  }

  Recipe recipeOfTheDay() {
    // Deterministic "random" based on the day, so it stays the same all day.
    final dayIndex = DateTime.now().day % _recipes.length;
    return _recipes[dayIndex];
  }

  // ---------- CRUD ----------

  bool nameExists(String name, {String? excludingId}) {
    return _recipes.any((r) =>
        r.name.toLowerCase() == name.toLowerCase() && r.id != excludingId);
  }

  void addRecipe(Recipe recipe) {
    _recipes.add(recipe);
    notifyListeners();
  }

  void updateRecipe(Recipe updated) {
    final index = _recipes.indexWhere((r) => r.id == updated.id);
    if (index != -1) {
      _recipes[index] = updated;
      notifyListeners();
    }
  }

  // Removes the recipe and returns it, so the caller can offer "Undo".
  Recipe? deleteRecipe(String id) {
    final index = _recipes.indexWhere((r) => r.id == id);
    if (index == -1) return null;
    final removed = _recipes.removeAt(index);
    notifyListeners();
    return removed;
  }

  // Used by the Undo SnackBar to restore a deleted recipe at its original spot.
  void restoreRecipe(Recipe recipe, int index) {
    final safeIndex = index.clamp(0, _recipes.length);
    _recipes.insert(safeIndex, recipe);
    notifyListeners();
  }

  List<Recipe> relatedTo(Recipe recipe) {
    return _recipes
        .where((r) => r.id != recipe.id && r.categories.any((c) => recipe.categories.contains(c)))
        .take(6)
        .toList();
  }
}