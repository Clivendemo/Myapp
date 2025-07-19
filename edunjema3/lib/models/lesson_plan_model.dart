class LessonPlanModel {
  final String id;
  final String userId;
  final String subject;
  final String className;
  final String topic;
  final String objectives;
  final String content;
  final String activities;
  final String evaluation;
  final String resources;
  final DateTime createdAt;
  final DateTime? updatedAt;

  LessonPlanModel({
    required this.id,
    required this.userId,
    required this.subject,
    required this.className,
    required this.topic,
    required this.objectives,
    required this.content,
    required this.activities,
    required this.evaluation,
    required this.resources,
    required this.createdAt,
    this.updatedAt,
  });

  factory LessonPlanModel.fromMap(Map<String, dynamic> map) {
    return LessonPlanModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      subject: map['subject'] ?? '',
      className: map['className'] ?? '',
      topic: map['topic'] ?? '',
      objectives: map['objectives'] ?? '',
      content: map['content'] ?? '',
      activities: map['activities'] ?? '',
      evaluation: map['evaluation'] ?? '',
      resources: map['resources'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: map['updatedAt'] != null 
          ? DateTime.parse(map['updatedAt']) 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'subject': subject,
      'className': className,
      'topic': topic,
      'objectives': objectives,
      'content': content,
      'activities': activities,
      'evaluation': evaluation,
      'resources': resources,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
