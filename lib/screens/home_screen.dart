import 'package:flutter/material.dart';
import 'package:meal_planner_app/models/meal.dart';
import 'package:meal_planner_app/widgets/meal_tile.dart';
import 'package:provider/provider.dart';
import 'package:meal_planner_app/providers/meal_provider.dart';
import 'package:meal_planner_app/widgets/header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (mounted) {
        context.read<MealProvider>().loadMeals();
      }
    });
  }

  void addMeal(String mealName, String mealDetails, MealCategory category) {
    final mealProvider = context.read<MealProvider>();

    mealProvider.addMeal(
      Meal(name: mealName, details: mealDetails, category: category),
    );
  }

  void openAddMeal() {
    TextEditingController nameController = TextEditingController();
    TextEditingController detailsController = TextEditingController();
    MealCategory selectedCategory = MealCategory.breakfast;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add new meal'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(hintText: 'Meal Name'),
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Meal name must be provided.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Meal details'),
                  controller: detailsController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Meal details cannot be empty.';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<MealCategory>(
                  initialValue: selectedCategory,
                  items: MealCategory.values.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) return;

                    setState(() {
                      selectedCategory = value;
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
                if (_formKey.currentState!.validate()) {
                  Navigator.pop(context);

                  addMeal(
                    nameController.text.trim(),
                    detailsController.text.trim(),
                    selectedCategory,
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Header(),

              // List tile of Meals
              MealTile(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openAddMeal,
        child: Icon(Icons.add),
      ),
    );
  }
}
