import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipe_provider.dart';
import '../providers/favorite_provider.dart';
import '../providers/meal_planner_provider.dart';
import '../providers/statistics_provider.dart';
import '../data/categories_data.dart';
import '../constants/app_colors.dart';
import '../widgets/recipe_card.dart';
import '../widgets/category_card.dart';
import '../widgets/statistic_card.dart';
import 'recipe_detail_screen.dart';
import 'category_screen.dart';
import 'search_screen.dart';
import 'favorites_screen.dart';
import 'meal_planner_screen.dart';
import 'add_edit_recipe_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 18) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final recipeProvider = context.watch<RecipeProvider>();
    final favoriteProvider = context.watch<FavoriteProvider>();
    final mealPlannerProvider = context.watch<MealPlannerProvider>();
    final statsProvider = context.read<StatisticsProvider>();

    final recipes = recipeProvider.recipes;
    final recipeOfDay = recipeProvider.recipeOfTheDay();

    return Scaffold(
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'add_recipe_fab',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddEditRecipeScreen()),
              );
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'surprise_me_fab',
            onPressed: () {
              final random = recipeProvider.randomRecipe();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipeId: random.id)),
              );
            },
            icon: const Icon(Icons.shuffle),
            label: const Text('Surprise Me'),
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context)),
            SliverToBoxAdapter(child: _buildRecipeOfDay(context, recipeOfDay)),
            SliverToBoxAdapter(child: _buildQuickCategories(context)),
            SliverToBoxAdapter(
              child: _buildStatisticsCard(context, statsProvider, recipes, favoriteProvider),
            ),
            SliverToBoxAdapter(
              child: _buildSection(
                context,
                title: 'Featured Recipes',
                recipes: recipeProvider.recommended.isNotEmpty
                    ? recipeProvider.recommended
                    : recipes.take(6).toList(),
              ),
            ),
            SliverToBoxAdapter(
              child: _buildSection(
                context,
                title: 'Trending Recipes',
                recipes: recipeProvider.highestRated.take(6).toList(),
              ),
            ),
            SliverToBoxAdapter(
              child: _buildSection(
                context,
                title: 'Newest Recipes',
                recipes: recipeProvider.newest.take(6).toList(),
              ),
            ),
            SliverToBoxAdapter(
              child: _buildSection(
                context,
                title: 'Healthy Choices',
                recipes: recipeProvider.healthyChoices.take(6).toList(),
              ),
            ),
            SliverToBoxAdapter(
              child: _buildFavoritesPreview(context, recipeProvider, favoriteProvider),
            ),
            SliverToBoxAdapter(
              child: _buildRecentlyViewed(context, recipeProvider),
            ),
            SliverToBoxAdapter(
              child: _buildMealPlannerPreview(context, mealPlannerProvider),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 90)),
          ],
        ),
      ),
    );
  }

  // ---------- Header ----------
  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_greeting(), style: theme.textTheme.bodyMedium),
                  Text('What are we cooking today?',
                      style: theme.textTheme.headlineSmall?.copyWith(fontSize: 20)),
                ],
              ),
              CircleAvatar(
                backgroundColor: AppColors.primaryGreen.withOpacity(0.15),
                child: const Icon(Icons.person, color: AppColors.primaryGreen),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchScreen()),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: theme.inputDecorationTheme.fillColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: theme.textTheme.bodySmall?.color),
                  const SizedBox(width: 10),
                  Text('Search recipes, ingredients...', style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Recipe of the Day ----------
  Widget _buildRecipeOfDay(BuildContext context, recipeOfDay) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipeId: recipeOfDay.id)),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [AppColors.primaryGreen, AppColors.lightGreen],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Recipe of the Day',
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                    const SizedBox(height: 6),
                    Text(recipeOfDay.name,
                        style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontSize: 18)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.white, size: 14),
                        const SizedBox(width: 4),
                        Text('${recipeOfDay.rating} • ${recipeOfDay.totalTime} min',
                            style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                child: const Icon(Icons.restaurant_menu, color: Colors.white, size: 30),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Quick Categories ----------
  Widget _buildQuickCategories(BuildContext context) {
    final recipeProvider = context.read<RecipeProvider>();
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: _sectionTitle(context, 'Quick Categories', onSeeAll: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryScreen()));
            }),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 130,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categoriesData.length,
              padding: const EdgeInsets.only(right: 20),
              itemBuilder: (context, index) {
                final category = categoriesData[index];
                final count = recipeProvider.getByCategory(category.name).length;
                return Container(
                  width: 110,
                  margin: const EdgeInsets.only(right: 12),
                  child: CategoryCard(
                    category: category,
                    recipeCount: count,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CategoryScreen(initialCategory: category.name),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Statistics Card ----------
  Widget _buildStatisticsCard(BuildContext context, StatisticsProvider stats,
      List recipes, FavoriteProvider favoriteProvider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: StatisticCard(
              label: 'Total Recipes',
              value: '${stats.totalRecipes(recipes.cast())}',
              icon: Icons.menu_book,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: StatisticCard(
              label: 'Favorites',
              value: '${favoriteProvider.count}',
              icon: Icons.favorite,
              color: AppColors.secondaryOrange,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: StatisticCard(
              label: 'Avg Rating',
              value: stats.averageRating(recipes.cast()).toStringAsFixed(1),
              icon: Icons.star,
              color: AppColors.ratingGold,
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Generic horizontal recipe section ----------
  Widget _buildSection(BuildContext context, {required String title, required List recipes}) {
    if (recipes.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: _sectionTitle(context, title),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 210,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recipes.length,
              padding: const EdgeInsets.only(right: 20),
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return RecipeCard(
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

  // ---------- Favorites Preview ----------
  Widget _buildFavoritesPreview(
      BuildContext context, RecipeProvider recipeProvider, FavoriteProvider favoriteProvider) {
    final favRecipes = recipeProvider.recipes
        .where((r) => favoriteProvider.isFavorite(r.id))
        .toList();
    if (favRecipes.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: _sectionTitle(context, 'Your Favorites', onSeeAll: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen()));
            }),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 210,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: favRecipes.length,
              padding: const EdgeInsets.only(right: 20),
              itemBuilder: (context, index) {
                final recipe = favRecipes[index];
                return RecipeCard(
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

  // ---------- Recently Viewed ----------
  Widget _buildRecentlyViewed(BuildContext context, RecipeProvider recipeProvider) {
    final recent = recipeProvider.recentlyViewed;
    if (recent.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: _sectionTitle(context, 'Recently Viewed'),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 210,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recent.length,
              padding: const EdgeInsets.only(right: 20),
              itemBuilder: (context, index) {
                final recipe = recent[index];
                return RecipeCard(
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

  // ---------- Meal Planner Preview ----------
  Widget _buildMealPlannerPreview(BuildContext context, MealPlannerProvider mealPlanner) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MealPlannerScreen()),
        ),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.secondaryOrange.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.calendar_today, color: AppColors.secondaryOrange),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Meal Planner', style: theme.textTheme.titleMedium),
                    Text('${mealPlanner.plans.length} meals scheduled this week',
                        style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title, {VoidCallback? onSeeAll}) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: theme.textTheme.titleLarge?.copyWith(fontSize: 17)),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: Text('See All',
                style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.primaryGreen)),
          ),
      ],
    );
  }
}