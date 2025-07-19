import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart';
import '../../services/auth_service.dart';
import 'home_tile.dart';
import '../generator/plan_generator.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        automaticallyImplyLeading: false,
        actions: [
          Consumer<AuthService>(
            builder: (context, authService, child) {
              final user = authService.currentUser;
              return Padding(
                padding: const EdgeInsets.only(right: AppConstants.paddingMedium),
                child: Row(
                  children: [
                    if (user != null && !user.hasActivePremium)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.paddingSmall,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppConstants.warningColor,
                          borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                        ),
                        child: Text(
                          '${AppConstants.freePlanLimit - user.generatedPlansCount} free left',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    const SizedBox(width: AppConstants.paddingSmall),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.person),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Consumer<AuthService>(
                builder: (context, authService, child) {
                  final user = authService.currentUser;
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppConstants.paddingLarge),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppConstants.primaryColor, AppConstants.accentColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back, ${user?.displayName ?? 'Teacher'}!',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: AppConstants.paddingSmall),
                        const Text(
                          'Ready to create amazing KICD-aligned lesson plans?',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        if (user != null && !user.hasActivePremium) ...[
                          const SizedBox(height: AppConstants.paddingMedium),
                          Container(
                            padding: const EdgeInsets.all(AppConstants.paddingMedium),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.info_outline, color: Colors.white),
                                const SizedBox(width: AppConstants.paddingSmall),
                                Expanded(
                                  child: Text(
                                    'You have ${AppConstants.freePlanLimit - user.generatedPlansCount} free lesson plans remaining',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
              
              const SizedBox(height: AppConstants.paddingXLarge),
              
              // Quick Actions Title
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textPrimary,
                ),
              ),
              
              const SizedBox(height: AppConstants.paddingMedium),
              
              // Main Features Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: AppConstants.paddingMedium,
                mainAxisSpacing: AppConstants.paddingMedium,
                childAspectRatio: 1.1,
                children: [
                  HomeTile(
                    icon: Icons.school,
                    label: 'My Subjects',
                    subtitle: 'Pick class, subject, topic',
                    color: AppConstants.primaryColor,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('My Subjects - Coming Soon!')),
                      );
                    },
                  ),
                  HomeTile(
                    icon: Icons.description,
                    label: 'Create Lesson Plan',
                    subtitle: 'AI-powered generator',
                    color: AppConstants.secondaryColor,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PlanGenerator(),
                        ),
                      );
                    },
                  ),
                  HomeTile(
                    icon: Icons.menu_book,
                    label: 'Notes Generator',
                    subtitle: 'AI teaching notes',
                    color: AppConstants.accentColor,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Notes Generator - Coming Soon!')),
                      );
                    },
                  ),
                  HomeTile(
                    icon: Icons.folder,
                    label: 'My Saved Plans',
                    subtitle: 'Access previous plans',
                    color: Colors.orange,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Saved Plans - Coming Soon!')),
                      );
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: AppConstants.paddingLarge),
              
              // Additional Features
              const Text(
                'More Features',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textPrimary,
                ),
              ),
              
              const SizedBox(height: AppConstants.paddingMedium),
              
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: AppConstants.paddingMedium,
                mainAxisSpacing: AppConstants.paddingMedium,
                childAspectRatio: 1.1,
                children: [
                  HomeTile(
                    icon: Icons.stars,
                    label: 'Upgrade',
                    subtitle: 'Premium plans',
                    color: Colors.purple,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Upgrade - Coming Soon!')),
                      );
                    },
                  ),
                  HomeTile(
                    icon: Icons.settings,
                    label: 'Settings',
                    subtitle: 'App preferences',
                    color: Colors.grey,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Settings - Coming Soon!')),
                      );
                    },
                  ),
                  HomeTile(
                    icon: Icons.help_outline,
                    label: 'Help & Support',
                    subtitle: 'FAQs & contact',
                    color: Colors.teal,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Help & Support - Coming Soon!')),
                      );
                    },
                  ),
                  HomeTile(
                    icon: Icons.person,
                    label: 'Profile',
                    subtitle: 'Manage account',
                    color: AppConstants.primaryColor,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
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
