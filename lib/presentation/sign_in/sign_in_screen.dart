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
                      'AUTOMAKER',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
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
                    if (viewModel.qrImageBytes == null) ...[
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              // Mostrar el modal para restablecer la contraseña
                              _showResetPasswordDialog(context, viewModel);
                            },
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
                    if (viewModel.qrImageBytes != null) ...[
                      const Text(
                        'Scan this QR code with your authenticator app',
                        textAlign: TextAlign.center,
                        style: AppStyles.bodyText,
                      ),
                      const SizedBox(height: 16),
                      Image.memory(viewModel.qrImageBytes!),
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

  // Método para mostrar el modal de restablecer contraseña
  void _showResetPasswordDialog(
      BuildContext context, SignInViewModel viewModel) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController codeController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(viewModel.isResetCodeSent
                  ? 'Enter Reset Code'
                  : 'Reset Password'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!viewModel.isResetCodeSent) ...[
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Enter your email',
                        ),
                      ),
                    ] else ...[
                      Text('Enter the code sent to ${emailController.text}'),
                      const SizedBox(height: 16),
                      TextField(
                        controller: codeController,
                        decoration: const InputDecoration(
                          labelText: 'Reset Code',
                        ),
                        maxLength: 6,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          labelText: 'New Password',
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: confirmPasswordController,
                        decoration: const InputDecoration(
                          labelText: 'Confirm Password',
                        ),
                        obscureText: true,
                      ),
                    ],
                    if (viewModel.isLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: CircularProgressIndicator(),
                      ),
                    if (viewModel.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          viewModel.errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    if (!viewModel.isResetCodeSent) {
                      // Request reset code
                      final success = await viewModel
                          .requestPasswordReset(emailController.text);
                      if (success) {
                        setState(() {}); // Refresh the dialog
                      }
                    } else {
                      // Validate passwords match
                      if (passwordController.text !=
                          confirmPasswordController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Passwords do not match')),
                        );
                        return;
                      }

                      // Reset password with code
                      final success = await viewModel.resetPasswordWithCode(
                        emailController.text,
                        codeController.text,
                        passwordController.text,
                      );

                      if (success && context.mounted) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Password reset successfully')),
                        );
                      }
                    }
                  },
                  child: Text(viewModel.isResetCodeSent
                      ? 'Reset Password'
                      : 'Send Code'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
