import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a generated lesson plan, accommodating both CBC/CBE and 8-4-4 syllabi.
class LessonPlan {
  /// Unique ID of the lesson plan.
  final String? id;
  /// The ID of the teacher who created the lesson plan.
  final String teacherId;
  /// The name of the teacher as it appears on the title page.
  final String teacherName;
  /// The date the lesson plan was created or generated.
  final DateTime date;
  /// The academic level/grade for the lesson (e.g., 'Grade 3', 'Form 2').
  final String level;
  /// The subject of the lesson (e.g., 'Mathematics', 'Kiswahili').
  final String subject;
  /// The type of syllabus this lesson plan adheres to ('CBC' or '8-4-4').
  final String syllabusType;
  /// The duration of the entire lesson in minutes.
  final int durationMinutes;
  /// The enrollment number for printing.
  final String? enrollment; // Optional, for print version

  // --- CBC/CBE Specific Fields ---
  /// The broad area of learning for CBC.
  final String? strand;
  /// The specific topic within a strand for CBC.
  final String? subStrand;
  /// Specific learning outcomes for CBC (Knowledge, Skills, Attitudes).
  final List<String>? specificLearningOutcomes; // KSA

  // --- 8-4-4 Specific Fields ---
  /// The main topic for 8-4-4.
  final String? topic;
  /// The sub-topic for 8-4-4.
  final String? subTopic;
  /// Objectives for 8-4-4 syllabus.
  final List<String>? objectives;

  // --- Common Fields ---
  /// The central question guiding the lesson.
  final String keyInquiryQuestion;
  /// Relevant core competencies (e.g., Communication & Collaboration, Critical Thinking).
  final List<String> coreCompetencies;
  /// Values promoted in the lesson (e.g., Responsibility, Respect).
  final List<String> values;
  /// Pertinent and Contemporary Issues addressed (e.g., Environmental Education, Drug Abuse).
  final List<String> pci;
  /// Life skills integrated into the lesson (e.g., Self-awareness, Problem-solving).
  final List<String> lifeSkills;

  // --- Lesson Body Structure ---
  /// Content for the introduction phase of the lesson.
  final String introduction;
  /// Detailed breakdown of lesson development activities.
  final List<LessonDevelopmentStep> lessonDevelopment;
  /// Activities for extended learning or reinforcement.
  final String extendedActivity;
  /// Content for the conclusion phase.
  final String conclusion;
  /// Summary of the key points of the lesson.
  final String summary;
  /// Teacher's reflection on the lesson delivery and outcomes.
  final String reflection;

  // --- Cross-Curricular Links ---
  /// Link to community service learning activities.
  final String? communityServiceLearning;
  /// Link to non-formal activities.
  final String? nonFormalActivity;
  /// Links to other subjects.
  final List<String>? linksToOtherSubjects;

  /// Creates a [LessonPlan] instance.
  LessonPlan({
    this.id,
    required this.teacherId,
    required this.teacherName,
    required this.date,
    required this.level,
    required this.subject,
    required this.syllabusType,
    required this.durationMinutes,
    this.enrollment,
    // CBC
    this.strand,
    this.subStrand,
    this.specificLearningOutcomes,
    // 8-4-4
    this.topic,
    this.subTopic,
    this.objectives,
    // Common
    required this.keyInquiryQuestion,
    required this.coreCompetencies,
    required this.values,
    required this.pci,
    required this.lifeSkills,
    // Body
    required this.introduction,
    required this.lessonDevelopment,
    required this.extendedActivity,
    required this.conclusion,
    required this.summary,
    required this.reflection,
    // Links
    this.communityServiceLearning,
    this.nonFormalActivity,
    this.linksToOtherSubjects,
  });

  /// Creates a [LessonPlan] instance from a Firestore document snapshot.
  factory LessonPlan.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LessonPlan(
      id: doc.id,
      teacherId: data['teacherId'] ?? '',
      teacherName: data['teacherName'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      level: data['level'] ?? '',
      subject: data['subject'] ?? '',
      syllabusType: data['syllabusType'] ?? 'CBC',
      durationMinutes: data['durationMinutes'] ?? 0,
      enrollment: data['enrollment'],
      strand: data['strand'],
      subStrand: data['subStrand'],
      specificLearningOutcomes: List<String>.from(data['specificLearningOutcomes'] ?? []),
      topic: data['topic'],
      subTopic: data['subTopic'],
      objectives: List<String>.from(data['objectives'] ?? []),
      keyInquiryQuestion: data['keyInquiryQuestion'] ?? '',
      coreCompetencies: List<String>.from(data['coreCompetencies'] ?? []),
      values: List<String>.from(data['values'] ?? []),
      pci: List<String>.from(data['pci'] ?? []),
      lifeSkills: List<String>.from(data['lifeSkills'] ?? []),
      introduction: data['introduction'] ?? '',
      lessonDevelopment: (data['lessonDevelopment'] as List<dynamic>?)
              ?.map((step) => LessonDevelopmentStep.fromMap(step as Map<String, dynamic>))
              .toList() ??
          [],
      extendedActivity: data['extendedActivity'] ?? '',
      conclusion: data['conclusion'] ?? '',
      summary: data['summary'] ?? '',
      reflection: data['reflection'] ?? '',
      communityServiceLearning: data['communityServiceLearning'],
      nonFormalActivity: data['nonFormalActivity'],
      linksToOtherSubjects: List<String>.from(data['linksToOtherSubjects'] ?? []),
    );
  }

  /// Converts this [LessonPlan] instance into a JSON format suitable for Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'teacherId': teacherId,
      'teacherName': teacherName,
      'date': Timestamp.fromDate(date),
      'level': level,
      'subject': subject,
      'syllabusType': syllabusType,
      'durationMinutes': durationMinutes,
      'enrollment': enrollment,
      'strand': strand,
      'subStrand': subStrand,
      'specificLearningOutcomes': specificLearningOutcomes,
      'topic': topic,
      'subTopic': subTopic,
      'objectives': objectives,
      'keyInquiryQuestion': keyInquiryQuestion,
      'coreCompetencies': coreCompetencies,
      'values': values,
      'pci': pci,
      'lifeSkills': lifeSkills,
      'introduction': introduction,
      'lessonDevelopment': lessonDevelopment.map((step) => step.toMap()).toList(),
      'extendedActivity': extendedActivity,
      'conclusion': conclusion,
      'summary': summary,
      'reflection': reflection,
      'communityServiceLearning': communityServiceLearning,
      'nonFormalActivity': nonFormalActivity,
      'linksToOtherSubjects': linksToOtherSubjects,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}

/// Represents a single step within the lesson development phase, with duration.
class LessonDevelopmentStep {
  /// Description of the activity for this step.
  final String activity;
  /// Duration of this step in minutes.
  final int durationMinutes;

  /// Creates a [LessonDevelopmentStep] instance.
  LessonDevelopmentStep({
    required this.activity,
    required this.durationMinutes,
  });

  /// Creates a [LessonDevelopmentStep] instance from a map.
  factory LessonDevelopmentStep.fromMap(Map<String, dynamic> map) {
    return LessonDevelopmentStep(
      activity: map['activity'] ?? '',
      durationMinutes: map['durationMinutes'] ?? 0,
    );
  }

  /// Converts this [LessonDevelopmentStep] instance to a map.
  Map<String, dynamic> toMap() {
    return {
      'activity': activity,
      'durationMinutes': durationMinutes,
    };
  }
}
