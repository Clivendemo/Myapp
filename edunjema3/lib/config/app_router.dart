import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// REMOVED: import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/auth_screen.dart';
import '../screens/home_screen.dart';
// REMOVED: import '../providers/auth_provider.dart';
import '../screens/settings_screen.dart';
import '../screens/lesson_plan_generator_screen.dart';
import '../screens/notes_generator_screen.dart';
import 'dart:async';

// MODIFIED: Make GoRouter a global instance
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/lesson-plan-generator',
      builder: (context, state) => const LessonPlanGeneratorScreen(),
    ),
    GoRoute(
      path: '/notes-generator',
      builder: (context, state) => const NotesGeneratorScreen(),
    ),
    // NEW: Add routes for Saved Plans and FAQ/Help
    GoRoute(
      path: '/saved-plans',
      builder: (context, state) => const Center(child: Text('Saved Plans Screen (Coming Soon)')), // Placeholder
    ),
    GoRoute(
      path: '/faq-help',
      builder: (context, state) => const Center(child: Text('FAQ/Help Screen (Coming Soon)')), // Placeholder
    ),
  ],
  redirect: (context, state) {
    // MODIFIED: Directly check FirebaseAuth.instance.currentUser
    final isAuthenticated = FirebaseAuth.instance.currentUser != null;
    final isLoggingIn = state.matchedLocation == '/';

    if (!isAuthenticated && !isLoggingIn) {
      return '/'; // Redirect to login if not authenticated and not on login page
    }
    if (isAuthenticated && isLoggingIn) {
      return '/home'; // Redirect to home if authenticated and on login page
    }
    return null; // No redirect needed
  },
  refreshListenable: GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
);

// Helper class to make GoRouter react to changes in a Stream
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
