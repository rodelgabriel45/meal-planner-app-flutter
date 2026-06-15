enum MealCategory { breakfast, lunch, dinner }

extension MealCategoryExtension on MealCategory {
  String get displayName {
    switch (this) {
      case MealCategory.breakfast:
        return 'Breakfast';
      case MealCategory.lunch:
        return 'Lunch';
      case MealCategory.dinner:
        return 'Dinner';
    }
  }
}

class Meal {
  final String name;
  final String details;
  final MealCategory category;
  bool isCompleted;

  Meal({
    required this.name,
    required this.details,
    required this.category,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'details': details,
      'category': category.name,
      'isCompleted': isCompleted,
    };
  }

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      name: json['name'],
      details: json['details'],
      category: MealCategory.values.firstWhere(
        (c) => c.name == json['category'],
      ),
      isCompleted: json['isCompleted'],
    );
  }
}
