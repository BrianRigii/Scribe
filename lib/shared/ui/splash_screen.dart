import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:scribe/features/auth/services/auth_service.dart';
import 'package:scribe/features/auth/ui/auth_screen.dart';
import 'package:scribe/core/theme.dart';
import 'package:scribe/features/landing/home_screen.dart';

class SplashScreen extends StatefulWidget {
  static const path = '/';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  _checkAuthAndNavigate() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    // Check authentication state
    await authService.checkAuthState();

    // Simulate splash delay
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      // Navigate based on authentication status
      if (authService.status == AuthStatus.authenticated &&
          authService.currentUser != null) {
        context.go(HomeScreen.path);
      } else {
        context.go(AuthScreen.path);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? ScribeTheme.darkBackground : ScribeTheme.cream,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [ScribeTheme.darkBackground, ScribeTheme.panelDark]
                : [ScribeTheme.cream, ScribeTheme.sand],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? ScribeTheme.aiAccent.withValues(alpha: 0.2)
                      : ScribeTheme.olive.withValues(alpha: 0.1),
                  border: Border.all(
                    color: isDark ? ScribeTheme.aiAccent : ScribeTheme.olive,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.menu_book_rounded,
                  size: 56,
                  color: isDark ? ScribeTheme.aiAccent : ScribeTheme.olive,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Scribe',
                style: theme.textTheme.headlineLarge?.copyWith(
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your AI-powered reading companion',
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isDark ? ScribeTheme.aiAccent : ScribeTheme.olive,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
