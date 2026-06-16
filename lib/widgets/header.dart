import 'package:flutter/material.dart';
import 'package:meal_planner_app/providers/meal_provider.dart';
import 'package:provider/provider.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final mealProvider = context.watch<MealProvider>();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Meal Planner',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            const SizedBox(height: 8),
            const Text(
              "Today's Progress",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              '${mealProvider.completedMeals} of ${mealProvider.totalMeals} meals completed',
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: mealProvider.progress),
            Text('${(mealProvider.progress * 100).toInt()}%'),
          ],
        ),
      ),
    );
  }
}
