import 'package:flutter/material.dart';
import 'package:meal_planner_app/models/meal.dart';
import 'package:meal_planner_app/providers/meal_provider.dart';
import 'package:meal_planner_app/widgets/category_section.dart';
import 'package:provider/provider.dart';

class MealList extends StatelessWidget {
  final void Function(Meal meal) openEditMeal;
  const MealList({super.key, required this.openEditMeal});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<MealProvider>(
        builder: (context, provider, child) {
          final breakfasts = provider.mealsByCategory(MealCategory.breakfast);
          final lunches = provider.mealsByCategory(MealCategory.lunch);
          final dinners = provider.mealsByCategory(MealCategory.dinner);

          if (provider.meals.isEmpty) {
            return const Center(child: Text('No meals added yet.'));
          }

          return ListView(
            children: [
              CategorySection(
                title: 'Breakfast',
                meals: breakfasts,
                openEditMeal: openEditMeal,
              ),

              CategorySection(
                title: 'Lunch',
                meals: lunches,
                openEditMeal: openEditMeal,
              ),

              CategorySection(
                title: 'Dinner',
                meals: dinners,
                openEditMeal: openEditMeal,
              ),
            ],
          );
        },
      ),
    );
  }
}
