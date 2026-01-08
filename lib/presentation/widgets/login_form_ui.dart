// File: lib/presentation/widgets/login_form_ui.dart

import 'package:flutter/material.dart';

// Color definitions (must be included or imported)
const Color kPrimaryColor = Color(0xFF30A58B); // Teal/Sea Green
const Color kAccentColor = Color(0xFF30A58B); // Teal/Sea Green

// --- CircularLogo Widget (MERGED & PRIVATE) ---
class _CircularLogo extends StatelessWidget {
  final double size;
  final String imagePath;

  const _CircularLogo({
    required this.size,
    this.imagePath = 'assets/images/logo.png', // Default asset name
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size / 2),
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
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.emoji_objects_rounded,
                size: size * 0.7,
                color: Colors.grey.shade400,
              );
            },
          ),
        ),
      ),
    );
  }
}
// --- End CircularLogo Widget ---


class LoginFormUI extends StatelessWidget {
  // Properties passed from the LoginScreenState
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool isLoading;
  final bool isGoogleLoading;
  final bool isPhoneLoading;

  // Action Callbacks passed from the LoginScreenState
  final VoidCallback onLoginPressed;
  final VoidCallback onGoogleLoginPressed;
  final VoidCallback onPhoneLoginPressed;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onRegisterPressed;

  const LoginFormUI({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.isLoading,
    required this.isGoogleLoading,
    required this.isPhoneLoading,
    required this.onLoginPressed,
    required this.onGoogleLoginPressed,
    required this.onPhoneLoginPressed,
    required this.onTogglePasswordVisibility,
    required this.onRegisterPressed,
  });

  // --- Styled Input Decoration (Helper Function) ---
  InputDecoration _inputDecoration(String labelText, IconData icon) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(color: Colors.grey),
      // Uses the new primary color
      prefixIcon: Icon(icon, color: kPrimaryColor.withOpacity(0.7)),
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        // Uses the new primary color
        borderSide: const BorderSide(color: kPrimaryColor, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 15.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(28.0, 40.0, 28.0, 24.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Logo
              const _CircularLogo(size: 100),

              const SizedBox(height: 16),

              // 2. Title
              const Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  // Uses the new primary color
                  color: kPrimaryColor,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Time to dive into delicious recipes ',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // 3. Email Input
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

              // 4. Password Input
              TextFormField(
                controller: passwordController,
                obscureText: obscurePassword,
                decoration: _inputDecoration('Password', Icons.lock_rounded).copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                      // Uses the new primary color
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

              const SizedBox(height: 40),

              // 5. Main Login Button
              ElevatedButton(
                onPressed: isLoading ? null : onLoginPressed,
                style: ElevatedButton.styleFrom(
                  // Uses the new primary color
                  backgroundColor: kPrimaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 8,
                  // Uses the new primary color for shadow
                  shadowColor: kPrimaryColor.withOpacity(0.5),
                ),
                child: isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    // Uses the accent color (same as primary)
                    valueColor: AlwaysStoppedAnimation<Color>(kAccentColor),
                  ),
                )
                    : const Text(
                  'Log In',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 30),

              // 6. OR Divider
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'OR CONNECT WITH',
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
                ],
              ),

              const SizedBox(height: 30),

              // 7. Social/Phone Buttons

              // Google Sign-In Button
              OutlinedButton(
                onPressed: isGoogleLoading ? null : onGoogleLoginPressed,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                child: isGoogleLoading
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  // Uses the new primary color
                  child: CircularProgressIndicator(strokeWidth: 2, color: kPrimaryColor),
                )
                    : Image.asset(
                  'assets/images/google_logo.png',
                  height: 20,
                ),
              ),

              const SizedBox(height: 12),

              // Phone Sign-In Button
              OutlinedButton.icon(
                onPressed: isPhoneLoading ? null : onPhoneLoginPressed,
                // Uses the new primary color
                icon: const Icon(Icons.phone_android_rounded, color: kPrimaryColor),
                label: const Text('Phone'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
              ),

              const SizedBox(height: 30),

              // 8. Register Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "New here?",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                  ),
                  TextButton(
                    onPressed: onRegisterPressed,
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        // Uses the new primary color
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        // Uses the new primary color
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
    );
  }
}