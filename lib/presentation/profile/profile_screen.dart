import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profile_view_model.dart';

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
              backgroundImage: AssetImage('assets/profile_image.png'),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Eduardo VH',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, color: Colors.orange),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Nombre de la granja',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_circle),
                SizedBox(width: 8),
                Text("Eduardo's Farm"),
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
              onPressed: () {},
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
