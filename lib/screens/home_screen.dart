import 'package:flutter/material.dart';
import 'package:meal_planner_app/models/meal.dart';
import 'package:meal_planner_app/widgets/category_section.dart';
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

  void editMeal(
    String newName,
    String newDetails,
    MealCategory newCategory,
    Meal oldMeal,
  ) {
    final mealProvider = context.read<MealProvider>();

    mealProvider.updateMeal(
      oldMeal,
      Meal(name: newName, details: newDetails, category: newCategory),
    );
  }

  void openEditMeal(Meal meal) {
    TextEditingController nameController = TextEditingController(
      text: meal.name,
    );
    TextEditingController detailsController = TextEditingController(
      text: meal.details,
    );
    MealCategory selectedCategory = meal.category;
    final localKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Meal'),
          content: Form(
            key: localKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(hintText: 'Meal Name'),
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Meal name cannot be empty.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Meal Details'),
                  controller: detailsController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Meal details cannot be empty.';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField(
                  initialValue: meal.category,
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
                if (localKey.currentState!.validate()) {
                  Navigator.pop(context);

                  editMeal(
                    nameController.text.trim(),
                    detailsController.text.trim(),
                    selectedCategory,
                    meal,
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

              const SizedBox(height: 32),

              // List tile of Meals
              Expanded(
                child: Consumer<MealProvider>(
                  builder: (context, provider, child) {
                    final breakfasts = provider.mealsByCategory(
                      MealCategory.breakfast,
                    );
                    final lunches = provider.mealsByCategory(
                      MealCategory.lunch,
                    );
                    final dinners = provider.mealsByCategory(
                      MealCategory.dinner,
                    );

                    if (provider.meals.isEmpty) {
                      return const Center(child: Text('No meals added yet.'));
                    }

                    return ListView(
                      children: [
                        CategorySection(
                          title: 'Breakfast',
                          child: Column(
                            children: breakfasts
                                .map(
                                  (meal) => MealTile(
                                    meal: meal,
                                    openEditMeal: openEditMeal,
                                  ),
                                )
                                .toList(),
                          ),
                        ),

                        CategorySection(
                          title: 'Lunch',
                          child: Column(
                            children: lunches
                                .map(
                                  (meal) => MealTile(
                                    meal: meal,
                                    openEditMeal: openEditMeal,
                                  ),
                                )
                                .toList(),
                          ),
                        ),

                        CategorySection(
                          title: 'Dinner',
                          child: Column(
                            children: dinners
                                .map(
                                  (meal) => MealTile(
                                    meal: meal,
                                    openEditMeal: openEditMeal,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
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
