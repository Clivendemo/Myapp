import 'package:flutter/material.dart';
import 'package:edunjema3/utils/constants.dart';

/// A screen displaying Frequently Asked Questions.
class FAQScreen extends StatelessWidget {
  /// Creates a [FAQScreen] instance.
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frequently Asked Questions'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.mediumPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'General Questions',
              style: AppConstants.headline5.copyWith(color: AppConstants.primaryColor),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            _buildExpansionTile(
              context,
              'What is edunjema3 Lesson Planner?',
              'edunjema3 Lesson Planner is an AI-powered tool designed to help teachers in Kenya generate comprehensive lesson plans and study notes tailored to the KICD syllabus (CBC and 8-4-4).',
            ),
            _buildExpansionTile(
              context,
              'Which syllabi are supported?',
              'We currently support both the Competency-Based Curriculum (CBC/CBE) and the 8-4-4 syllabus.',
            ),
            _buildExpansionTile(
              context,
              'Is my data safe?',
              'Yes, your data is securely stored using Firebase Firestore, and we adhere to strict privacy policies.',
            ),
            const SizedBox(height: AppConstants.largePadding),
            Text(
              'Lesson Plan Generation',
              style: AppConstants.headline5.copyWith(color: AppConstants.primaryColor),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            _buildExpansionTile(
              context,
              'How accurate are the generated lesson plans?',
              'Our AI model is trained on extensive educational content to provide highly relevant and structured lesson plans. However, we always recommend reviewing and customizing them to fit your specific classroom needs.',
            ),
            _buildExpansionTile(
              context,
              'Can I edit a generated lesson plan?',
              'Yes, after a lesson plan is generated, you can view its details and make further edits to customize it before saving or printing.',
            ),
            const SizedBox(height: AppConstants.largePadding),
            Text(
              'Account & Subscription',
              style: AppConstants.headline5.copyWith(color: AppConstants.primaryColor),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            _buildExpansionTile(
              context,
              'Do I need a subscription to use the app?',
              'A free tier is available with limited features. A premium subscription unlocks unlimited lesson plan and notes generation, along with other advanced features.',
            ),
            _buildExpansionTile(
              context,
              'How do I subscribe?',
              'You can subscribe directly within the app via the "Subscription" section, which will guide you through the payment process.',
            ),
            const SizedBox(height: AppConstants.largePadding),
          ],
        ),
      ),
    );
  }

  Widget _buildExpansionTile(BuildContext context, String title, String content) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.smallPadding),
      ),
      child: ExpansionTile(
        title: Text(
          title,
          style: AppConstants.headline6.copyWith(color: AppConstants.textColor),
        ),
        childrenPadding: const EdgeInsets.all(AppConstants.mediumPadding),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            content,
            style: AppConstants.bodyText1.copyWith(color: AppConstants.mutedTextColor),
          ),
        ],
      ),
    );
  }
}
