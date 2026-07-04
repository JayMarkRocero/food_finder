// Represents a single recipe in the app.
// This is a plain Dart class (no database) — all recipes live in memory.
class Recipe {
  final String id;
  final String name;
  final String description;
  final String category; // e.g. "Breakfast", "Filipino", "Dessert"
  final String difficulty; // "Easy", "Medium", "Hard"
  final String image; // asset path OR icon key
  final List<String> ingredients;
  final List<String> steps;
  final List<String> tips;
  final int preparationTime; // in minutes
  final int cookingTime; // in minutes
  final int servings;

  // Nutrition
  final int calories;
  final double protein;
  final double carbohydrates;
  final double fat;
  final double fiber;

  final double rating;
  final int reviewCount;
  bool favorite;
  final bool recommended;
  final String author;
  final DateTime dateCreated;
  final DateTime dateUpdated;

  Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.image,
    required this.ingredients,
    required this.steps,
    required this.tips,
    required this.preparationTime,
    required this.cookingTime,
    required this.servings,
    required this.calories,
    required this.protein,
    required this.carbohydrates,
    required this.fat,
    required this.fiber,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.favorite = false,
    this.recommended = false,
    required this.author,
    required this.dateCreated,
    required this.dateUpdated,
  });

  int get totalTime => preparationTime + cookingTime;

  Recipe copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? difficulty,
    String? image,
    List<String>? ingredients,
    List<String>? steps,
    List<String>? tips,
    int? preparationTime,
    int? cookingTime,
    int? servings,
    int? calories,
    double? protein,
    double? carbohydrates,
    double? fat,
    double? fiber,
    double? rating,
    int? reviewCount,
    bool? favorite,
    bool? recommended,
    String? author,
    DateTime? dateCreated,
    DateTime? dateUpdated,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      image: image ?? this.image,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      tips: tips ?? this.tips,
      preparationTime: preparationTime ?? this.preparationTime,
      cookingTime: cookingTime ?? this.cookingTime,
      servings: servings ?? this.servings,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbohydrates: carbohydrates ?? this.carbohydrates,
      fat: fat ?? this.fat,
      fiber: fiber ?? this.fiber,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      favorite: favorite ?? this.favorite,
      recommended: recommended ?? this.recommended,
      author: author ?? this.author,
      dateCreated: dateCreated ?? this.dateCreated,
      dateUpdated: dateUpdated ?? this.dateUpdated,
    );
  }
}