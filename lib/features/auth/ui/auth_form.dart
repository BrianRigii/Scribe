import 'package:flutter/material.dart';

import 'package:scribe/core/theme.dart';
import 'package:scribe/features/auth/ui/auth_screen.dart';
import 'package:scribe/shared/primary_button.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({
    super.key,
    required this.onSubmit,
    required this.authMode,
    this.onToggleAuthMode,
  });
  final Function(Map<String, String>) onSubmit;
  final AuthMode authMode;
  final VoidCallback? onToggleAuthMode;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  late AnimationController _toggleController;
  late AnimationController _slideController;
  late AnimationController _fadeController;

  late Animation<double> _toggleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _toggleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _toggleAnimation = CurvedAnimation(
      parent: _toggleController,
      curve: Curves.easeInOut,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    // Start initial animations
    _slideController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _toggleController.dispose();
    _slideController.dispose();
    _fadeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    widget.onSubmit({
      'email': _emailController.text.trim(),
      'password': _passwordController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
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
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: SizedBox(
                    width: size.width > 400 ? 400 : double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 40),
                        _buildAuthCard(),
                        const SizedBox(height: 24),
                        _buildToggleButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark
                ? ScribeTheme.aiAccent.withValues(alpha: 0.15)
                : ScribeTheme.olive.withValues(alpha: 0.1),
            border: Border.all(
              color: isDark ? ScribeTheme.aiAccent : ScribeTheme.olive,
              width: 2,
            ),
          ),
          child: Icon(
            Icons.menu_book_rounded,
            size: 48,
            color: isDark ? ScribeTheme.aiAccent : ScribeTheme.olive,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Scribe',
          style: theme.textTheme.headlineLarge?.copyWith(letterSpacing: 1.2),
        ),
        const SizedBox(height: 8),
        Text(
          'Your AI-powered reading companion',
          style: theme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAuthCard() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : ScribeTheme.softGrey.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AnimatedBuilder(
                animation: _toggleAnimation,
                builder: (context, child) {
                  return Text(
                    widget.authMode == AuthMode.login
                        ? 'Welcome Back'
                        : 'Create Account',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  );
                },
              ),
              const SizedBox(height: 24),
              _buildEmailField(),
              const SizedBox(height: 16),
              _buildPasswordField(),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: widget.authMode == AuthMode.login
                    ? const SizedBox.shrink()
                    : Column(
                        children: [
                          const SizedBox(height: 16),
                          _buildConfirmPasswordField(),
                        ],
                      ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                onPressed: _submitForm,
                child: Text(
                  widget.authMode == AuthMode.login ? 'Login' : 'Sign Up',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: theme.textTheme.bodyMedium,
        prefixIcon: Icon(
          Icons.email_outlined,
          color: isDark ? ScribeTheme.aiAccent : ScribeTheme.olive,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark ? ScribeTheme.aiAccent : ScribeTheme.olive,
            width: 2,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: theme.textTheme.bodyMedium,
        prefixIcon: Icon(
          Icons.lock_outlined,
          color: isDark ? ScribeTheme.aiAccent : ScribeTheme.olive,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: isDark
                ? ScribeTheme.darkTextSecondary
                : ScribeTheme.mutedText,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark ? ScribeTheme.aiAccent : ScribeTheme.olive,
            width: 2,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (widget.authMode == AuthMode.signup && value.length < 8) {
          return 'Password must be at least 8 characters';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedOpacity(
      opacity: widget.authMode == AuthMode.login ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: TextFormField(
        controller: _confirmPasswordController,
        obscureText: _obscureConfirmPassword,
        style: theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          labelText: 'Confirm Password',
          labelStyle: theme.textTheme.bodyMedium,
          prefixIcon: Icon(
            Icons.lock_outlined,
            color: isDark ? ScribeTheme.aiAccent : ScribeTheme.olive,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirmPassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: isDark
                  ? ScribeTheme.darkTextSecondary
                  : ScribeTheme.mutedText,
            ),
            onPressed: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: isDark ? ScribeTheme.aiAccent : ScribeTheme.olive,
              width: 2,
            ),
          ),
        ),
        validator: widget.authMode == AuthMode.login
            ? null
            : (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
      ),
    );
  }

  Widget _buildToggleButton() {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _toggleAnimation,
      builder: (context, child) {
        return GestureDetector(
          onTap: widget.onToggleAuthMode,
          child: Text(
            widget.authMode == AuthMode.login
                ? "Don't have an account? Sign Up"
                : "Already have an account? Sign In",
            style: theme.textTheme.bodyMedium,
          ),
        );
      },
    );
  }
}
