import '../models/category.dart';

// Static list of all recipe categories used across the app
// (category screen, filters, quick categories on home, etc.)
const List<Category> categoriesData = [
  Category(id: 'c1', name: 'Breakfast', icon: 'breakfast_dining', colorValue: 0xFFFFA726),
  Category(id: 'c2', name: 'Lunch', icon: 'lunch_dining', colorValue: 0xFF66BB6A),
  Category(id: 'c3', name: 'Dinner', icon: 'dinner_dining', colorValue: 0xFF42A5F5),
  Category(id: 'c4', name: 'Dessert', icon: 'cake', colorValue: 0xFFEC407A),
  Category(id: 'c5', name: 'Snacks', icon: 'cookie', colorValue: 0xFFFFB300),
  Category(id: 'c6', name: 'Healthy', icon: 'eco', colorValue: 0xFF66BB6A),
  Category(id: 'c7', name: 'Vegetarian', icon: 'grass', colorValue: 0xFF8BC34A),
  Category(id: 'c8', name: 'Chicken', icon: 'egg', colorValue: 0xFFFF7043),
  Category(id: 'c9', name: 'Pork', icon: 'kebab_dining', colorValue: 0xFFD84315),
  Category(id: 'c10', name: 'Beef', icon: 'lunch_dining', colorValue: 0xFF6D4C41),
  Category(id: 'c11', name: 'Seafood', icon: 'set_meal', colorValue: 0xFF29B6F6),
  Category(id: 'c12', name: 'Rice', icon: 'rice_bowl', colorValue: 0xFFFFCA28),
  Category(id: 'c13', name: 'Soup', icon: 'soup_kitchen', colorValue: 0xFFFF8A65),
  Category(id: 'c14', name: 'Pasta', icon: 'ramen_dining', colorValue: 0xFFFFA000),
  Category(id: 'c15', name: 'Drinks', icon: 'local_bar', colorValue: 0xFF26C6DA),
  Category(id: 'c16', name: 'Filipino', icon: 'flag', colorValue: 0xFFEF5350),
  Category(id: 'c17', name: 'Italian', icon: 'local_pizza', colorValue: 0xFF43A047),
  Category(id: 'c18', name: 'American', icon: 'fastfood', colorValue: 0xFF5C6BC0),
  Category(id: 'c19', name: 'Asian', icon: 'restaurant', colorValue: 0xFFAB47BC),
];