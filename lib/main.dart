import 'package:flutter/material.dart';
import 'package:meal_planner_app/providers/meal_provider.dart';
import 'package:meal_planner_app/providers/theme_provider.dart';
import 'package:meal_planner_app/screens/home_screen.dart';
import 'package:meal_planner_app/theme/app_theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MealProvider()),
        ChangeNotifierProvider(
          create: (_) {
            final provider = ThemeProvider();

            provider.loadTheme();

            return provider;
          },
        ),
      ],
      child: MealPlannerApp(),
    ),
  );
}

class MealPlannerApp extends StatelessWidget {
  const MealPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Meal Planner App',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          home: const HomeScreen(),
        );
      },
    );
  }
}
