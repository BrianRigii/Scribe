import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribe/core/theme.dart';
import 'package:scribe/features/books/books_service.dart';

class HomeScreen extends StatefulWidget {
  static const String path = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleUploadBook() async {
    try {
      await Provider.of<BookService>(
        context,
        listen: false,
      ).pickAndUploadBook();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Book uploaded successfully!'),
            backgroundColor: ScribeTheme.olive,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleTryAlice() {
    // TODO: Implement Alice in Wonderland demo
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Alice in Wonderland demo coming soon!'),
        backgroundColor: ScribeTheme.aiAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTabletOrDesktop = constraints.maxWidth > 600;
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTabletOrDesktop ? 48.0 : 24.0,
                      vertical: 24.0,
                    ),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          const ScribeAppBar(),
                          const SizedBox(height: 40),
                          Expanded(
                            child: Center(
                              child: Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 800,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const ScribeHeroSection(),
                                    const SizedBox(height: 48),
                                    const AIFeatureCard(),
                                    const SizedBox(height: 40),
                                    ActionButtonsSection(
                                      onUploadBook: _handleUploadBook,
                                      onTryAlice: _handleTryAlice,
                                      isWideScreen: constraints.maxWidth > 500,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ScribeAppBar extends StatelessWidget {
  const ScribeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: isDark ? ScribeTheme.panelDark : ScribeTheme.sand,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: (isDark ? Colors.black : Colors.black12).withOpacity(
                    0.1,
                  ),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.book_outlined,
              size: 28,
              color: isDark ? ScribeTheme.darkTextPrimary : ScribeTheme.ink,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Scribe',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class ScribeHeroSection extends StatelessWidget {
  const ScribeHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        // Decorative Icon
        Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ScribeTheme.aiAccent.withOpacity(0.1),
                ScribeTheme.olive.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: ScribeTheme.aiAccent.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: ScribeTheme.aiAccent.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            Icons.auto_stories,
            size: 48,
            color: isDark ? ScribeTheme.aiAccent : ScribeTheme.olive,
          ),
        ),
        const SizedBox(height: 32),

        // Main Title
        Text(
          'Your Library Awaits',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineLarge?.copyWith(
            fontSize: 40,
            fontWeight: FontWeight.w600,
            letterSpacing: -1.0,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 16),

        // Subtitle
        Text(
          'Transform your reading experience with AI-powered insights\nand personalized literary exploration',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 18,
            height: 1.5,
            color: isDark
                ? ScribeTheme.darkTextSecondary
                : ScribeTheme.mutedText,
          ),
        ),
      ],
    );
  }
}

class AIFeatureCard extends StatelessWidget {
  const AIFeatureCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        color: isDark ? ScribeTheme.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? ScribeTheme.aiAccent.withOpacity(0.2)
              : ScribeTheme.aiAccent.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.black12).withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // AI Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: ScribeTheme.aiAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: ScribeTheme.aiAccent.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_awesome, size: 16, color: ScribeTheme.aiAccent),
                const SizedBox(width: 8),
                Text(
                  'AI Companion',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: ScribeTheme.aiAccent,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Feature Description
          Text(
            'Meet your intelligent reading companion',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Ask questions about characters, explore themes, and discover connections across your entire library with our advanced AI assistant.',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 15,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ActionButtonsSection extends StatelessWidget {
  const ActionButtonsSection({
    super.key,
    required this.onUploadBook,
    required this.onTryAlice,
    required this.isWideScreen,
  });

  final VoidCallback onUploadBook;
  final VoidCallback onTryAlice;
  final bool isWideScreen;

  @override
  Widget build(BuildContext context) {
    if (isWideScreen) {
      return Row(
        children: [
          Expanded(child: PrimaryActionButton(onPressed: onUploadBook)),
          const SizedBox(width: 16),
          Expanded(child: SecondaryActionButton(onPressed: onTryAlice)),
        ],
      );
    }

    return Column(
      children: [
        PrimaryActionButton(onPressed: onUploadBook),
        const SizedBox(height: 16),
        SecondaryActionButton(onPressed: onTryAlice),
      ],
    );
  }
}

class PrimaryActionButton extends StatelessWidget {
  const PrimaryActionButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ScribeTheme.olive.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: ScribeTheme.olive,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.upload_file, size: 20),
            const SizedBox(width: 12),
            Text(
              'Upload Your First Book',
              style: theme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondaryActionButton extends StatelessWidget {
  const SecondaryActionButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? ScribeTheme.aiAccent.withOpacity(0.3)
              : ScribeTheme.aiAccent.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: ScribeTheme.aiAccent.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: isDark
              ? ScribeTheme.aiAccent.withOpacity(0.05)
              : ScribeTheme.aiAccent.withOpacity(0.03),
          foregroundColor: ScribeTheme.aiAccent,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_awesome, size: 20),
            const SizedBox(width: 12),
            Text(
              'Try Alice in Wonderland',
              style: theme.textTheme.labelLarge?.copyWith(
                color: ScribeTheme.aiAccent,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
