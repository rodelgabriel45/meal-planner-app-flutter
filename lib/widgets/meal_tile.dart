import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:meal_planner_app/models/meal.dart';
import 'package:meal_planner_app/providers/meal_provider.dart';
import 'package:provider/provider.dart';

class MealTile extends StatelessWidget {
  final Meal meal;
  final void Function(Meal meal) openEditMeal;
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
            onPressed: (_) async {
              final shouldDelete = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Delete meal'),
                    content: const Text(
                      'Are you sure you want to delete this meal?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  );
                },
              );

              if (shouldDelete == true) {
                provider.deleteMeal(meal);
              }
            },
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),

      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Colors.grey, width: 1),
        ),
        child: ListTile(
          title: Text(
            meal.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              decoration: meal.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Column(
            children: [
              Text(meal.details),
              Text(
                '${meal.calories} kcal',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
          trailing: Checkbox(
            value: meal.isCompleted,
            onChanged: (_) {
              provider.toggleMeal(meal);
            },
          ),
        ),
      ),
    );
  }
}
