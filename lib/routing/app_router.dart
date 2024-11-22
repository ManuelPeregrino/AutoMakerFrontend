import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_routes.dart';
import '../presentation/home/home_screen.dart';
import '../presentation/printers/printers_list_screen.dart';
import '../presentation/printer/printer_screen.dart';
import '../presentation/profile/profile_screen.dart';
import '../presentation/profile/profile_view_model.dart';
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
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => ProfileViewModel(),
            child: const ProfileScreen(),
          ),
        );
      case AppRoutes.printers:
        return MaterialPageRoute(builder: (_) => const PrintersListScreen());
      case AppRoutes.printer:
        final printerId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => PrinterScreen(printerId: printerId),
        );
      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}
