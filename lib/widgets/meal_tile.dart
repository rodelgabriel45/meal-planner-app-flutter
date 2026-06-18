import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:meal_planner_app/models/meal.dart';
import 'package:meal_planner_app/models/saved_meal.dart';
import 'package:meal_planner_app/providers/meal_provider.dart';
import 'package:meal_planner_app/providers/saved_meal_provider.dart';
import 'package:provider/provider.dart';

class MealTile extends StatelessWidget {
  final Meal meal;
  final void Function(Meal meal) openEditMeal;
  const MealTile({super.key, required this.meal, required this.openEditMeal});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<MealProvider>();
    final savedMealProvider = context.read<SavedMealProvider>();

    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.blue,
            borderRadius: BorderRadius.circular(16),
            onPressed: (_) {
              openEditMeal(meal);
            },
            icon: Icons.edit,
            label: 'Edit',
          ),
          const SizedBox(width: 4),
          SlidableAction(
            backgroundColor: Colors.red,
            borderRadius: BorderRadius.circular(16),
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

          const SizedBox(width: 4),

          SlidableAction(
            backgroundColor: Colors.blueGrey,
            borderRadius: BorderRadius.circular(16),
            onPressed: (_) {
              if (savedMealProvider.savedMeals.any(
                (savedMeal) => savedMeal.name == meal.name,
              )) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Meal already saved')));
                return;
              }

              savedMealProvider.addMeal(
                SavedMeal(
                  name: meal.name,
                  details: meal.details,
                  calories: meal.calories,
                ),
              );

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Meal template saved')));
            },
            icon: Icons.save,
            label: 'Save',
          ),
        ],
      ),

      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
