import 'package:flutter/material.dart';
import 'package:edunjema3/models/lesson_plan.dart';
import 'package:edunjema3/utils/constants.dart';
import 'package:intl/intl.dart'; // For date formatting, add to pubspec.yaml

/// A card widget to display a summary of a lesson plan.
class PlanCard extends StatelessWidget {
  /// The [LessonPlan] object to display.
  final LessonPlan lessonPlan;
  /// Callback function when the card is tapped.
  final VoidCallback onTap;

  /// Creates a [PlanCard].
  const PlanCard({
    super.key,
    required this.lessonPlan,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: AppConstants.smallPadding),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.mediumPadding),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.mediumPadding),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.mediumPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lessonPlan.syllabusType == 'CBC'
                    ? 'Strand: ${lessonPlan.strand ?? 'N/A'}'
                    : 'Topic: ${lessonPlan.topic ?? 'N/A'}',
                style: AppConstants.headline6.copyWith(color: AppConstants.primaryColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppConstants.smallPadding),
              Text(
                'Subject: ${lessonPlan.subject}',
                style: AppConstants.bodyText1,
              ),
              const SizedBox(height: AppConstants.smallPadding / 2),
              Text(
                'Level: ${lessonPlan.level}',
                style: AppConstants.bodyText1,
              ),
              const SizedBox(height: AppConstants.smallPadding / 2),
              Text(
                'Date: ${DateFormat('dd MMM yyyy').format(lessonPlan.date)}',
                style: AppConstants.bodyText2,
              ),
              const SizedBox(height: AppConstants.smallPadding),
              const Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: AppConstants.accentColor,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
