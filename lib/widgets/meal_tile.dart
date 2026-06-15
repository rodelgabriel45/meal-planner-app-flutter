import 'package:flutter/material.dart';
import 'package:meal_planner_app/models/meal.dart';
import 'package:meal_planner_app/providers/meal_provider.dart';
import 'package:provider/provider.dart';

class MealTile extends StatelessWidget {
  final Meal meal;
  const MealTile({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<MealProvider>();

    return ListTile(
      title: Text(
        meal.name,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text(meal.details),
      trailing: Checkbox(
        value: meal.isCompleted,
        onChanged: (_) {
          provider.toggleMeal(meal);
        },
      ),
      onLongPress: () {
        provider.deleteMeal(meal);
      },
    );
  }
}
