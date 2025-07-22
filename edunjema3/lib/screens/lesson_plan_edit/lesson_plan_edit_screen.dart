import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:edunjema3/models/user_profile.dart';
import 'package:edunjema3/services/firestore_service.dart';
import 'package:edunjema3/utils/constants.dart';
import 'package:edunjema3/widgets/lesson_plan_form.dart'; // Import the new unified form
import 'package:edunjema3/models/lesson_plan.dart';

/// A screen for teachers to edit existing lesson plans.
class LessonPlanEditScreen extends StatefulWidget {
  /// The [LessonPlan] object to be edited.
  final LessonPlan lessonPlan;

  /// Creates a [LessonPlanEditScreen] instance.
  const LessonPlanEditScreen({super.key, required this.lessonPlan});

  @override
  State<LessonPlanEditScreen> createState() => _LessonPlanEditScreenState();
}

class _LessonPlanEditScreenState extends State<LessonPlanEditScreen> {
  UserProfile? _userProfile;
  bool _isLoadingProfile = true;
  bool _isSaving = false; // Loading state for saving

  final FirestoreService _firestoreService = FirestoreService();
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

  /// Handles saving the updated lesson plan.
  Future<void> _handleSaveLessonPlan(LessonPlan updatedLessonPlan) async {
    setState(() {
      _isSaving = true;
    });

    try {
      if (updatedLessonPlan.id == null) {
        throw Exception('Cannot update a lesson plan without an ID.');
      }

      // Convert LessonPlan object to a map for Firestore update
      // Note: Firestore update only takes a map of fields to change.
      // We'll pass the entire updatedLessonPlan's toFirestore() map,
      // and Firestore will handle merging/overwriting.
      await _firestoreService.updateLessonPlan(updatedLessonPlan.id!, updatedLessonPlan.toFirestore());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lesson Plan updated successfully!')),
      );
      Navigator.of(context).pop(); // Go back to detail screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update lesson plan: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingProfile) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Lesson Plan')),
        body: const Center(child: CircularProgressIndicator(color: AppConstants.primaryColor)),
      );
    }

    if (_userProfile == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Lesson Plan')),
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
        title: const Text('Edit Lesson Plan'),
      ),
      body: Stack(
        children: [
          LessonPlanForm(
            initialLessonPlan: widget.lessonPlan,
            userProfile: _userProfile!,
            onSave: _handleSaveLessonPlan,
          ),
          if (_isSaving)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(color: AppConstants.primaryColor),
              ),
            ),
        ],
      ),
    );
  }
}
