import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Asegúrate de que las rutas y los archivos estén correctamente configurados
import '../core/constants/app_routes.dart'; // Define las rutas utilizadas en la aplicación
import '../presentation/home/home_screen.dart'; // Pantalla principal de inicio
import '../presentation/printers/printers_list_screen.dart'; // Lista de impresoras
import '../presentation/printer/printer_screen.dart'; // Detalle de impresoras
import '../presentation/profile/profile_screen.dart'; // Pantalla del perfil
import '../presentation/profile/profile_view_model.dart'; // ViewModel del perfil
import '../presentation/sign_in/sign_in_screen.dart'; // Pantalla de inicio de sesión
import '../presentation/sign_up/sign_up_screen.dart'; // Pantalla de registro

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
        // Control de argumentos para evitar errores
        final printerId = settings.arguments as String? ?? 'Unknown';
        return MaterialPageRoute(
          builder: (_) => PrinterScreen(printerId: printerId),
        );
      default:
        // Ruta por defecto
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}
