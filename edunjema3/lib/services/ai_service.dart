import 'dart:convert';
import 'package:http/http.dart' as http; // Using http package for demonstration
import 'package:edunjema3/models/lesson_plan.dart'; // Import LessonPlan model

/// A service class for interacting with an AI model to generate lesson plans and notes.
class AiService {
  // TODO: Replace with your actual AI API endpoint
  // This is a placeholder URL. In a real app, this would be your backend endpoint
  // that securely calls the actual AI model (e.g., OpenAI, Gemini, Grok).
  // Example: 'https://your-app-name.vercel.app/api/generate'
  final String _aiApiEndpoint = 'https://your-backend-ai-api.com/generate'; // Unified endpoint for different AI tasks

  /// Generates a lesson plan using an AI model based on the provided input.
  ///
  /// [lessonPlanInput] A [LessonPlan] object containing the user's input
  /// for the lesson plan. This object will be converted into a prompt for the AI.
  ///
  /// Returns a [Map<String, dynamic>] representing the generated lesson plan content.
  /// Throws an [Exception] if the AI generation fails.
  Future<Map<String, dynamic>> generateLessonPlan(LessonPlan lessonPlanInput) async {
    try {
      final Map<String, dynamic> promptData = {
        'type': 'lesson_plan', // Indicate the type of generation
        'teacherName': lessonPlanInput.teacherName,
        'level': lessonPlanInput.level,
        'subject': lessonPlanInput.subject,
        'syllabusType': lessonPlanInput.syllabusType,
        'durationMinutes': lessonPlanInput.durationMinutes,
        'keyInquiryQuestion': lessonPlanInput.keyInquiryQuestion,
        'introduction': lessonPlanInput.introduction,
        'extendedActivity': lessonPlanInput.extendedActivity,
        'conclusion': lessonPlanInput.conclusion,
        'summary': lessonPlanInput.summary,
        'reflection': lessonPlanInput.reflection,
        'coreCompetencies': lessonPlanInput.coreCompetencies,
        'values': lessonPlanInput.values,
        'pci': lessonPlanInput.pci,
        'lifeSkills': lessonPlanInput.lifeSkills,
        'linksToOtherSubjects': lessonPlanInput.linksToOtherSubjects,
        'communityServiceLearning': lessonPlanInput.communityServiceLearning,
        'nonFormalActivity': lessonPlanInput.nonFormalActivity,
        'lessonDevelopmentSteps': lessonPlanInput.lessonDevelopment.map((s) => s.toMap()).toList(),
      };

      if (lessonPlanInput.syllabusType == 'CBC') {
        promptData['strand'] = lessonPlanInput.strand;
        promptData['subStrand'] = lessonPlanInput.subStrand;
        promptData['specificLearningOutcomes'] = lessonPlanInput.specificLearningOutcomes;
      } else { // 8-4-4
        promptData['topic'] = lessonPlanInput.topic;
        promptData['subTopic'] = lessonPlanInput.subTopic;
        promptData['objectives'] = lessonPlanInput.objectives;
      }

      print('Sending lesson plan prompt to AI: $promptData');

      final response = await http.post(
        Uri.parse(_aiApiEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(promptData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> generatedContent = jsonDecode(response.body);
        return generatedContent;
      } else {
        throw Exception('Failed to generate lesson plan: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Error during AI lesson plan generation: $e');
    }
  }

  /// Generates study notes using an AI model based on the provided input.
  ///
  /// [notesInput] A [Map<String, dynamic>] containing details like 'subject',
  /// 'level', 'topic', and 'keywords' for notes generation.
  ///
  /// Returns a [Map<String, dynamic>] representing the generated notes content.
  /// Throws an [Exception] if the AI generation fails.
  Future<Map<String, dynamic>> generateNotes(Map<String, dynamic> notesInput) async {
    try {
      final Map<String, dynamic> promptData = {
        'type': 'notes', // Indicate the type of generation
        'subject': notesInput['subject'],
        'level': notesInput['level'],
        'topic': notesInput['topic'],
        'keywords': notesInput['keywords'],
      };

      print('Sending notes prompt to AI: $promptData');

      final response = await http.post(
        Uri.parse(_aiApiEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(promptData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> generatedContent = jsonDecode(response.body);
        return generatedContent;
      } else {
        throw Exception('Failed to generate notes: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Error during AI notes generation: $e');
    }
  }

  /// Fetches curriculum topics/strands from AI based on subject, level, and syllabus type.
  ///
  /// [subject] The selected subject.
  /// [level] The selected academic level/grade.
  /// [syllabusType] The selected syllabus type ('CBC' or '8-4-4').
  ///
  /// Returns a [List<String>] of suggested topics/strands.
  /// Throws an [Exception] if the AI generation fails.
  Future<List<String>> fetchCurriculumTopics({
    required String subject,
    required String level,
    required String syllabusType,
  }) async {
    try {
      final Map<String, dynamic> promptData = {
        'type': 'topics', // Indicate the type of generation
        'subject': subject,
        'level': level,
        'syllabusType': syllabusType,
      };

      print('Sending topics prompt to AI: $promptData');

      final response = await http.post(
        Uri.parse(_aiApiEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(promptData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> generatedContent = jsonDecode(response.body);
        // Expecting 'topics' key with a comma-separated string or JSON array
        final String topicsString = generatedContent['topics'] ?? '';
        if (topicsString.isEmpty) return [];
        return topicsString.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
      } else {
        throw Exception('Failed to fetch topics: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Error during AI topics fetching: $e');
    }
  }

  /// Generates a Key Inquiry Question (KIQ) from AI based on curriculum details.
  ///
  /// [subject] The selected subject.
  /// [level] The selected academic level/grade.
  /// [syllabusType] The selected syllabus type ('CBC' or '8-4-4').
  /// [strandTopic] The selected strand or topic.
  ///
  /// Returns a [String] representing the generated KIQ.
  /// Throws an [Exception] if the AI generation fails.
  Future<String> generateKeyInquiryQuestion({
    required String subject,
    required String level,
    required String syllabusType,
    required String strandTopic,
  }) async {
    try {
      final Map<String, dynamic> promptData = {
        'type': 'kiq', // Indicate the type of generation
        'subject': subject,
        'level': level,
        'syllabusType': syllabusType,
        'strandTopic': strandTopic,
      };

      print('Sending KIQ prompt to AI: $promptData');

      final response = await http.post(
        Uri.parse(_aiApiEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(promptData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> generatedContent = jsonDecode(response.body);
        // Expecting 'kiq' key with the generated question
        return generatedContent['kiq'] ?? 'Could not generate Key Inquiry Question.';
      } else {
        throw Exception('Failed to generate KIQ: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Error during AI KIQ generation: $e');
    }
  }
}
