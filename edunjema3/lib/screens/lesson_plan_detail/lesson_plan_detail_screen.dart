import 'package:flutter/material.dart';
import 'package:edunjema3/models/lesson_plan.dart';
import 'package:edunjema3/utils/constants.dart';
import 'package:intl/intl.dart'; // For date formatting
//import 'package:edunjema3/widgets/custom_button.dart'; // Import CustomButton
import 'package:edunjema3/screens/lesson_plan_edit/lesson_plan_edit_screen.dart'; // Import edit screen

/// A screen to display the full details of a generated lesson plan.
class LessonPlanDetailScreen extends StatelessWidget {
  /// The [LessonPlan] object to display.
  final LessonPlan lessonPlan;

  /// Creates a [LessonPlanDetailScreen].
  const LessonPlanDetailScreen({super.key, required this.lessonPlan});

  /// Helper method to build a section title.
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.mediumPadding),
      child: Text(
        title,
        style: AppConstants.headline5.copyWith(color: AppConstants.primaryColor),
      ),
    );
  }

  /// Helper method to build a sub-section title.
  Widget _buildSubSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: AppConstants.mediumPadding, bottom: AppConstants.smallPadding),
      child: Text(
        title,
        style: AppConstants.headline6.copyWith(color: AppConstants.primaryColor),
      ),
    );
  }

  /// Helper method to build a list of items.
  Widget _buildItemList(List<String>? items) {
    if (items == null || items.isEmpty) {
      return Text('N/A', style: AppConstants.bodyText1.copyWith(fontStyle: FontStyle.italic));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) => Padding(
        padding: const EdgeInsets.only(bottom: AppConstants.smallPadding / 2),
        child: Text('• $item', style: AppConstants.bodyText1),
      )).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lesson Plan Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Lesson Plan',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => LessonPlanEditScreen(lessonPlan: lessonPlan),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Page Details
            Center(
              child: Column(
                children: [
                  Text(
                    'Lesson Plan',
                    style: AppConstants.headline4.copyWith(color: AppConstants.primaryColor),
                  ),
                  const SizedBox(height: AppConstants.mediumPadding),
                  Text(
                    'Teacher: ${lessonPlan.teacherName}',
                    style: AppConstants.headline6,
                  ),
                  Text(
                    'Level: ${lessonPlan.level}',
                    style: AppConstants.headline6,
                  ),
                  Text(
                    'Subject: ${lessonPlan.subject}',
                    style: AppConstants.headline6,
                  ),
                  Text(
                    'Date: ${DateFormat('dd MMMM yyyy').format(lessonPlan.date)}',
                    style: AppConstants.bodyText1.copyWith(color: AppConstants.mutedTextColor),
                  ),
                  if (lessonPlan.enrollment != null && lessonPlan.enrollment!.isNotEmpty)
                    Text(
                      'Enrollment: ${lessonPlan.enrollment}',
                      style: AppConstants.bodyText1.copyWith(color: AppConstants.mutedTextColor),
                    ),
                  const SizedBox(height: AppConstants.largePadding),
                ],
              ),
            ),

            // Syllabus Specifics
            if (lessonPlan.syllabusType == 'CBC') ...[
              _buildSectionTitle('CBC Specifics'),
              _buildSubSectionTitle('Strand: ${lessonPlan.strand ?? 'N/A'}'),
              _buildSubSectionTitle('Sub-Strand: ${lessonPlan.subStrand ?? 'N/A'}'),
              _buildSubSectionTitle('Specific Learning Outcomes (KSA):'),
              _buildItemList(lessonPlan.specificLearningOutcomes),
            ] else if (lessonPlan.syllabusType == '8-4-4') ...[
              _buildSectionTitle('8-4-4 Specifics'),
              _buildSubSectionTitle('Topic: ${lessonPlan.topic ?? 'N/A'}'),
              _buildSubSectionTitle('Sub-Topic: ${lessonPlan.subTopic ?? 'N/A'}'),
              _buildSubSectionTitle('Objectives:'),
              _buildItemList(lessonPlan.objectives),
            ],

            // Common Details
            _buildSectionTitle('Key Inquiry Question'),
            Text(lessonPlan.keyInquiryQuestion, style: AppConstants.bodyText1),

            _buildSectionTitle('Core Competencies'),
            _buildItemList(lessonPlan.coreCompetencies),

            _buildSectionTitle('Values'),
            _buildItemList(lessonPlan.values),

            _buildSectionTitle('Pertinent & Contemporary Issues (PCIs)'),
            _buildItemList(lessonPlan.pci),

            _buildSectionTitle('Life Skills'),
            _buildItemList(lessonPlan.lifeSkills),

            // Lesson Body
            _buildSectionTitle('Lesson Body (Duration: ${lessonPlan.durationMinutes} minutes)'),
            _buildSubSectionTitle('Introduction'),
            Text(lessonPlan.introduction, style: AppConstants.bodyText1),

            _buildSubSectionTitle('Lesson Development'),
            if (lessonPlan.lessonDevelopment.isEmpty)
              Text('N/A', style: AppConstants.bodyText1.copyWith(fontStyle: FontStyle.italic))
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: lessonPlan.lessonDevelopment.asMap().entries.map((entry) {
                  int idx = entry.key;
                  LessonDevelopmentStep step = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppConstants.smallPadding),
                    child: Text(
                      '${idx + 1}. ${step.activity} (${step.durationMinutes} mins)',
                      style: AppConstants.bodyText1,
                    ),
                  );
                }).toList(),
              ),

            _buildSubSectionTitle('Extended Activity'),
            Text(lessonPlan.extendedActivity, style: AppConstants.bodyText1),

            _buildSubSectionTitle('Conclusion'),
            Text(lessonPlan.conclusion, style: AppConstants.bodyText1),

            _buildSubSectionTitle('Summary'),
            Text(lessonPlan.summary, style: AppConstants.bodyText1),

            _buildSubSectionTitle('Reflection'),
            Text(lessonPlan.reflection, style: AppConstants.bodyText1),

            // Cross-Curricular Links
            _buildSectionTitle('Cross-Curricular Links'),
            _buildSubSectionTitle('Community Service Learning'),
            Text(lessonPlan.communityServiceLearning ?? 'N/A', style: AppConstants.bodyText1),

            _buildSubSectionTitle('Non-Formal Activity'),
            Text(lessonPlan.nonFormalActivity ?? 'N/A', style: AppConstants.bodyText1),

            _buildSubSectionTitle('Links to Other Subjects'),
            _buildItemList(lessonPlan.linksToOtherSubjects),

            const SizedBox(height: AppConstants.largePadding),
          ],
        ),
      ),
    );
  }
}
