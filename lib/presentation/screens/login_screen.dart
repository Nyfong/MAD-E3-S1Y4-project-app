// File: lib/presentation/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rupp_final_mad/presentation/providers/auth_provider.dart';
import 'package:rupp_final_mad/presentation/screens/home_screen.dart';
import 'package:rupp_final_mad/presentation/screens/phone_login_screen.dart';
import 'package:rupp_final_mad/presentation/screens/register_screen.dart';
import 'package:rupp_final_mad/presentation/widgets/login_form_ui.dart';

// --- Updated Color Palette (Teal/Sea Green: #30A58B) ---
const Color kPrimaryColor = Color(0xFF30A58B); // Teal/Sea Green
const Color kAccentColor = Color(0xFF30A58B); // Teal/Sea Green

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // --- Controllers and State ---
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _isPhoneLoading = false;
  AuthProvider? _authProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Store reference to auth provider when dependencies are available
    if (_authProvider == null) {
      _authProvider = Provider.of<AuthProvider>(context, listen: false);
      _authProvider?.addListener(_onAuthStateChanged);
    }
  }

  @override
  void dispose() {
    // Use stored reference instead of accessing context
    _authProvider?.removeListener(_onAuthStateChanged);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- Auth & Navigation Logic ---

  void _onAuthStateChanged() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isAuthenticated && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() { _isLoading = true; });

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      setState(() { _isLoading = false; });

      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid email or password'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleGoogleLogin() async {
    setState(() { _isGoogleLoading = true; });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.loginWithGoogle();

    setState(() { _isGoogleLoading = false; });

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Google sign-in failed. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handlePhoneLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PhoneLoginScreen(),
      ),
    );
  }

  void _navigateToRegister() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const RegisterScreen(),
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  // --- UI Build Method (Delegating to LoginFormUI) ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LoginFormUI(
          // Controllers and Keys
          formKey: _formKey,
          emailController: _emailController,
          passwordController: _passwordController,

          // State Variables
          obscurePassword: _obscurePassword,
          isLoading: _isLoading,
          isGoogleLoading: _isGoogleLoading,
          isPhoneLoading: _isPhoneLoading,

          // Action Callbacks
          onLoginPressed: _handleLogin,
          onGoogleLoginPressed: _handleGoogleLogin,
          onPhoneLoginPressed: _handlePhoneLogin,
          onTogglePasswordVisibility: _togglePasswordVisibility,
          onRegisterPressed: _navigateToRegister,
        ),
      ),
    );
  }
}