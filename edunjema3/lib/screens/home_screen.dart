import 'package:flutter/material.dart';
// REMOVED: import 'package:flutter_riverpod/flutter_riverpod.dart';
// REMOVED: import '../providers/auth_provider.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart'; // NEW: Import AuthService

class HomeScreen extends StatelessWidget { // MODIFIED: Changed to StatelessWidget
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) { // MODIFIED: Removed WidgetRef ref
    final AuthService authService = AuthService(); // NEW: Instantiate AuthService

    final List<Map<String, dynamic>> features = [
      {'name': 'Lesson Plan Generator', 'icon': Icons.school, 'route': '/lesson-plan-generator'},
      {'name': 'Notes Generator', 'icon': Icons.edit_note, 'route': '/notes-generator'},
      {'name': 'Saved Plans', 'icon': Icons.save, 'route': '/saved-plans'},
      {'name': 'Settings', 'icon': Icons.settings, 'route': '/settings'},
      {'name': 'FAQs / Help', 'icon': Icons.help_outline, 'route': '/faq-help'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher AI Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut(); // MODIFIED: Use authService directly
              // GoRouter will automatically redirect to '/' due to authStateChanges listener
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Text(
                'Welcome, Teacher!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 1.2,
              ),
              itemCount: features.length,
              itemBuilder: (context, index) {
                final feature = features[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      context.go(feature['route']);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            feature['icon'],
                            size: 48,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            feature['name'],
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
