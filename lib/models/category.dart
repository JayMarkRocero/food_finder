// Represents a recipe category, e.g. "Breakfast", "Filipino", "Dessert".
class Category {
  final String id;
  final String name;
  final String icon; // we'll use a Material icon name/key, not an image file
  final int colorValue; // stored as int so it's easy to keep as static data

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.colorValue,
  });
}