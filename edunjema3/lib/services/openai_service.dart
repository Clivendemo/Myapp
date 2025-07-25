import 'dart:convert';
//import 'package:http/http.dart' as http;

class OpenAIService {
  // IMPORTANT: Replace with your actual OpenAI API Key.
  // For production apps, consider securing this key on a backend (e.g., Firebase Functions).
  final String _apiKey = 'YOUR_OPENAI_API_KEY'; 
  final String _baseUrl = 'https://api.openai.com/v1/chat/completions';
  
  get http => null;

  Future<String> generateLessonPlan({
    required String syllabus,
    required String grade,
    required String subject,
    required String strandTopic,
    required String substrandSubtopic,
    required int numberOfStudents,
    required int lessonTimeMinutes,
  }) async {
    final String prompt;
    if (syllabus == 'CBC') {
      prompt = "Generate a detailed CBC lesson plan for Grade $grade, Subject: $subject, Strand: $strandTopic, Substrand: $substrandSubtopic. "
               "Include: Key Inquiry Question, Core Competencies, Values, PCI links. "
               "Structure: Introduction (5 mins), Lesson Development (30 mins), Conclusion (5 mins). "
               "Number of students: $numberOfStudents. Lesson time: $lessonTimeMinutes minutes. "
               "Ensure the plan is comprehensive and suitable for Kenyan education context.";
    } else { // 8-4-4 Syllabus
      prompt = "Generate a detailed 8-4-4 lesson plan for Form $grade, Subject: $subject, Topic: $strandTopic, Subtopic: $substrandSubtopic. "
               "Include: Objectives, Introduction (5 mins), Lesson Development (30 mins), Conclusion (5 mins). "
               "Number of students: $numberOfStudents. Lesson time: $lessonTimeMinutes minutes. "
               "Ensure the plan is comprehensive and suitable for Kenyan education context.";
    }

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo', // You can use 'gpt-4o' or other models if available and desired
          'messages': [
            {'role': 'system', 'content': 'You are a helpful assistant for Kenyan teachers, specializing in generating lesson plans for CBC and 8-4-4 syllabuses.'},
            {'role': 'user', 'content': prompt},
          ],
          'max_tokens': 1000, // Adjust as needed for length of lesson plan
          'temperature': 0.7, // Creativity level
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        print('OpenAI API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to generate lesson plan: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Error calling OpenAI API: $e');
      throw Exception('Error connecting to OpenAI: $e');
    }
  }

  Future<String> generateNotes({
    required String syllabus,
    required String grade,
    required String subject,
    required String strandTopic,
    required String substrandSubtopic,
  }) async {
    final String prompt;
    if (syllabus == 'CBC') {
      prompt = "Generate comprehensive notes for Grade $grade, Subject: $subject, Strand: $strandTopic, Substrand: $substrandSubtopic, based on the CBC syllabus. "
               "Ensure the notes are detailed, accurate, and suitable for Kenyan students.";
    } else { // 8-4-4 Syllabus
      prompt = "Generate comprehensive notes for Form $grade, Subject: $subject, Topic: $strandTopic, Subtopic: $substrandSubtopic, based on the 8-4-4 syllabus. "
               "Ensure the notes are detailed, accurate, and suitable for Kenyan students.";
    }

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo', // You can use 'gpt-4o' or other models
          'messages': [
            {'role': 'system', 'content': 'You are a helpful assistant for Kenyan teachers, specializing in generating educational notes for CBC and 8-4-4 syllabuses.'},
            {'role': 'user', 'content': prompt},
          ],
          'max_tokens': 1500, // Adjust as needed for length of notes
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        print('OpenAI API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to generate notes: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Error calling OpenAI API for notes: $e');
      throw Exception('Error connecting to OpenAI for notes: $e');
    }
  }
}
