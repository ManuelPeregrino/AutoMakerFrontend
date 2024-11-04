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
                      'Company Logo Here',
                      style: AppStyles.headline3,
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Sign Up',
                      style: AppStyles.headline1,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Complete the form below to register a new account.',
                      textAlign: TextAlign.center,
                      style: AppStyles.bodyText,
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      onChanged: viewModel.setUsername,
                      decoration: AppStyles.inputDecoration.copyWith(
                        labelText: 'Username',
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
                    if (viewModel.isLoading)
                      const CircularProgressIndicator(),
                    if (!viewModel.isLoading)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: viewModel.signUp,
                          style: AppStyles.primaryButtonStyle,
                          child: const Text(
                            'Sign Up',
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
