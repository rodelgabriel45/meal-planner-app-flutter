import 'package:flutter/material.dart';
import 'package:meal_planner_app/models/meal.dart';
import 'package:meal_planner_app/widgets/meal_form_dialog.dart';
import 'package:meal_planner_app/widgets/meal_list.dart';
import 'package:provider/provider.dart';
import 'package:meal_planner_app/providers/meal_provider.dart';
import 'package:meal_planner_app/widgets/header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (mounted) {
        context.read<MealProvider>().loadMeals();
      }
    });
  }

  Future<void> openAddMeal() async {
    final Meal? meal = await showDialog<Meal>(
      context: context,
      builder: (context) {
        return const MealFormDialog(title: 'Add a new meal');
      },
    );

    if (meal == null) return;

    if (mounted) {
      context.read<MealProvider>().addMeal(meal);
    }
  }

  Future<void> openEditMeal(Meal oldMeal) async {
    final Meal? updatedMeal = await showDialog<Meal>(
      context: context,
      builder: (context) {
        return MealFormDialog(title: 'Edit Meal', meal: oldMeal);
      },
    );

    if (updatedMeal == null) return;

    if (mounted) {
      context.read<MealProvider>().updateMeal(oldMeal, updatedMeal);
    }
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
              MealList(openEditMeal: openEditMeal),
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
