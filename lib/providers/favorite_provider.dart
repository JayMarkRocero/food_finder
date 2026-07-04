import 'package:flutter/foundation.dart';

// Tracks which recipe IDs are favorited. Kept separate from RecipeProvider
// so favorite status can change without rebuilding the entire recipe list,
// and so the Favorites screen has one clean source to watch.
class FavoriteProvider extends ChangeNotifier {
  final Set<String> _favoriteIds = {};

  Set<String> get favoriteIds => Set.unmodifiable(_favoriteIds);

  int get count => _favoriteIds.length;

  bool isFavorite(String recipeId) => _favoriteIds.contains(recipeId);

  void toggleFavorite(String recipeId) {
    if (_favoriteIds.contains(recipeId)) {
      _favoriteIds.remove(recipeId);
    } else {
      _favoriteIds.add(recipeId);
    }
    notifyListeners();
  }

  void removeFavorite(String recipeId) {
    _favoriteIds.remove(recipeId);
    notifyListeners();
  }

  void clearAll() {
    _favoriteIds.clear();
    notifyListeners();
  }
}