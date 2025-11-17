import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:scribe/features/auth/services/auth_service.dart';
import 'package:scribe/features/auth/ui/auth_form.dart';
import 'package:scribe/features/landing/home_screen.dart';
import 'package:scribe/core/theme.dart';

class AuthScreen extends StatefulWidget {
  static const String path = '/auth';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthMode _authMode = AuthMode.login;
  void _toggleAuthMode() {
    setState(() {
      _authMode = _authMode == AuthMode.login
          ? AuthMode.signup
          : AuthMode.login;
    });
  }

  void onAuthenticationSubmit(Map<String, String> authData) async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);

      if (_authMode == AuthMode.login) {
        await authService.login(authData['email']!, authData['password']!);
      } else {
        await authService.signUp(authData['email']!, authData['password']!);
      }

      // Navigate to home screen after successful authentication
      if (mounted && authService.status == AuthStatus.authenticated) {
        context.go(HomeScreen.path);
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Authentication failed: ${e.toString()}',
              style: TextStyle(color: ScribeTheme.cream),
            ),
            backgroundColor: ScribeTheme.bronze,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthForm(
      onSubmit: onAuthenticationSubmit,
      authMode: _authMode,
      onToggleAuthMode: _toggleAuthMode,
    );
  }
}

enum AuthMode { signup, login }
