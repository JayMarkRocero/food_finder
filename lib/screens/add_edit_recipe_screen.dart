import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/recipe.dart';
import '../providers/recipe_provider.dart';
import '../data/categories_data.dart';
import '../widgets/custom_button.dart';

// Handles both CREATE (existingRecipe == null) and UPDATE (existingRecipe
// provided) in one screen, since the form layout is identical either way.
class AddEditRecipeScreen extends StatefulWidget {
  final Recipe? existingRecipe;

  const AddEditRecipeScreen({super.key, this.existingRecipe});

  @override
  State<AddEditRecipeScreen> createState() => _AddEditRecipeScreenState();
}

class _AddEditRecipeScreenState extends State<AddEditRecipeScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _prepTimeController;
  late TextEditingController _cookTimeController;
  late TextEditingController _servingsController;
  late TextEditingController _caloriesController;
  late TextEditingController _proteinController;
  late TextEditingController _carbsController;
  late TextEditingController _fatController;
  late TextEditingController _fiberController;
  late TextEditingController _authorController;

  String _selectedCategory = categoriesData.first.name;
  String _selectedDifficulty = 'Easy';
  String _selectedImage = 'placeholder';

  // Ingredients and steps are dynamic lists of text fields, since a recipe
  // can have any number of them (minimum enforced on submit).
  List<TextEditingController> _ingredientControllers = [];
  List<TextEditingController> _stepControllers = [];
  List<TextEditingController> _tipControllers = [];

  bool get _isEditing => widget.existingRecipe != null;

  @override
  void initState() {
    super.initState();
    final r = widget.existingRecipe;

    _nameController = TextEditingController(text: r?.name ?? '');
    _descriptionController = TextEditingController(text: r?.description ?? '');
    _prepTimeController = TextEditingController(text: r?.preparationTime.toString() ?? '');
    _cookTimeController = TextEditingController(text: r?.cookingTime.toString() ?? '');
    _servingsController = TextEditingController(text: r?.servings.toString() ?? '');
    _caloriesController = TextEditingController(text: r?.calories.toString() ?? '');
    _proteinController = TextEditingController(text: r?.protein.toString() ?? '');
    _carbsController = TextEditingController(text: r?.carbohydrates.toString() ?? '');
    _fatController = TextEditingController(text: r?.fat.toString() ?? '');
    _fiberController = TextEditingController(text: r?.fiber.toString() ?? '');
    _authorController = TextEditingController(text: r?.author ?? 'You');

    if (r != null) {
      _selectedCategory = r.category;
      _selectedDifficulty = r.difficulty;
      _selectedImage = r.image;
      _ingredientControllers = r.ingredients.map((i) => TextEditingController(text: i)).toList();
      _stepControllers = r.steps.map((s) => TextEditingController(text: s)).toList();
      _tipControllers = r.tips.map((t) => TextEditingController(text: t)).toList();
    } else {
      // Start with a few empty fields so the form isn't intimidatingly bare.
      _ingredientControllers = [TextEditingController(), TextEditingController()];
      _stepControllers = [TextEditingController(), TextEditingController()];
      _tipControllers = [TextEditingController()];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _prepTimeController.dispose();
    _cookTimeController.dispose();
    _servingsController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    _fiberController.dispose();
    _authorController.dispose();
    for (final c in [..._ingredientControllers, ..._stepControllers, ..._tipControllers]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Recipe' : 'Create Recipe')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _imagePickerPlaceholder(),
            const SizedBox(height: 20),

            _textField(_nameController, 'Recipe Name', validator: _requiredValidator),
            const SizedBox(height: 14),
            _textField(_descriptionController, 'Description', maxLines: 3, validator: _requiredValidator),
            const SizedBox(height: 14),

            _dropdownField(
              label: 'Category',
              value: _selectedCategory,
              items: categoriesData.map((c) => c.name).toList(),
              onChanged: (v) => setState(() => _selectedCategory = v!),
            ),
            const SizedBox(height: 14),
            _dropdownField(
              label: 'Difficulty',
              value: _selectedDifficulty,
              items: const ['Easy', 'Medium', 'Hard'],
              onChanged: (v) => setState(() => _selectedDifficulty = v!),
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: _textField(_prepTimeController, 'Prep Time (min)',
                      keyboardType: TextInputType.number, validator: _nonNegativeIntValidator),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _textField(_cookTimeController, 'Cook Time (min)',
                      keyboardType: TextInputType.number, validator: _nonNegativeIntValidator),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _textField(_servingsController, 'Servings',
                keyboardType: TextInputType.number, validator: _positiveIntValidator),
            const SizedBox(height: 20),

            Text('Nutrition', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _textField(_caloriesController, 'Calories',
                      keyboardType: TextInputType.number, validator: _nonNegativeIntValidator),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _textField(_proteinController, 'Protein (g)',
                      keyboardType: TextInputType.number, validator: _nonNegativeNumValidator),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _textField(_carbsController, 'Carbs (g)',
                      keyboardType: TextInputType.number, validator: _nonNegativeNumValidator),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _textField(_fatController, 'Fat (g)',
                      keyboardType: TextInputType.number, validator: _nonNegativeNumValidator),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _textField(_fiberController, 'Fiber (g)',
                keyboardType: TextInputType.number, validator: _nonNegativeNumValidator),
            const SizedBox(height: 20),

            _dynamicListSection(
              title: 'Ingredients',
              controllers: _ingredientControllers,
              hint: 'e.g. 2 cups flour',
              minRequired: 2,
            ),
            const SizedBox(height: 20),

            _dynamicListSection(
              title: 'Cooking Steps',
              controllers: _stepControllers,
              hint: 'Describe this step',
              minRequired: 2,
            ),
            const SizedBox(height: 20),

            _dynamicListSection(
              title: 'Tips (optional)',
              controllers: _tipControllers,
              hint: 'Add a helpful tip',
              minRequired: 0,
            ),
            const SizedBox(height: 14),

            _textField(_authorController, 'Author', validator: _requiredValidator),
            const SizedBox(height: 30),

            CustomButton(
              label: _isEditing ? 'Save Changes' : 'Create Recipe',
              icon: Icons.check,
              onPressed: _handleSubmit,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ---------- Sub-widgets ----------

  Widget _imagePickerPlaceholder() {
    final theme = Theme.of(context);
    // Since there's no real image upload (offline, static-only app), this
    // simulates "choosing" one of a few built-in placeholder styles.
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedImage = _selectedImage == 'placeholder' ? 'placeholder_alt' : 'placeholder';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Placeholder image selected')),
        );
      },
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [theme.colorScheme.primary.withOpacity(0.8), theme.colorScheme.primary.withOpacity(0.4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_photo_alternate_outlined, color: Colors.white, size: 36),
              SizedBox(height: 8),
              Text('Tap to choose an image', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label),
      validator: validator,
    );
  }

  Widget _dropdownField({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _dynamicListSection({
    required String title,
    required List<TextEditingController> controllers,
    required String hint,
    required int minRequired,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            TextButton.icon(
              onPressed: () => setState(() => controllers.add(TextEditingController())),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add'),
            ),
          ],
        ),
        ...List.generate(controllers.length, (i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controllers[i],
                    decoration: InputDecoration(labelText: '${title.split(' ').first} ${i + 1}', hintText: hint),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: controllers.length > minRequired
                      ? () => setState(() {
                            controllers[i].dispose();
                            controllers.removeAt(i);
                          })
                      : null,
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ---------- Validators ----------

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'This field is required';
    return null;
  }

  String? _nonNegativeIntValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    final n = int.tryParse(value);
    if (n == null) return 'Enter a valid number';
    if (n < 0) return 'Cannot be negative';
    return null;
  }

  String? _positiveIntValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    final n = int.tryParse(value);
    if (n == null) return 'Enter a valid number';
    if (n <= 0) return 'Must be greater than 0';
    return null;
  }

  String? _nonNegativeNumValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    final n = double.tryParse(value);
    if (n == null) return 'Enter a valid number';
    if (n < 0) return 'Cannot be negative';
    return null;
  }

  // ---------- Submit ----------

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final recipeProvider = context.read<RecipeProvider>();
    final name = _nameController.text.trim();

    // Duplicate name check (spec requirement) — excluding self when editing.
    if (recipeProvider.nameExists(name, excludingId: widget.existingRecipe?.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A recipe with this name already exists.')),
      );
      return;
    }

    final ingredients = _ingredientControllers.map((c) => c.text.trim()).where((t) => t.isNotEmpty).toList();
    final steps = _stepControllers.map((c) => c.text.trim()).where((t) => t.isNotEmpty).toList();
    final tips = _tipControllers.map((c) => c.text.trim()).where((t) => t.isNotEmpty).toList();

    // Missing ingredients / minimum steps checks (spec requirement).
    if (ingredients.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least 2 ingredients.')),
      );
      return;
    }
    if (steps.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least 2 cooking steps.')),
      );
      return;
    }

    final now = DateTime.now();

    if (_isEditing) {
      final updated = widget.existingRecipe!.copyWith(
        name: name,
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        difficulty: _selectedDifficulty,
        image: _selectedImage,
        ingredients: ingredients,
        steps: steps,
        tips: tips,
        preparationTime: int.parse(_prepTimeController.text),
        cookingTime: int.parse(_cookTimeController.text),
        servings: int.parse(_servingsController.text),
        calories: int.parse(_caloriesController.text),
        protein: double.parse(_proteinController.text),
        carbohydrates: double.parse(_carbsController.text),
        fat: double.parse(_fatController.text),
        fiber: double.parse(_fiberController.text),
        author: _authorController.text.trim(),
        dateUpdated: now,
      );
      recipeProvider.updateRecipe(updated);
    } else {
      final newRecipe = Recipe(
        id: 'r${now.microsecondsSinceEpoch}',
        name: name,
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        difficulty: _selectedDifficulty,
        image: _selectedImage,
        ingredients: ingredients,
        steps: steps,
        tips: tips,
        preparationTime: int.parse(_prepTimeController.text),
        cookingTime: int.parse(_cookTimeController.text),
        servings: int.parse(_servingsController.text),
        calories: int.parse(_caloriesController.text),
        protein: double.parse(_proteinController.text),
        carbohydrates: double.parse(_carbsController.text),
        fat: double.parse(_fatController.text),
        fiber: double.parse(_fiberController.text),
        author: _authorController.text.trim(),
        dateCreated: now,
        dateUpdated: now,
      );
      recipeProvider.addRecipe(newRecipe);
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_isEditing ? 'Recipe updated!' : 'Recipe created!')),
    );
  }
}