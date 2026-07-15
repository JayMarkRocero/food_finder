import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipe_provider.dart';
import '../providers/favorite_provider.dart';
import '../providers/search_provider.dart';
import '../data/categories_data.dart';
import '../constants/app_colors.dart';
import '../widgets/recipe_tile.dart';
import '../widgets/empty_widget.dart';
import 'recipe_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recipeProvider = context.watch<RecipeProvider>();
    final favoriteProvider = context.watch<FavoriteProvider>();
    final searchProvider = context.watch<SearchProvider>();

    final results = searchProvider.apply(recipeProvider.recipes, favoriteProvider.favoriteIds);
    final showHistory = searchProvider.query.isEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: TextField(
              controller: _controller,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              onChanged: (v) => searchProvider.setQuery(v),
              onSubmitted: (_) => searchProvider.commitToHistory(),
              decoration: InputDecoration(
                hintText: 'Search recipes, ingredients, category...',
                prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
                suffixIcon: searchProvider.query.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
                        onPressed: () {
                          _controller.clear();
                          searchProvider.setQuery('');
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Filter chips
          SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _filterChip(
                  label: 'Favorites',
                  selected: searchProvider.favoritesOnly,
                  onTap: searchProvider.toggleFavoritesOnly,
                ),
                _filterChip(
                  label: 'Healthy',
                  selected: searchProvider.healthyOnly,
                  onTap: searchProvider.toggleHealthyOnly,
                ),
                _filterChip(
                  label: 'Vegetarian',
                  selected: searchProvider.vegetarianOnly,
                  onTap: searchProvider.toggleVegetarianOnly,
                ),
                ...['Easy', 'Medium', 'Hard'].map((d) => _filterChip(
                      label: d,
                      selected: searchProvider.difficultyFilter == d,
                      onTap: () => searchProvider.setDifficultyFilter(
                        searchProvider.difficultyFilter == d ? null : d,
                      ),
                    )),
                IconButton(
                  icon: const Icon(Icons.sort),
                  onPressed: () => _showSortSheet(context, searchProvider),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          Expanded(
            child: showHistory
                ? _buildHistoryOrCategories(context, searchProvider)
                : results.isEmpty
                    ? const EmptyWidget(
                        title: 'No recipes found',
                        subtitle: 'Try a different search term or adjust your filters.',
                        icon: Icons.search_off,
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final recipe = results[index];
                          return RecipeTile(
                            recipe: recipe,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipeId: recipe.id)),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip({required String label, required bool selected, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
    );
  }

  Widget _buildHistoryOrCategories(BuildContext context, SearchProvider searchProvider) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      children: [
        if (searchProvider.searchHistory.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Searches', style: theme.textTheme.titleMedium),
              TextButton(
                onPressed: searchProvider.clearHistory,
                child: const Text('Clear'),
              ),
            ],
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: searchProvider.searchHistory.map((term) {
              return ActionChip(
                label: Text(term),
                avatar: const Icon(Icons.history, size: 16),
                onPressed: () {
                  _controller.text = term;
                  searchProvider.setQuery(term);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],
        Text('Browse by Category', style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categoriesData.map((c) {
            return ActionChip(
              label: Text(c.name),
              onPressed: () => searchProvider.setCategoryFilter(c.name),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showSortSheet(BuildContext context, SearchProvider searchProvider) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: SortOption.values.map((option) {
              return ListTile(
                title: Text(_sortLabel(option)),
                trailing: searchProvider.sortOption == option
                    ? const Icon(Icons.check, color: AppColors.primaryGreen)
                    : null,
                onTap: () {
                  searchProvider.setSortOption(option);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  String _sortLabel(SortOption option) {
    switch (option) {
      case SortOption.newest:
        return 'Newest First';
      case SortOption.oldest:
        return 'Oldest First';
      case SortOption.highestRated:
        return 'Highest Rated';
      case SortOption.lowestCalories:
        return 'Lowest Calories';
      case SortOption.preparationTime:
        return 'Preparation Time';
      case SortOption.cookingTime:
        return 'Cooking Time';
      case SortOption.alphabetical:
        return 'Alphabetical';
    }
    return '';
  }
}