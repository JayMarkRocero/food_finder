// A single ingredient entry in the generated shopping list.
class ShoppingItem {
  final String id;
  final String name;
  bool isChecked;
  final List<String> fromRecipeIds; // tracks which recipes need this item

  ShoppingItem({
    required this.id,
    required this.name,
    this.isChecked = false,
    required this.fromRecipeIds,
  });
}