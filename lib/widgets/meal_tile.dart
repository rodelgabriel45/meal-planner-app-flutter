import 'package:flutter/material.dart';
import 'package:meal_planner_app/models/meal.dart';
import 'package:meal_planner_app/providers/meal_provider.dart';
import 'package:provider/provider.dart';

class MealTile extends StatelessWidget {
  const MealTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<MealProvider>(
        builder: (context, provider, child) {
          if (provider.meals.isEmpty) {
            return const Center(child: Text('No meals added yet.'));
          }

          return ListView.builder(
            itemCount: provider.meals.length,
            itemBuilder: (context, index) {
              final meal = provider.meals[index];

              return ListTile(
                title: Text(
                  meal.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(meal.details),
                    Text(
                      meal.category.displayName,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

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
            },
          );
        },
      ),
    );
  }
}
