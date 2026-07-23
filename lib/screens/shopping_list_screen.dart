import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/shopping_list_provider.dart';
import '../widgets/empty_widget.dart';
import '../widgets/confirmation_dialog.dart';
import '../constants/app_colors.dart';

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shoppingList = context.watch<ShoppingListProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
        actions: [
          if (shoppingList.items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              onPressed: () => _handleClearAll(context, shoppingList),
            ),
        ],
      ),
      body: shoppingList.items.isEmpty
          ? const EmptyWidget(
              title: 'Your list is empty',
              subtitle: 'Assign recipes in the Meal Planner to generate a shopping list.',
              icon: Icons.shopping_cart_outlined,
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${shoppingList.uncheckedCount} of ${shoppingList.items.length} items left',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    itemCount: shoppingList.items.length,
                    itemBuilder: (context, index) {
                      final item = shoppingList.items[index];
                      return Dismissible(
                        key: ValueKey(item.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => shoppingList.removeItem(item.id),
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.delete_outline, color: AppColors.error),
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: theme.cardTheme.color,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: CheckboxListTile(
                            value: item.isChecked,
                            onChanged: (_) => shoppingList.toggleChecked(item.id),
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: AppColors.primaryGreen,
                            title: Text(
                              item.name,
                              style: TextStyle(
                                decoration: item.isChecked ? TextDecoration.lineThrough : null,
                                color: item.isChecked ? theme.textTheme.bodySmall?.color : null,
                              ),
                            ),
                            subtitle: item.fromRecipeIds.length > 1
                                ? Text('Used in ${item.fromRecipeIds.length} recipes')
                                : null,
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

  Future<void> _handleClearAll(BuildContext context, ShoppingListProvider shoppingList) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Clear Shopping List?',
      message: 'This will remove all items from your shopping list.',
      confirmLabel: 'Clear',
      isDestructive: true,
    );
    if (confirmed) shoppingList.clearAll();
  }
}