class CBELessonPlanModel {
  final String id;
  final String userId;
  final String className;
  final String subject;
  final String topic;
  final String duration;
  final String keyInquiryQuestion;
  
  // Specific Learning Outcomes
  final String knowledgeOutcomes;
  final String skillsOutcomes;
  final String attitudesOutcomes;
  
  // CBE Components
  final List<String> coreCompetencies;
  final List<String> coreValues;
  final List<String> pcis;
  
  // Lesson Content
  final String learningExperiences;
  final String keyInquiryQuestions;
  final String learningResources;
  final String assessment;
  final String selfReflection;
  
  final DateTime createdAt;

  CBELessonPlanModel({
    required this.id,
    required this.userId,
    required this.className,
    required this.subject,
    required this.topic,
    required this.duration,
    required this.keyInquiryQuestion,
    required this.knowledgeOutcomes,
    required this.skillsOutcomes,
    required this.attitudesOutcomes,
    required this.coreCompetencies,
    required this.coreValues,
    required this.pcis,
    required this.learningExperiences,
    required this.keyInquiryQuestions,
    required this.learningResources,
    required this.assessment,
    required this.selfReflection,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'className': className,
      'subject': subject,
      'topic': topic,
      'duration': duration,
      'keyInquiryQuestion': keyInquiryQuestion,
      'knowledgeOutcomes': knowledgeOutcomes,
      'skillsOutcomes': skillsOutcomes,
      'attitudesOutcomes': attitudesOutcomes,
      'coreCompetencies': coreCompetencies,
      'coreValues': coreValues,
      'pcis': pcis,
      'learningExperiences': learningExperiences,
      'keyInquiryQuestions': keyInquiryQuestions,
      'learningResources': learningResources,
      'assessment': assessment,
      'selfReflection': selfReflection,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
