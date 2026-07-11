import 'package:flutter/foundation.dart';
import '../models/recipe.dart';

// Computes derived stats from the current recipe + favorites state.
// This provider holds no state of its own — it's pure calculation,
// kept separate so the Statistics/Dashboard UI has one clean place to watch.
class StatisticsProvider extends ChangeNotifier {
  int totalRecipes(List<Recipe> recipes) => recipes.length;

  int favoriteCount(Set<String> favoriteIds) => favoriteIds.length;

  Recipe? highestRated(List<Recipe> recipes) {
    if (recipes.isEmpty) return null;
    return recipes.reduce((a, b) => a.rating >= b.rating ? a : b);
  }

  Recipe? lowestCalorie(List<Recipe> recipes) {
    if (recipes.isEmpty) return null;
    return recipes.reduce((a, b) => a.calories <= b.calories ? a : b);
  }

  String mostPopularCategory(List<Recipe> recipes) {
    if (recipes.isEmpty) return '-';
    final counts = <String, int>{};
    for (final r in recipes) {
      for (final c in r.categories) {
        counts[c] = (counts[c] ?? 0) + 1;
      }
    }
    if (counts.isEmpty) return '-';
    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  List<Recipe> recentlyAdded(List<Recipe> recipes, {int limit = 5}) {
    final sorted = List<Recipe>.from(recipes)
      ..sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
    return sorted.take(limit).toList();
  }

  double averageRating(List<Recipe> recipes) {
    if (recipes.isEmpty) return 0;
    final total = recipes.fold<double>(0, (sum, r) => sum + r.rating);
    return total / recipes.length;
  }

  double averageCalories(List<Recipe> recipes) {
    if (recipes.isEmpty) return 0;
    final total = recipes.fold<int>(0, (sum, r) => sum + r.calories);
    return total / recipes.length;
  }

  double averageProtein(List<Recipe> recipes) {
    if (recipes.isEmpty) return 0;
    final total = recipes.fold<double>(0, (sum, r) => sum + r.protein);
    return total / recipes.length;
  }

  double averageFat(List<Recipe> recipes) {
    if (recipes.isEmpty) return 0;
    final total = recipes.fold<double>(0, (sum, r) => sum + r.fat);
    return total / recipes.length;
  }

  double averageCarbs(List<Recipe> recipes) {
    if (recipes.isEmpty) return 0;
    final total = recipes.fold<double>(0, (sum, r) => sum + r.carbohydrates);
    return total / recipes.length;
  }

  int totalCalories(List<Recipe> recipes) =>
      recipes.fold<int>(0, (sum, r) => sum + r.calories);
}