import 'dart:convert';

import 'package:meal_planner_app/models/meal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MealService {
  static const mealKey = 'meals';

  // Save Meals
  Future<void> saveMeals(List<Meal> meals) async {
    final prefs = await SharedPreferences.getInstance();

    final mealsJson = meals.map((meal) => meal.toJson()).toList();

    final mealsString = jsonEncode(mealsJson);

    await prefs.setString(mealKey, mealsString);
  }

  // Load Meals
  Future<List<Meal>> loadMeals() async {
    final prefs = await SharedPreferences.getInstance();

    final mealsString = prefs.getString(mealKey);

    if (mealsString == null) {
      return [];
    }

    final mealsJson = jsonDecode(mealsString);

    return (mealsJson as List).map((json) => Meal.fromJson(json)).toList();
  }
}
