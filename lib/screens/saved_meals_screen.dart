import 'package:flutter/material.dart';
import 'package:meal_planner_app/providers/saved_meal_provider.dart';
import 'package:provider/provider.dart';

class SavedMealsScreen extends StatelessWidget {
  const SavedMealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Meals'), centerTitle: true),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),

            Expanded(
              child: Consumer<SavedMealProvider>(
                builder: (context, savedMealProvider, child) {
                  if (savedMealProvider.savedMeals.isEmpty) {
                    return const Text(
                      'No saved meals yet.',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    );
                  }

                  return ListView(
                    children: savedMealProvider.savedMeals.map((savedMeal) {
                      return ListTile(
                        title: Text(savedMeal.name),
                        subtitle: Text('${savedMeal.calories} kcal'),
                        trailing: IconButton(
                          onPressed: () async {
                            final shouldDelete = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Delete saved meal'),
                                  content: const Text(
                                    'Are you sure you want to delete this meal template?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, false);
                                      },
                                      child: const Text('Cancel'),
                                    ),

                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (shouldDelete == true) {
                              savedMealProvider.deleteMeal(savedMeal);
                            }
                          },
                          icon: Icon(Icons.delete),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
