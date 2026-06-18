import 'package:flutter/material.dart';
import 'package:meal_planner_app/models/meal.dart';
import 'package:meal_planner_app/models/saved_meal.dart';
import 'package:meal_planner_app/providers/saved_meal_provider.dart';
import 'package:provider/provider.dart';

class MealFormDialog extends StatefulWidget {
  final String title;
  final Meal? meal;

  const MealFormDialog({super.key, required this.title, this.meal});

  @override
  State<MealFormDialog> createState() => _MealFormDialogState();
}

class _MealFormDialogState extends State<MealFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _detailsController;
  late TextEditingController _caloriesController;

  late MealCategory _selectedCategory;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.meal?.name ?? '');
    _detailsController = TextEditingController(
      text: widget.meal?.details ?? '',
    );

    _caloriesController = TextEditingController(
      text: widget.meal?.calories.toString() ?? '',
    );

    _selectedCategory = widget.meal?.category ?? MealCategory.breakfast;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _detailsController.dispose();
    _caloriesController.dispose();

    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.pop(
      context,
      Meal(
        name: _nameController.text.trim(),
        details: _detailsController.text.trim(),
        category: _selectedCategory,
        calories: int.parse(_caloriesController.text),
      ),
    );
  }

  Future<void> openMealTemplatePicker() async {
    final savedMeal = await showModalBottomSheet<SavedMeal>(
      context: context,
      builder: (context) {
        final savedMeals = context.read<SavedMealProvider>().savedMeals;

        return SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),

              const Text(
                'Choose Meal Template',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const Divider(),

              Expanded(
                child: ListView.builder(
                  itemCount: savedMeals.length,
                  itemBuilder: (context, index) {
                    final meal = savedMeals[index];

                    return ListTile(
                      title: Text(meal.name),
                      subtitle: Text('${meal.calories} kcal'),
                      onTap: () {
                        Navigator.pop(context, meal);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    if (savedMeal == null) return;

    _nameController.text = savedMeal.name;
    _detailsController.text = savedMeal.details;
    _caloriesController.text = savedMeal.calories.toString();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton.icon(
              onPressed: openMealTemplatePicker,
              icon: const Icon(Icons.restaurant_menu),
              label: const Text('Choose a Template meal'),
            ),

            TextFormField(
              decoration: const InputDecoration(hintText: 'Meal Name'),
              controller: _nameController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Meal name cannot be empty.';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(hintText: 'Meal Details'),
              controller: _detailsController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Meal details cannot be empty.';
                }
                return null;
              },
            ),

            TextFormField(
              controller: _caloriesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Calories'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Calories required.';
                }

                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number.';
                }
                return null;
              },
            ),

            DropdownButtonFormField(
              initialValue: _selectedCategory,
              items: MealCategory.values.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category.displayName),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            _save();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
