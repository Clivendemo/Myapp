import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:edunjema3/models/lesson_plan.dart';
import 'package:edunjema3/services/firestore_service.dart';
import 'package:edunjema3/utils/constants.dart';
import 'package:edunjema3/widgets/plan_card.dart';
import 'package:edunjema3/screens/lesson_plan_detail/lesson_plan_detail_screen.dart'; // Import the new detail screen

/// A screen to display a list of generated lesson plans for the current user.
class GeneratedPlansScreen extends StatefulWidget {
  /// Creates a [GeneratedPlansScreen] instance.
  const GeneratedPlansScreen({super.key});

  @override
  State<GeneratedPlansScreen> createState() => _GeneratedPlansScreenState();
}

class _GeneratedPlansScreenState extends State<GeneratedPlansScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Lesson Plans')),
        body: const Center(
          child: Text('Please log in to view your lesson plans.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Lesson Plans'),
      ),
      body: StreamBuilder<List<LessonPlan>>(
        stream: _firestoreService.getLessonPlansForUser(_currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppConstants.primaryColor));
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error loading plans: ${snapshot.error}', style: AppConstants.bodyText1.copyWith(color: AppConstants.errorColor)),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.note_add, size: 80, color: AppConstants.mutedTextColor.withOpacity(0.5)),
                  const SizedBox(height: AppConstants.mediumPadding),
                  Text(
                    'No lesson plans generated yet.',
                    style: AppConstants.headline6.copyWith(color: AppConstants.mutedTextColor),
                  ),
                  const SizedBox(height: AppConstants.smallPadding),
                  Text(
                    'Tap the "Start Planning" button on the home screen to create your first plan!',
                    style: AppConstants.bodyText2.copyWith(color: AppConstants.mutedTextColor),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final lessonPlans = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(AppConstants.mediumPadding),
            itemCount: lessonPlans.length,
            itemBuilder: (context, index) {
              final plan = lessonPlans[index];
              return PlanCard(
                lessonPlan: plan,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LessonPlanDetailScreen(lessonPlan: plan),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
