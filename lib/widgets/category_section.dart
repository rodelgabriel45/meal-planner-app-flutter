import 'package:flutter/material.dart';
import 'package:meal_planner_app/models/meal.dart';
import 'package:meal_planner_app/widgets/meal_tile.dart';

class CategorySection extends StatelessWidget {
  final String title;
  final List<Meal> meals;
  final void Function(Meal meal) openEditMeal;

  const CategorySection({
    super.key,
    required this.title,
    required this.meals,
    required this.openEditMeal,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),

        const SizedBox(height: 8),

        if (meals.isEmpty)
          const Text(
            'No meals added yet.',
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
          )
        else
          Column(
            children: meals
                .map((meal) => MealTile(meal: meal, openEditMeal: openEditMeal))
                .toList(),
          ),

        const SizedBox(height: 16),
      ],
    );
  }
}
