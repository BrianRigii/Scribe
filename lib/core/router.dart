import 'package:go_router/go_router.dart';
import 'package:scribe/features/auth/ui/auth_screen.dart';
import 'package:scribe/features/landing/home_screen.dart';
import 'package:scribe/shared/ui/splash_screen.dart';

class AppRouter {
  static GoRouter get routes {
    return GoRouter(
      initialLocation: SplashScreen.path,
      routes: [
        GoRoute(
          path: SplashScreen.path,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: AuthScreen.path,
          builder: (context, state) => const AuthScreen(),
        ),
        GoRoute(
          path: HomeScreen.path,
          builder: (context, state) => const HomeScreen(),
        ),
      ],
    );
  }
}
