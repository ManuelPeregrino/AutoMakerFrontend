import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_styles.dart';
import '../../core/constants/app_routes.dart';
import 'sign_up_view_model.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignUpViewModel(),
      child: Scaffold(
        backgroundColor: AppStyles.backgroundColor,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Consumer<SignUpViewModel>(
              builder: (context, viewModel, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 32),
                    const Text(
                      'AUTOMAKER',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Create Account',
                      style: AppStyles.headline1,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      onChanged: viewModel.setFirstName,
                      decoration: AppStyles.inputDecoration.copyWith(
                        labelText: 'First Name',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      onChanged: viewModel.setLastName,
                      decoration: AppStyles.inputDecoration.copyWith(
                        labelText: 'Last Name',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      onChanged: viewModel.setEmail,
                      decoration: AppStyles.inputDecoration.copyWith(
                        labelText: 'Email Address',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      onChanged: viewModel.setPassword,
                      obscureText: true,
                      decoration: AppStyles.inputDecoration.copyWith(
                        labelText: 'Password',
                      ),
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
                    if (viewModel.isLoading) const CircularProgressIndicator(),
                    if (!viewModel.isLoading)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            await viewModel.signUp();
                            if (viewModel.errorMessage == null &&
                                context.mounted) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Registration Successful'),
                                  content: const Text(
                                    'Your account has been successfully created. You can now log in.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.pushReplacementNamed(
                                            context, AppRoutes.signIn);
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          style: AppStyles.primaryButtonStyle,
                          child: const Text(
                            'Register',
                            style: AppStyles.buttonText,
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.signIn);
                      },
                      child: const Text(
                        "Already have an account? Sign in",
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
