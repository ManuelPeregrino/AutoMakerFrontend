import 'package:flutter/material.dart';
import '../core/constants/app_routes.dart';
import '../presentation/home/home_screen.dart';
import '../presentation/printers/printers_screen.dart';
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
        return MaterialPageRoute(builder: (_) => const PrintersScreen());
      case AppRoutes.reports:
        return MaterialPageRoute(builder: (_) => const ReportsScreen());
      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}
