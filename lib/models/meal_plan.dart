// Represents one assigned meal slot in the weekly planner.
// e.g. "Monday - Breakfast - Recipe X"
class MealPlan {
  final String id;
  final String day; // "Monday", "Tuesday", etc.
  final String mealType; // "Breakfast", "Lunch", "Dinner"
  final String recipeId;

  MealPlan({
    required this.id,
    required this.day,
    required this.mealType,
    required this.recipeId,
  });

  MealPlan copyWith({
    String? id,
    String? day,
    String? mealType,
    String? recipeId,
  }) {
    return MealPlan(
      id: id ?? this.id,
      day: day ?? this.day,
      mealType: mealType ?? this.mealType,
      recipeId: recipeId ?? this.recipeId,
    );
  }
}