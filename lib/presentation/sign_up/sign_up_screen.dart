import 'package:flutter/material.dart';
import '../../core/constants/app_styles.dart';
import '../../core/constants/app_routes.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
              // Logo or placeholder for company logo
              const SizedBox(height: 32),
              const Text(
                'Company Logo Here',
                style: AppStyles.headline3,
              ),
              const SizedBox(height: 32),
              // Sign Up Title
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
              // Username Input
              TextField(
                decoration: AppStyles.inputDecoration.copyWith(
                  labelText: 'Username'
                ),
              ),
              const SizedBox(height: 16),
              // Email Address Input
              TextField(
                decoration: AppStyles.inputDecoration.copyWith(
                  labelText: 'Email Address'
                ),
              ),
              const SizedBox(height: 16),
              // Password Input
              TextField(
                decoration: AppStyles.inputDecoration.copyWith(
                  labelText: 'Password',
                  hintText: '',
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle sign up action here
                  },
                  style: AppStyles.primaryButtonStyle,
                  child: const Text(
                    'Sign Up',
                    style: AppStyles.buttonText,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Link to Sign Up
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
          ),
        ),
      ),
    );
  }
}
