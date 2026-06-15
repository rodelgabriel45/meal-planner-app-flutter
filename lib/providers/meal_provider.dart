import 'package:flutter/foundation.dart';
import 'package:meal_planner_app/models/meal.dart';
import 'package:meal_planner_app/services/meal_service.dart';

class MealProvider extends ChangeNotifier {
  final MealService _mealService = MealService();

  List<Meal> _meals = [];

  List<Meal> get meals => _meals;

  Future<void> loadMeals() async {
    _meals = await _mealService.loadMeals();

    notifyListeners();
  }

  Future<void> addMeal(Meal meal) async {
    _meals.add(meal);

    await _mealService.saveMeals(_meals);

    notifyListeners();
  }

  Future<void> deleteMeal(Meal meal) async {
    _meals.remove(meal);

    await _mealService.saveMeals(_meals);

    notifyListeners();
  }

  Future<void> toggleMeal(Meal meal) async {
    meal.isCompleted = !meal.isCompleted;

    await _mealService.saveMeals(_meals);

    notifyListeners();
  }

  Future<void> updateMeal(Meal oldMeal, Meal updatedMeal) async {
    final index = _meals.indexOf(oldMeal);

    _meals[index] = updatedMeal;

    await _mealService.saveMeals(_meals);

    notifyListeners();
  }

  double get progress {
    if (_meals.isEmpty) return 0;

    final completed = _meals.where((meal) => meal.isCompleted).length;

    return completed / _meals.length;
  }

  List<Meal> mealsByCategory(MealCategory category) {
    return _meals.where((meal) => meal.category == category).toList();
  }
}
