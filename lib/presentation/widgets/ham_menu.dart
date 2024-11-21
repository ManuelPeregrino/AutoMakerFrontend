import 'package:flutter/material.dart';
import '../../core/constants/app_routes.dart';

class HamMenu extends StatelessWidget {
  const HamMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.home);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.profile);
            },
          ),
          ListTile(
            leading: const Icon(Icons.print),
            title: const Text('Printers'),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.printers);
            },
          ),
          ListTile(
            leading: const Icon(Icons.print),
            title: const Text('Printer'),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.printer);
            },
          ),
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text('Sign In'),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.signIn);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_add),
            title: const Text('Sign Up'),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.signUp);
            },
          ),
        ],
      ),
    );
  }
}
