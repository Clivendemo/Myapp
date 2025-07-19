import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/constants.dart';
import '../../utils/cbe_data.dart';

class LessonPlanDisplay extends StatelessWidget {
  final String className;
  final String subject;
  final String topic;
  final String duration;
  final String keyInquiryQuestion;

  const LessonPlanDisplay({
    super.key,
    required this.className,
    required this.subject,
    required this.topic,
    required this.duration,
    required this.keyInquiryQuestion,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generated Lesson Plan'),
        actions: [
          IconButton(
            onPressed: () => _copyToClipboard(context),
            icon: const Icon(Icons.copy),
            tooltip: 'Copy to Clipboard',
          ),
          IconButton(
            onPressed: () => _shareLessonPlan(context),
            icon: const Icon(Icons.share),
            tooltip: 'Share',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(),
                  const SizedBox(height: AppConstants.paddingLarge),
                  
                  // Basic Information
                  _buildBasicInfo(),
                  const SizedBox(height: AppConstants.paddingLarge),
                  
                  // Key Inquiry Question
                  _buildKeyInquiryQuestion(),
                  const SizedBox(height: AppConstants.paddingLarge),
                  
                  // Specific Learning Outcomes
                  _buildLearningOutcomes(),
                  const SizedBox(height: AppConstants.paddingLarge),
                  
                  // Core Competencies
                  _buildCoreCompetencies(),
                  const SizedBox(height: AppConstants.paddingLarge),
                  
                  // Core Values
                  _buildCoreValues(),
                  const SizedBox(height: AppConstants.paddingLarge),
                  
                  // PCIs
                  _buildPCIs(),
                  const SizedBox(height: AppConstants.paddingLarge),
                  
                  // Learning Experiences
                  _buildLearningExperiences(),
                  const SizedBox(height: AppConstants.paddingLarge),
                  
                  // Assessment
                  _buildAssessment(),
                  const SizedBox(height: AppConstants.paddingLarge),
                  
                  // Resources
                  _buildResources(),
                  const SizedBox(height: AppConstants.paddingLarge),
                  
                  // Self Reflection
                  _buildSelfReflection(),
                  
                  const SizedBox(height: AppConstants.paddingXLarge),
                  
                  // Action Buttons
                  _buildActionButtons(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppConstants.primaryColor, AppConstants.accentColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.school,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          const Text(
            'CBE LESSON PLAN',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Text(
            'Generated on ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo() {
    return _buildSection(
      'BASIC INFORMATION',
      Icons.info,
      Column(
        children: [
          _buildInfoRow('Class:', className),
          _buildInfoRow('Subject:', subject),
          _buildInfoRow('Topic/Strand:', topic),
          _buildInfoRow('Duration:', duration),
          _buildInfoRow('Date:', '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'),
        ],
      ),
    );
  }

  Widget _buildKeyInquiryQuestion() {
    final question = keyInquiryQuestion.isNotEmpty 
        ? keyInquiryQuestion 
        : _generateKeyInquiryQuestion();
    
    return _buildSection(
      'KEY INQUIRY QUESTION',
      Icons.help_outline,
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        decoration: BoxDecoration(
          color: AppConstants.accentColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          border: Border.all(
            color: AppConstants.accentColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          question,
          style: const TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
            color: AppConstants.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildLearningOutcomes() {
    return _buildSection(
      'SPECIFIC LEARNING OUTCOMES',
      Icons.track_changes,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOutcomeSubsection(
            'Knowledge and Understanding',
            _generateKnowledgeOutcomes(),
            AppConstants.primaryColor,
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          _buildOutcomeSubsection(
            'Skills',
            _generateSkillsOutcomes(),
            AppConstants.secondaryColor,
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          _buildOutcomeSubsection(
            'Attitudes and Values',
            _generateAttitudesOutcomes(),
            AppConstants.accentColor,
          ),
        ],
      ),
    );
  }

  Widget _buildCoreCompetencies() {
    final selectedCompetencies = CBEData.coreCompetencies.take(3).toList();
    
    return _buildSection(
      'CORE COMPETENCIES',
      Icons.psychology,
      Wrap(
        spacing: AppConstants.paddingSmall,
        runSpacing: AppConstants.paddingSmall,
        children: selectedCompetencies.map((competency) {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMedium,
              vertical: AppConstants.paddingSmall,
            ),
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              border: Border.all(
                color: AppConstants.primaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              competency,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppConstants.primaryColor,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCoreValues() {
    final selectedValues = CBEData.coreValues.take(3).toList();
    
    return _buildSection(
      'CORE VALUES',
      Icons.favorite,
      Wrap(
        spacing: AppConstants.paddingSmall,
        runSpacing: AppConstants.paddingSmall,
        children: selectedValues.map((value) {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMedium,
              vertical: AppConstants.paddingSmall,
            ),
            decoration: BoxDecoration(
              color: AppConstants.secondaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              border: Border.all(
                color: AppConstants.secondaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppConstants.secondaryColor,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPCIs() {
    final selectedPCIs = CBEData.pcis.take(2).toList();
    
    return _buildSection(
      'PERTINENT AND CONTEMPORARY ISSUES (PCIs)',
      Icons.public,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: selectedPCIs.map((pci) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Text(
                    pci,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLearningExperiences() {
    return _buildSection(
      'LEARNING EXPERIENCES',
      Icons.school,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLearningPhase('Introduction (5 minutes)', _generateIntroduction()),
          const SizedBox(height: AppConstants.paddingMedium),
          _buildLearningPhase('Development (25 minutes)', _generateDevelopment()),
          const SizedBox(height: AppConstants.paddingMedium),
          _buildLearningPhase('Conclusion (10 minutes)', _generateConclusion()),
        ],
      ),
    );
  }

  Widget _buildAssessment() {
    return _buildSection(
      'ASSESSMENT',
      Icons.assignment,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAssessmentType('Formative Assessment', _generateFormativeAssessment()),
          const SizedBox(height: AppConstants.paddingMedium),
          _buildAssessmentType('Summative Assessment', _generateSummativeAssessment()),
        ],
      ),
    );
  }

  Widget _buildResources() {
    return _buildSection(
      'LEARNING RESOURCES',
      Icons.library_books,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _generateResources().map((resource) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Text(
                    resource,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSelfReflection() {
    return _buildSection(
      'SELF REFLECTION',
      Icons.self_improvement,
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        decoration: BoxDecoration(
          color: AppConstants.warningColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          border: Border.all(
            color: AppConstants.warningColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reflection Questions:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            ...(_generateReflectionQuestions().map((question) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
                child: Text(
                  '• $question',
                  style: const TextStyle(fontSize: 13),
                ),
              );
            }).toList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: AppConstants.primaryColor,
              size: 20,
            ),
            const SizedBox(width: AppConstants.paddingSmall),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppConstants.primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        content,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppConstants.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppConstants.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutcomeSubsection(String title, List<String> outcomes, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: AppConstants.paddingSmall),
        ...outcomes.map((outcome) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Text(
                    outcome,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildLearningPhase(String phase, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          phase,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppConstants.secondaryColor,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: AppConstants.paddingSmall),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          decoration: BoxDecoration(
            color: AppConstants.secondaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          ),
          child: Text(
            content,
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildAssessmentType(String type, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          type,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppConstants.accentColor,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: AppConstants.paddingSmall),
        Text(
          content,
          style: const TextStyle(fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _saveLessonPlan(context),
            icon: const Icon(Icons.save),
            label: const Text('Save Plan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.successColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
            ),
          ),
        ),
        const SizedBox(width: AppConstants.paddingMedium),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.edit),
            label: const Text('Edit'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
            ),
          ),
        ),
      ],
    );
  }

  // Helper methods for generating content
  String _generateKeyInquiryQuestion() {
    switch (subject.toLowerCase()) {
      case 'mathematics':
      case 'mathematical activities':
        return 'How can we apply $topic concepts to solve real-world problems?';
      case 'english':
      case 'english activities':
        return 'How does understanding $topic improve our communication skills?';
      case 'science and technology':
      case 'integrated science':
        return 'What role does $topic play in our daily lives and environment?';
      default:
        return 'How can we effectively learn and apply $topic in our context?';
    }
  }

  List<String> _generateKnowledgeOutcomes() {
    return [
      'Learners will understand the key concepts of $topic',
      'Learners will identify the main components and principles',
      'Learners will explain the relationship between different elements',
    ];
  }

  List<String> _generateSkillsOutcomes() {
    return [
      'Learners will demonstrate practical application of $topic',
      'Learners will analyze and solve problems related to the topic',
      'Learners will communicate their understanding effectively',
    ];
  }

  List<String> _generateAttitudesOutcomes() {
    return [
      'Learners will appreciate the importance of $topic in daily life',
      'Learners will develop curiosity and interest in the subject',
      'Learners will show respect for diverse perspectives and ideas',
    ];
  }

  String _generateIntroduction() {
    return 'Begin with a warm greeting and review of previous lesson. Introduce the topic through a real-life scenario or question that connects to learners\' experiences. Capture attention with an engaging activity or demonstration related to $topic.';
  }

  String _generateDevelopment() {
    return 'Present the main content through interactive methods such as guided discovery, group discussions, and hands-on activities. Use varied teaching strategies to accommodate different learning styles. Encourage learner participation through questions and practical exercises related to $topic.';
  }

  String _generateConclusion() {
    return 'Summarize key points learned about $topic. Allow learners to share their understanding and ask questions. Provide a preview of the next lesson and assign relevant homework or practice activities.';
  }

  String _generateFormativeAssessment() {
    return 'Continuous observation during activities, questioning techniques, peer assessment, and quick check-ins to gauge understanding throughout the lesson.';
  }

  String _generateSummativeAssessment() {
    return 'End-of-lesson quiz, practical demonstration, written assignment, or project work that allows learners to demonstrate their mastery of $topic.';
  }

  List<String> _generateResources() {
    return [
      'Textbooks and reference materials',
      'Visual aids and charts',
      'Manipulatives and practical materials',
      'Digital resources and multimedia',
      'Real-life examples and case studies',
    ];
  }

  List<String> _generateReflectionQuestions() {
    return [
      'What went well in this lesson?',
      'What challenges did learners face and how were they addressed?',
      'How effectively were the learning outcomes achieved?',
      'What would I do differently next time?',
      'How can I improve learner engagement in future lessons?',
    ];
  }

  void _copyToClipboard(BuildContext context) {
    final lessonPlanText = _generateLessonPlanText();
    Clipboard.setData(ClipboardData(text: lessonPlanText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lesson plan copied to clipboard!'),
        backgroundColor: AppConstants.successColor,
      ),
    );
  }

  void _shareLessonPlan(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share feature coming soon!'),
      ),
    );
  }

  void _saveLessonPlan(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lesson plan saved successfully!'),
        backgroundColor: AppConstants.successColor,
      ),
    );
  }

  String _generateLessonPlanText() {
    return '''
CBE LESSON PLAN

BASIC INFORMATION
Class: $className
Subject: $subject
Topic: $topic
Duration: $duration
Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}

KEY INQUIRY QUESTION
${keyInquiryQuestion.isNotEmpty ? keyInquiryQuestion : _generateKeyInquiryQuestion()}

SPECIFIC LEARNING OUTCOMES
Knowledge: ${_generateKnowledgeOutcomes().join(', ')}
Skills: ${_generateSkillsOutcomes().join(', ')}
Attitudes: ${_generateAttitudesOutcomes().join(', ')}

CORE COMPETENCIES
${CBEData.coreCompetencies.take(3).join(', ')}

CORE VALUES
${CBEData.coreValues.take(3).join(', ')}

LEARNING EXPERIENCES
Introduction: ${_generateIntroduction()}
Development: ${_generateDevelopment()}
Conclusion: ${_generateConclusion()}

ASSESSMENT
Formative: ${_generateFormativeAssessment()}
Summative: ${_generateSummativeAssessment()}

RESOURCES
${_generateResources().join('\n')}

SELF REFLECTION
${_generateReflectionQuestions().join('\n')}
''';
  }
}
