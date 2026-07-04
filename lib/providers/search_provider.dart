import 'package:flutter/foundation.dart';
import '../models/recipe.dart';

enum SortOption {
  newest,
  oldest,
  highestRated,
  lowestCalories,
  preparationTime,
  cookingTime,
  alphabetical,
}

// Handles search text, active filters, sorting, and search history.
// Screens call `apply()` with the full recipe list and get back a filtered,
// sorted result — this provider never stores recipes itself.
class SearchProvider extends ChangeNotifier {
  String _query = '';
  String? _categoryFilter;
  String? _difficultyFilter;
  bool _favoritesOnly = false;
  bool _healthyOnly = false;
  bool _vegetarianOnly = false;
  SortOption _sortOption = SortOption.newest;

  final List<String> _searchHistory = [];

  String get query => _query;
  String? get categoryFilter => _categoryFilter;
  String? get difficultyFilter => _difficultyFilter;
  bool get favoritesOnly => _favoritesOnly;
  bool get healthyOnly => _healthyOnly;
  bool get vegetarianOnly => _vegetarianOnly;
  SortOption get sortOption => _sortOption;
  List<String> get searchHistory => List.unmodifiable(_searchHistory);

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  void commitToHistory() {
    if (_query.trim().isEmpty) return;
    _searchHistory.remove(_query);
    _searchHistory.insert(0, _query);
    if (_searchHistory.length > 10) _searchHistory.removeLast();
    notifyListeners();
  }

  void clearHistory() {
    _searchHistory.clear();
    notifyListeners();
  }

  void setCategoryFilter(String? category) {
    _categoryFilter = category;
    notifyListeners();
  }

  void setDifficultyFilter(String? difficulty) {
    _difficultyFilter = difficulty;
    notifyListeners();
  }

  void toggleFavoritesOnly() {
    _favoritesOnly = !_favoritesOnly;
    notifyListeners();
  }

  void toggleHealthyOnly() {
    _healthyOnly = !_healthyOnly;
    notifyListeners();
  }

  void toggleVegetarianOnly() {
    _vegetarianOnly = !_vegetarianOnly;
    notifyListeners();
  }

  void setSortOption(SortOption option) {
    _sortOption = option;
    notifyListeners();
  }

  void clearFilters() {
    _categoryFilter = null;
    _difficultyFilter = null;
    _favoritesOnly = false;
    _healthyOnly = false;
    _vegetarianOnly = false;
    notifyListeners();
  }

  // The core search+filter+sort pipeline. `favoriteIds` comes from
  // FavoriteProvider so we can honor the "favorites only" filter.
  List<Recipe> apply(List<Recipe> recipes, Set<String> favoriteIds) {
    var result = recipes.where((r) {
      final q = _query.toLowerCase();
      final matchesQuery = q.isEmpty ||
          r.name.toLowerCase().contains(q) ||
          r.category.toLowerCase().contains(q) ||
          r.difficulty.toLowerCase().contains(q) ||
          r.ingredients.any((i) => i.toLowerCase().contains(q));

      final matchesCategory =
          _categoryFilter == null || r.category == _categoryFilter;
      final matchesDifficulty =
          _difficultyFilter == null || r.difficulty == _difficultyFilter;
      final matchesFavorite = !_favoritesOnly || favoriteIds.contains(r.id);
      final matchesHealthy = !_healthyOnly || r.calories < 300;
      final matchesVeggie = !_vegetarianOnly || r.category == 'Vegetarian';

      return matchesQuery &&
          matchesCategory &&
          matchesDifficulty &&
          matchesFavorite &&
          matchesHealthy &&
          matchesVeggie;
    }).toList();

    switch (_sortOption) {
      case SortOption.newest:
        result.sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
        break;
      case SortOption.oldest:
        result.sort((a, b) => a.dateCreated.compareTo(b.dateCreated));
        break;
      case SortOption.highestRated:
        result.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortOption.lowestCalories:
        result.sort((a, b) => a.calories.compareTo(b.calories));
        break;
      case SortOption.preparationTime:
        result.sort((a, b) => a.preparationTime.compareTo(b.preparationTime));
        break;
      case SortOption.cookingTime:
        result.sort((a, b) => a.cookingTime.compareTo(b.cookingTime));
        break;
      case SortOption.alphabetical:
        result.sort((a, b) => a.name.compareTo(b.name));
        break;
    }

    return result;
  }
}