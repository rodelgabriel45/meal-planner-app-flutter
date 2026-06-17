import 'package:flutter/material.dart';
import 'package:meal_planner_app/providers/meal_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mealProvider = context.read<MealProvider>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                Align(alignment: Alignment.topLeft, child: BackButton()),
              ],
            ),

            const Text(
              'Settings',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),

            const SizedBox(height: 16),

            ListTile(
              leading: Icon(Icons.delete),
              title: const Text('Clear meals'),
              onTap: () async {
                final shouldClear = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Clear meals'),
                      content: const Text(
                        'Are you sure you want to clear all meals?',
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
                          child: const Text('Clear'),
                        ),
                      ],
                    );
                  },
                );

                if (shouldClear == true) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Meals cleared')),
                    );
                  }

                  await mealProvider.clearMeals();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
