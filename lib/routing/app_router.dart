import 'package:flutter/material.dart';
import '../core/constants/app_routes.dart';
import '../presentation/home/home_screen.dart';
import '../presentation/printers/printers_list_screen.dart';
import '../presentation/printer/printer_screen.dart';
import '../presentation/profile/profile_screen.dart';
import '../presentation/reports/reports_screen.dart';
import '../presentation/sign_in/sign_in_screen.dart';
import '../presentation/sign_up/sign_up_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.signIn:
        return MaterialPageRoute(builder: (_) => const SignInScreen());
      case AppRoutes.signUp:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case AppRoutes.printers:
        return MaterialPageRoute(builder: (_) => const PrintersListScreen());
      case AppRoutes.printer:
        final printerData = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => PrinterScreen(
            printerName: printerData['printerName'],
            status: printerData['status'],
            progress: printerData['progress'],
            extruderTemp: printerData['extruderTemp'],
            bedTemp: printerData['bedTemp'],
            statusColor: printerData['statusColor'],
          ),
        );

      case AppRoutes.reports:
        return MaterialPageRoute(builder: (_) => const ReportsScreen());
      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}
