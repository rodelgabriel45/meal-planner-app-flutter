enum MealCategory { breakfast, lunch, dinner, snack }

extension MealCategoryExtension on MealCategory {
  String get displayName {
    switch (this) {
      case MealCategory.breakfast:
        return 'Breakfast';
      case MealCategory.lunch:
        return 'Lunch';
      case MealCategory.dinner:
        return 'Dinner';
      case MealCategory.snack:
        return 'Snack';
    }
  }
}

class Meal {
  final String name;
  final String details;
  final MealCategory category;
  bool isCompleted;
  final int calories;

  Meal({
    required this.name,
    required this.details,
    required this.category,
    this.isCompleted = false,
    required this.calories,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'details': details,
      'category': category.name,
      'isCompleted': isCompleted,
      'calories': calories,
    };
  }

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      name: json['name'],
      details: json['details'],
      category: MealCategory.values.firstWhere(
        (c) => c.name == json['category'],
      ),
      isCompleted: json['isCompleted'] ?? false,
      calories: json['calories'] ?? 0,
    );
  }
}
