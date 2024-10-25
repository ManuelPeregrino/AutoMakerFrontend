import 'package:flutter/material.dart';
import '../../core/constants/app_styles.dart';
import '../../core/constants/app_routes.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo placeholder
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
                decoration: AppStyles.inputDecoration.copyWith(
                  labelText: 'Username'
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: AppStyles.inputDecoration.copyWith(
                  labelText: 'Password'
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: rememberMe,
                        onChanged: (value) {
                          setState(() {
                            rememberMe = value ?? false;
                          });
                        },
                      ),
                      const Text('Remember Me'),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: AppStyles.linkText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
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
          ),
        ),
      ),
    );
  }
}
