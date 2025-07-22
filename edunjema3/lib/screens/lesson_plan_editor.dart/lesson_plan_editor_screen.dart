import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:edunjema3/models/user_profile.dart';
import 'package:edunjema3/services/firestore_service.dart';
import 'package:edunjema3/utils/constants.dart';
import 'package:edunjema3/widgets/lesson_plan_form.dart'; // Import the new unified form
import 'package:edunjema3/models/lesson_plan.dart';
import 'package:edunjema3/services/ai_service.dart'; // Import AiService

/// A screen for teachers to create new lesson plans using the AI.
class LessonPlanEditorScreen extends StatefulWidget {
  /// Creates a [LessonPlanEditorScreen] instance.
  const LessonPlanEditorScreen({super.key});

  @override
  State<LessonPlanEditorScreen> createState() => _LessonPlanEditorScreenState();
}

class _LessonPlanEditorScreenState extends State<LessonPlanEditorScreen> {
  UserProfile? _userProfile;
  bool _isLoadingProfile = true; // Loading state for profile
  bool _isGenerating = false; // Loading state for AI generation

  final FirestoreService _firestoreService = FirestoreService();
  final AiService _aiService = AiService(); // AI Service instance
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  /// Loads the user profile to pass to the form.
  Future<void> _loadUserProfile() async {
    if (_currentUser == null) {
      setState(() {
        _isLoadingProfile = false;
      });
      return;
    }
    try {
      final profile = await _firestoreService.getUserProfile(_currentUser!.uid);
      if (profile != null) {
        setState(() {
          _userProfile = profile;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user profile: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoadingProfile = false;
      });
    }
  }

  /// Handles the generation and saving of the lesson plan using AI.
  Future<void> _handleGenerateAndSaveLessonPlan(LessonPlan lessonPlanInput) async {
    setState(() {
      _isGenerating = true;
    });

    try {
      final generatedContent = await _aiService.generateLessonPlan(lessonPlanInput);

      // Assuming generatedContent contains the full lesson plan structure
      // You might need to parse and merge generated parts back into a LessonPlan object
      // For now, we'll just save the original input plan and show a message.
      // In a real scenario, you'd update lessonPlanInput with generated parts
      // before saving, or save the generatedContent directly if it's a complete plan.

      // Example: If AI returns a complete plan, you'd do:
      // final LessonPlan finalLessonPlan = LessonPlan.fromMap(generatedContent);
      // await _firestoreService.saveLessonPlan(finalLessonPlan);

      // For now, saving the input plan as a placeholder for the generated one
      final String newPlanId = await _firestoreService.saveLessonPlan(lessonPlanInput);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lesson Plan generated and saved successfully! ID: $newPlanId')),
      );
      Navigator.of(context).pop(); // Go back after saving
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate or save lesson plan: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingProfile) {
      return Scaffold(
        appBar: AppBar(title: const Text('Create Lesson Plan')),
        body: const Center(child: CircularProgressIndicator(color: AppConstants.primaryColor)),
      );
    }

    if (_userProfile == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Create Lesson Plan')),
        body: Center(
          child: Text(
            'User profile not found. Please log in again.',
            style: AppConstants.bodyText1.copyWith(color: AppConstants.errorColor),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Lesson Plan'),
      ),
      body: Stack(
        children: [
          LessonPlanForm(
            userProfile: _userProfile!,
            onSave: _handleGenerateAndSaveLessonPlan,
          ),
          if (_isGenerating)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppConstants.accentColor),
                    SizedBox(height: AppConstants.mediumPadding),
                    Text(
                      'Generating Lesson Plan...',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
