import 'package:flutter/material.dart';
import 'package:meal_planner_app/models/saved_meal.dart';
import 'package:meal_planner_app/services/saved_meal_service.dart';

class SavedMealProvider extends ChangeNotifier {
  final SavedMealService _savedMealService = SavedMealService();

  List<SavedMeal> _savedMeals = [];

  List<SavedMeal> get savedMeals => _savedMeals;

  Future<void> loadMeals() async {
    _savedMeals = await _savedMealService.loadMeals();

    notifyListeners();
  }

  Future<void> addMeal(SavedMeal meal) async {
    _savedMeals.add(meal);

    await _savedMealService.saveMeals(_savedMeals);

    notifyListeners();
  }

  Future<void> deleteMeal(SavedMeal meal) async {
    _savedMeals.remove(meal);

    await _savedMealService.saveMeals(_savedMeals);

    notifyListeners();
  }
}
