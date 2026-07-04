import 'package:flutter/foundation.dart';
import '../models/meal_plan.dart';

const List<String> weekDays = [
  'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
];
const List<String> mealTypes = ['Breakfast', 'Lunch', 'Dinner'];

// Manages the weekly meal planner: assigning recipes to day/mealType slots.
class MealPlannerProvider extends ChangeNotifier {
  final List<MealPlan> _plans = [];

  List<MealPlan> get plans => List.unmodifiable(_plans);

  MealPlan? planFor(String day, String mealType) {
    try {
      return _plans.firstWhere((p) => p.day == day && p.mealType == mealType);
    } catch (_) {
      return null;
    }
  }

  List<MealPlan> plansForDay(String day) =>
      _plans.where((p) => p.day == day).toList();

  void assignRecipe(String day, String mealType, String recipeId) {
    _plans.removeWhere((p) => p.day == day && p.mealType == mealType);
    _plans.add(MealPlan(
      id: '${day}_${mealType}_${DateTime.now().microsecondsSinceEpoch}',
      day: day,
      mealType: mealType,
      recipeId: recipeId,
    ));
    notifyListeners();
  }

  void removeSlot(String day, String mealType) {
    _plans.removeWhere((p) => p.day == day && p.mealType == mealType);
    notifyListeners();
  }

  void clearPlanner() {
    _plans.clear();
    notifyListeners();
  }

  // All unique recipe IDs currently scheduled — used to generate a
  // shopping list straight from the meal planner.
  List<String> get scheduledRecipeIds =>
      _plans.map((p) => p.recipeId).toSet().toList();
}