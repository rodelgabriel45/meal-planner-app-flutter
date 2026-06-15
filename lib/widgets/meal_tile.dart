import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:meal_planner_app/models/meal.dart';
import 'package:meal_planner_app/providers/meal_provider.dart';
import 'package:provider/provider.dart';

class MealTile extends StatelessWidget {
  final Meal meal;
  final Function openEditMeal;
  const MealTile({super.key, required this.meal, required this.openEditMeal});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<MealProvider>();

    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.blue,
            onPressed: (_) {
              openEditMeal(meal);
            },
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            backgroundColor: Colors.red,
            onPressed: (_) {
              provider.deleteMeal(meal);
            },
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),

      child: ListTile(
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
      ),
    );
  }
}
