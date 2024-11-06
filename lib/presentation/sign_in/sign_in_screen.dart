import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_styles.dart';
import '../../core/constants/app_routes.dart';
import 'sign_in_view_model.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignInViewModel(),
      child: Scaffold(
        backgroundColor: AppStyles.backgroundColor,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Consumer<SignInViewModel>(
              builder: (context, viewModel, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 32),
                    const Text(
                      'Company Logo Here',
                      style: AppStyles.headline3,
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Sign In',
                      style: AppStyles.headline1,
                    ),
                    const SizedBox(height: 16),
                    // Mostrar formulario de login solo si no se muestra el QR
                    if (viewModel.qrImageBytes == null) ...[
                      const Text(
                        'Enter your login credentials and submit to access your account',
                        textAlign: TextAlign.center,
                        style: AppStyles.bodyText,
                      ),
                      const SizedBox(height: 32),
                      TextField(
                        onChanged: (value) {
                          viewModel.setEmail(value);
                        },
                        decoration: AppStyles.inputDecoration.copyWith(
                          labelText: 'Email',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        onChanged: (value) {
                          viewModel.setPassword(value);
                        },
                        obscureText: true,
                        decoration: AppStyles.inputDecoration.copyWith(
                          labelText: 'Password',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: viewModel.rememberMe,
                                onChanged: (value) {
                                  viewModel.setRememberMe(value ?? false);
                                },
                              ),
                              const Text('Remember Me'),
                            ],
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Forgot Password?',
                              style: AppStyles.linkText,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (viewModel.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            viewModel.errorMessage!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (viewModel.isLoading)
                        const CircularProgressIndicator(),
                      if (!viewModel.isLoading)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              await viewModel.signIn();
                              if (viewModel.errorMessage == null &&
                                  context.mounted) {
                                if (!viewModel.isTwoFactorEnabled) {
                                  // Si 2FA no está activado, muestra QR para configuración
                                  await viewModel.generateQrCode();
                                }
                              }
                            },
                            style: AppStyles.primaryButtonStyle,
                            child: const Text(
                              'Sign In',
                              style: AppStyles.buttonText,
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                    ],
                    // Campo para ingresar el código de 2FA si está activado
                    if (viewModel.isTwoFactorEnabled) ...[
                      TextField(
                        maxLength: 6,
                        keyboardType: TextInputType.number,
                        decoration: AppStyles.inputDecoration.copyWith(
                          labelText: '2FA Code',
                        ),
                        onChanged: (value) async {
                          if (value.length == 6) {
                            final isAuthenticated = await viewModel
                                .authenticateTwoFactorCode(value);
                            if (isAuthenticated && context.mounted) {
                              Navigator.pushReplacementNamed(
                                  context, AppRoutes.home);
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Mostrar QR para configuración de 2FA si es necesario
                    if (viewModel.qrImageBytes != null) ...[
                      const Text(
                        'Scan this QR code with your authenticator app',
                        textAlign: TextAlign.center,
                        style: AppStyles.bodyText,
                      ),
                      const SizedBox(
                          height: 16), // Espacio entre el texto y la imagen QR
                      Image.memory(viewModel
                          .qrImageBytes!), // Mostrar la imagen QR desde los bytes
                      const SizedBox(height: 16),
                      TextField(
                        maxLength: 6,
                        keyboardType: TextInputType.number,
                        decoration: AppStyles.inputDecoration.copyWith(
                          labelText: '2FA Code',
                        ),
                        onChanged: (value) {
                          if (value.length == 6) {
                            viewModel
                                .verifyTwoFactorCode(value)
                                .then((isValid) {
                              if (isValid && context.mounted) {
                                Navigator.pushReplacementNamed(
                                    context, AppRoutes.home);
                              }
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.signUp);
                      },
                      child: const Text(
                        "Don't have an account? Sign up",
                        style: AppStyles.linkText,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
