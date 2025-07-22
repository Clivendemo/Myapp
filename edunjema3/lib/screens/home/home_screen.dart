import 'package:flutter/material.dart';
import 'package:edunjema3/services/auth_service.dart';
import 'package:edunjema3/utils/constants.dart';
//import 'package:edunjema3/widgets/custom_button.dart';
import 'package:edunjema3/screens/profile/profile_screen.dart';
//import 'package:edunjema3/screens/lesson_plan_edit/lesson_plan_edit_screen.dart';
import 'package:edunjema3/screens/generated_plans/generated_plans_screen.dart';
import 'package:edunjema3/screens/notes_generator/notes_generator_screen.dart';
import 'package:edunjema3/screens/faq/faq_screen.dart';
import 'package:edunjema3/screens/subscription/subscription_screen.dart';
import 'package:edunjema3/screens/lesson_plan_editor.dart/lesson_plan_editor_screen.dart';

/// The main home screen displayed after a user successfully logs in.
class HomeScreen extends StatelessWidget {
  /// Creates a [HomeScreen] instance.
  const HomeScreen({super.key});

  /// Handles the user logout process.
  ///
  /// [context] The current build context.
  void _handleLogout(BuildContext context) async {
    try {
      await AuthService().signOut();
      // No need to navigate explicitly, AuthFlowWrapper will handle it via stream
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('edunjema3 Lesson Planner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _handleLogout(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.largePadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.school,
                size: 100,
                color: AppConstants.primaryColor.withOpacity(0.7),
              ),
              const SizedBox(height: AppConstants.largePadding),
              Text(
                'Welcome to your Lesson Planner!',
                style: AppConstants.headline5.copyWith(color: AppConstants.primaryColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.mediumPadding),
              Text(
                'Start generating amazing lesson plans and notes tailored to the KICD syllabus.',
                style: AppConstants.bodyText1.copyWith(color: AppConstants.mutedTextColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.largePadding),
              Expanded( // Use Expanded to allow GridView to take available space
                child: GridView.count(
                  crossAxisCount: 2, // Two columns
                  crossAxisSpacing: AppConstants.mediumPadding,
                  mainAxisSpacing: AppConstants.mediumPadding,
                  childAspectRatio: 1.5, // Adjust aspect ratio for button size
                  shrinkWrap: true, // Important for GridView inside Column/Expanded
                  physics: const NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
                  children: [
                    _buildFeatureButton(
                      context,
                      'Start Planning',
                      Icons.create_new_folder,
                      AppConstants.accentColor,
                      () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const LessonPlanEditorScreen()),
                      ),
                    ),
                    _buildFeatureButton(
                      context,
                      'Generate Notes',
                      Icons.notes,
                      AppConstants.primaryColor.withOpacity(0.9),
                      () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const NotesGeneratorScreen()),
                      ),
                    ),
                    _buildFeatureButton(
                      context,
                      'View Saved Plans',
                      Icons.collections_bookmark,
                      AppConstants.primaryColor.withOpacity(0.8),
                      () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const GeneratedPlansScreen()),
                      ),
                    ),
                    _buildFeatureButton(
                      context,
                      'Edit Profile',
                      Icons.person,
                      AppConstants.mutedTextColor.withOpacity(0.8),
                      () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const ProfileScreen()),
                      ),
                    ),
                    _buildFeatureButton(
                      context,
                      'Subscription',
                      Icons.card_membership,
                      AppConstants.primaryColor.withOpacity(0.7),
                      () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const SubscriptionScreen()),
                      ),
                    ),
                    _buildFeatureButton(
                      context,
                      'FAQ',
                      Icons.help_outline,
                      AppConstants.primaryColor.withOpacity(0.6),
                      () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const FAQScreen()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureButton(BuildContext context, String text, IconData icon, Color color, VoidCallback onPressed) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.mediumPadding),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppConstants.mediumPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              text,
              style: AppConstants.bodyText1.copyWith(color: AppConstants.textColor, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
