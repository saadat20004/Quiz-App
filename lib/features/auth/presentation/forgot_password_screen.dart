import 'package:flutter/material.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../routes/app_routes.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Column(
              children: [
                const AppTextField(
                  hintText: 'Enter your email',
                  prefixIcon: Icons.email_outlined,
                ),
                const SizedBox(height: AppSizes.lg),
                AppButton(
                  text: 'Send Reset Link',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Reset link sent successfully'),
                      ),
                    );

                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.login,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}