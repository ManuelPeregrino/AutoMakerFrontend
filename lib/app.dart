import 'package:flutter/material.dart';
import 'core/constants/app_routes.dart';
import 'core/constants/app_styles.dart';
import 'routing/app_router.dart';

class AutoMakerApp extends StatelessWidget {
  const AutoMakerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutoMaker',
      theme: ThemeData(
        primaryColor: AppStyles.primaryColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppStyles.primaryColor,
          primary: AppStyles.primaryColor,
          secondary: AppStyles.accentColor, // Set secondary color from AppStyles
        ),
        textTheme: AppStyles.textTheme, // Define this in AppStyles
      ),
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
