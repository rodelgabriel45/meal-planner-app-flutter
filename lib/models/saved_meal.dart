class SavedMeal {
  final String name;
  final String details;
  final int calories;

  const SavedMeal({
    required this.name,
    required this.details,
    required this.calories,
  });

  Map<String, dynamic> toJson() {
    return {'name': name, 'details': details, 'calories': calories};
  }

  factory SavedMeal.fromJson(Map<String, dynamic> json) {
    return SavedMeal(
      name: json['name'] ?? '',
      details: json['details'] ?? '',
      calories: json['calories'] ?? 0,
    );
  }
}
