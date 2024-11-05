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
                    const Text(
                      'Enter your login credentials and submit to access your account',
                      textAlign: TextAlign.center,
                      style: AppStyles.bodyText,
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      onChanged: (value) {
                        viewModel.setUsername(value);
                      },
                      decoration: AppStyles.inputDecoration.copyWith(
                        labelText: 'Username',
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
                    if (viewModel.isLoading) const CircularProgressIndicator(),
                    if (!viewModel.isLoading)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            await viewModel.signIn();
                            if (viewModel.errorMessage == null &&
                                context.mounted) {
                              Navigator.pushReplacementNamed(
                                  context, AppRoutes.home);
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
