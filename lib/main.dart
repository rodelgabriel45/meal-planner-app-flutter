import 'package:flutter/material.dart';
import 'package:meal_planner_app/providers/meal_provider.dart';
import 'package:meal_planner_app/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => MealProvider(),
      child: const MealPlannerApp(),
    ),
  );
}

class MealPlannerApp extends StatelessWidget {
  const MealPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Meal Planner App', home: HomeScreen());
  }
}
