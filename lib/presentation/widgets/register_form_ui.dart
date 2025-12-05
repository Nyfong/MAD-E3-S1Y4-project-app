// File: lib/widgets/register_form_ui.dart

import 'package:flutter/material.dart';

// Color definitions
const Color kPrimaryColor = Color(0xFF30A58B); // Teal/Sea Green
const Color kAccentColor = Color(0xFF30A58B); // Same as primary

class RegisterFormUI extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final bool isLoading;
  final VoidCallback onRegisterPressed;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onToggleConfirmPasswordVisibility;
  final VoidCallback onLoginPressed;

  const RegisterFormUI({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.isLoading,
    required this.onRegisterPressed,
    required this.onTogglePasswordVisibility,
    required this.onToggleConfirmPasswordVisibility,
    required this.onLoginPressed,
  });

  // --- Styled Input Decoration (Helper) ---
  InputDecoration _inputDecoration(String labelText, IconData icon) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(color: Colors.grey),
      prefixIcon: Icon(icon, color: kPrimaryColor.withOpacity(0.7)),
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: kPrimaryColor, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 15.0),
    );
  }

  // --- Main Build Method ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(28.0, 40.0, 28.0, 24.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Icon/Logo
                  const SizedBox(height: 16), // Spacing adjusted

                  // 1. Icon/Logo - UPDATED TO USE IMAGE.ASSET
                  //
                  Center(
                    child: Container(
                      width: 100, // Matching the size of the logo in LoginFormUI
                      height: 100, // Matching the size of the logo in LoginFormUI
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50), // Circular shape
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/logo.png', // <-- Your specific image path
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback in case the image asset is missing
                            return Icon(
                              Icons.emoji_objects_rounded,
                              size: 70,
                              color: Colors.grey.shade400,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. Title
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: kPrimaryColor, // Branded color
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Join us to start creating your favorite recipes!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // 3. Name Input
                  TextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    decoration: _inputDecoration('Full Name', Icons.person_rounded),
                    validator: (value) {
                      if (value == null || value.length < 2) {
                        return 'Name must be at least 2 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // 4. Email Input
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _inputDecoration('Email', Icons.email_rounded),
                    validator: (value) {
                      if (value == null || !value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // 5. Password Input
                  TextFormField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    decoration: _inputDecoration('Password', Icons.lock_rounded).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                          color: kPrimaryColor.withOpacity(0.7),
                        ),
                        onPressed: onTogglePasswordVisibility,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // 6. Confirm Password Input
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: obscureConfirmPassword,
                    decoration: _inputDecoration('Confirm Password', Icons.lock_open_rounded).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureConfirmPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                          color: kPrimaryColor.withOpacity(0.7),
                        ),
                        onPressed: onToggleConfirmPasswordVisibility,
                      ),
                    ),
                    validator: (value) {
                      if (value != passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 40),

                  // 7. Register Button
                  ElevatedButton(
                    onPressed: isLoading ? null : onRegisterPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor, // Branded color
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // Consistent large radius
                      ),
                      elevation: 8,
                      shadowColor: kPrimaryColor.withOpacity(0.5),
                    ),
                    child: isLoading
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(kAccentColor),
                      ),
                    )
                        : const Text(
                      'Register',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 8. Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                      ),
                      TextButton(
                        onPressed: onLoginPressed,
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: kPrimaryColor, // Branded color
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: kPrimaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}