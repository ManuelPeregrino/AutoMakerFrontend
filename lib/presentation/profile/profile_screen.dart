import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profile_view_model.dart';
import '../../core/constants/app_routes.dart'; // Import your routes

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProfileViewModel>(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/app_icon.png'),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${viewModel.firstName ?? 'User'} ${viewModel.lastName ?? ''}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    // TODO: Implement profile edit functionality
                  },
                  icon: const Icon(Icons.edit, color: Colors.orange),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              viewModel.email ?? 'Email not available',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.account_circle),
                const SizedBox(width: 8),
                Text(viewModel.role ?? 'Role not set'),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text(
                'Conectar con Octoprint',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.link),
                onPressed: viewModel.toggleConnecting,
              ),
            ),
            if (viewModel.isConnecting)
              Column(
                children: [
                  const SizedBox(height: 16),
                  TextField(
                    controller: viewModel.octoprintLinkController,
                    decoration: const InputDecoration(
                      labelText: 'Enlace de OctoPrint',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      viewModel.connectToOctoprint();
                    },
                    child: viewModel.isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text('Conectar'),
                  ),
                  if (viewModel.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        viewModel.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text(
                'Cambiar plan',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Plan Free'),
              onTap: () {},
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: viewModel.isLoadingReport
                  ? null
                  : () {
                      viewModel.generateReport();
                    },
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Generar Reporte PDF'),
            ),
            if (viewModel.isLoadingReport)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: CircularProgressIndicator(),
              ),
            if (viewModel.reportErrorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  viewModel.reportErrorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 32),
            TextButton(
              onPressed: () {
                // Logout functionality
                viewModel.logout();
                // Navigate back to login screen
                Navigator.of(context).pushReplacementNamed(AppRoutes.signIn);
              },
              child: const Text(
                'Cerrar Sesión',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
