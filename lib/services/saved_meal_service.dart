import 'dart:convert';

import 'package:meal_planner_app/models/saved_meal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedMealService {
  static const _savedMealKey = 'saved_meals';

  Future<void> saveMeals(List<SavedMeal> meals) async {
    final prefs = await SharedPreferences.getInstance();

    final mealsJson = meals.map((meal) => meal.toJson()).toList();

    final mealsString = jsonEncode(mealsJson);

    await prefs.setString(_savedMealKey, mealsString);
  }

  Future<List<SavedMeal>> loadMeals() async {
    final prefs = await SharedPreferences.getInstance();

    final mealsString = prefs.getString(_savedMealKey);

    if (mealsString == null) {
      return [];
    }

    final mealsJson = jsonDecode(mealsString);

    return (mealsJson as List).map((json) => SavedMeal.fromJson(json)).toList();
  }
}
