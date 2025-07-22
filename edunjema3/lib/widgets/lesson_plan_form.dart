
import 'package:flutter/material.dart';
import 'package:edunjema3/models/lesson_plan.dart';
import 'package:edunjema3/models/user_profile.dart'; // Needed for subjects and syllabus
import 'package:edunjema3/utils/constants.dart';
import 'package:edunjema3/utils/validators.dart';
import 'package:edunjema3/widgets/custom_button.dart';
import 'package:edunjema3/services/ai_service.dart'; // Import AiService

/// A reusable form widget for creating or editing lesson plans.
///
/// It takes an optional [initialLessonPlan] for editing mode,
/// and requires a [userProfile] to pre-fill teacher details and subjects.
/// The [onSave] callback is triggered when the form is valid and submitted.
class LessonPlanForm extends StatefulWidget {
  final LessonPlan? initialLessonPlan; // Null for creation, provided for editing
  final UserProfile userProfile; // Current user's profile
  final Function(LessonPlan lessonPlan) onSave; // Callback for saving/generating
  final bool isLoading; // Controls the main submit button's loading state

  const LessonPlanForm({
    super.key,
    this.initialLessonPlan,
    required this.userProfile,
    required this.onSave,
    this.isLoading = false,
  });

  @override
  State<LessonPlanForm> createState() => _LessonPlanFormState();
}

class _LessonPlanFormState extends State<LessonPlanForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _teacherNameController = TextEditingController();
  // Duration will now be a dropdown, so no controller needed for it directly
  final TextEditingController _keyInquiryQuestionController = TextEditingController();
  final TextEditingController _introductionController = TextEditingController();
  final TextEditingController _extendedActivityController = TextEditingController();
  final TextEditingController _conclusionController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _reflectionController = TextEditingController();

  // CBC/8-4-4 specific controllers for sub-strand/sub-topic and outcomes/objectives
  final TextEditingController _subStrandSubTopicController = TextEditingController();
  final TextEditingController _outcomesObjectivesController = TextEditingController();

  // Multi-select fields
  final TextEditingController _coreCompetencyController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _pciController = TextEditingController();
  final TextEditingController _lifeSkillController = TextEditingController();
  final TextEditingController _otherSubjectLinkController = TextEditingController();
  final TextEditingController _communityServiceLearningController = TextEditingController();
  final TextEditingController _nonFormalActivityController = TextEditingController();

  List<LessonDevelopmentStep> _lessonDevelopmentSteps = [];
  List<String> _coreCompetencies = [];
  List<String> _values = [];
  List<String> _pci = [];
  List<String> _lifeSkills = [];
  List<String> _linksToOtherSubjects = [];

  int? _selectedDuration; // For the new duration dropdown
  String? _selectedLevel;
  String? _selectedSubject;
  String? _selectedSyllabusType;
  String? _selectedStrandTopic; // For the new AI-generated topic/strand dropdown

  List<String> _availableStrandTopics = [];
  bool _isLoadingTopics = false;
  bool _isGeneratingKIQ = false;

  final AiService _aiService = AiService();

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  /// Initializes form fields with data from the provided lesson plan (if editing)
  /// or default user profile data (if creating).
  void _initializeForm() {
    final plan = widget.initialLessonPlan;
    final userProfile = widget.userProfile;

    _teacherNameController.text = userProfile.name; // Always from user profile

    if (plan != null) {
      // Editing existing plan
      _selectedDuration = plan.durationMinutes;
      _keyInquiryQuestionController.text = plan.keyInquiryQuestion;
      _introductionController.text = plan.introduction;
      _extendedActivityController.text = plan.extendedActivity;
      _conclusionController.text = plan.conclusion;
      _summaryController.text = plan.summary;
      _reflectionController.text = plan.reflection;

      _selectedLevel = plan.level;
      _selectedSubject = plan.subject;
      _selectedSyllabusType = plan.syllabusType;

      _lessonDevelopmentSteps = List.from(plan.lessonDevelopment);
      _coreCompetencies = List.from(plan.coreCompetencies);
      _values = List.from(plan.values);
      _pci = List.from(plan.pci);
      _lifeSkills = List.from(plan.lifeSkills);
      _linksToOtherSubjects = List.from(plan.linksToOtherSubjects ?? []);
      _communityServiceLearningController.text = plan.communityServiceLearning ?? '';
      _nonFormalActivityController.text = plan.nonFormalActivity ?? '';

      // For editing, pre-fill the selected strand/topic and then fetch others
      if (plan.syllabusType == 'CBC') {
        _selectedStrandTopic = plan.strand;
        _subStrandSubTopicController.text = plan.subStrand ?? '';
        _outcomesObjectivesController.text = (plan.specificLearningOutcomes ?? []).join('\n');
      } else { // 8-4-4
        _selectedStrandTopic = plan.topic;
        _subStrandSubTopicController.text = plan.subTopic ?? '';
        _outcomesObjectivesController.text = (plan.objectives ?? []).join('\n');
      }
      // After initializing, fetch topics for the selected subject/level
      if (_selectedSubject != null && _selectedLevel != null && _selectedSyllabusType != null) {
        _fetchStrandTopics();
      }

    } else {
      // Creating new plan
      _selectedSyllabusType = userProfile.syllabusPreference;
      _selectedSubject = userProfile.subjects.isNotEmpty ? userProfile.subjects.first : null;
      _selectedDuration = AppConstants.lessonDurations.first; // Default duration
    }
  }

  /// Fetches curriculum topics/strands from AI based on current selections.
  Future<void> _fetchStrandTopics() async {
    if (_selectedSubject == null || _selectedLevel == null || _selectedSyllabusType == null) {
      setState(() {
        _availableStrandTopics = [];
        _selectedStrandTopic = null;
      });
      return;
    }

    setState(() {
      _isLoadingTopics = true;
      _availableStrandTopics = []; // Clear previous topics
      _selectedStrandTopic = null; // Clear selected topic
    });

    try {
      final topics = await _aiService.fetchCurriculumTopics(
        subject: _selectedSubject!,
        level: _selectedLevel!,
        syllabusType: _selectedSyllabusType!,
      );
      setState(() {
        _availableStrandTopics = topics;
        if (topics.isNotEmpty && widget.initialLessonPlan == null) {
          _selectedStrandTopic = topics.first; // Auto-select first for new plans
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load topics: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoadingTopics = false;
      });
    }
  }

  /// Generates a Key Inquiry Question using AI.
  Future<void> _generateKeyInquiryQuestion() async {
    if (_selectedSubject == null || _selectedLevel == null || _selectedSyllabusType == null || _selectedStrandTopic == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select Subject, Level, Syllabus, and Topic/Strand first.')),
      );
      return;
    }

    setState(() {
      _isGeneratingKIQ = true;
    });

    try {
      final kiq = await _aiService.generateKeyInquiryQuestion(
        subject: _selectedSubject!,
        level: _selectedLevel!,
        syllabusType: _selectedSyllabusType!,
        strandTopic: _selectedStrandTopic!,
      );
      setState(() {
        _keyInquiryQuestionController.text = kiq;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate KIQ: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isGeneratingKIQ = false;
      });
    }
  }

  /// Adds a new lesson development step.
  void _addLessonDevelopmentStep() {
    setState(() {
      _lessonDevelopmentSteps.add(LessonDevelopmentStep(activity: '', durationMinutes: 0));
    });
  }

  /// Removes a lesson development step.
  void _removeLessonDevelopmentStep(int index) {
    setState(() {
      _lessonDevelopmentSteps.removeAt(index);
    });
  }

  /// Helper to add a chip item to a list.
  void _addChipItem(TextEditingController controller, List<String> list) {
    final item = controller.text.trim();
    if (item.isNotEmpty && !list.contains(item)) {
      setState(() {
        list.add(item);
        controller.clear();
      });
    }
  }

  /// Helper to remove a chip item from a list.
  void _removeChipItem(String item, List<String> list) {
    setState(() {
      list.remove(item);
    });
  }

  /// Gathers all form data and calls the onSave callback.
  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final lessonPlan = LessonPlan(
        id: widget.initialLessonPlan?.id, // Preserve ID if editing
        teacherId: widget.userProfile.uid,
        teacherName: _teacherNameController.text,
        date: widget.initialLessonPlan?.date ?? DateTime.now(), // Preserve date if editing, otherwise new
        level: _selectedLevel!,
        subject: _selectedSubject!,
        syllabusType: _selectedSyllabusType!,
        durationMinutes: _selectedDuration!, // Use selected duration
        keyInquiryQuestion: _keyInquiryQuestionController.text,
        introduction: _introductionController.text,
        lessonDevelopment: _lessonDevelopmentSteps,
        extendedActivity: _extendedActivityController.text,
        conclusion: _conclusionController.text,
        summary: _summaryController.text,
        reflection: _reflectionController.text,
        coreCompetencies: _coreCompetencies,
        values: _values,
        pci: _pci,
        lifeSkills: _lifeSkills,
        linksToOtherSubjects: _linksToOtherSubjects,
        communityServiceLearning: _communityServiceLearningController.text.isEmpty ? null : _communityServiceLearningController.text,
        nonFormalActivity: _nonFormalActivityController.text.isEmpty ? null : _nonFormalActivityController.text,
        // CBC/8-4-4 specific fields
        strand: _selectedSyllabusType == 'CBC' ? _selectedStrandTopic : null, // Use selected strand/topic
        subStrand: _selectedSyllabusType == 'CBC' ? _subStrandSubTopicController.text : null,
        specificLearningOutcomes: _selectedSyllabusType == 'CBC' ? _outcomesObjectivesController.text.split('\n').where((s) => s.isNotEmpty).toList() : null,
        topic: _selectedSyllabusType == '8-4-4' ? _selectedStrandTopic : null, // Use selected strand/topic
        subTopic: _selectedSyllabusType == '8-4-4' ? _subStrandSubTopicController.text : null,
        objectives: _selectedSyllabusType == '8-4-4' ? _outcomesObjectivesController.text.split('\n').where((s) => s.isNotEmpty).toList() : null,
      );
      widget.onSave(lessonPlan);
    }
  }

  @override
  void dispose() {
    _teacherNameController.dispose();
    _keyInquiryQuestionController.dispose();
    _introductionController.dispose();
    _extendedActivityController.dispose();
    _conclusionController.dispose();
    _summaryController.dispose();
    _reflectionController.dispose();
    _subStrandSubTopicController.dispose();
    _outcomesObjectivesController.dispose();
    _coreCompetencyController.dispose();
    _valueController.dispose();
    _pciController.dispose();
    _lifeSkillController.dispose();
    _otherSubjectLinkController.dispose();
    _communityServiceLearningController.dispose();
    _nonFormalActivityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine available levels based on selected syllabus type
    List<String> availableLevels = [];
    if (_selectedSyllabusType == 'CBC') {
      availableLevels = AppConstants.academicLevelsCBC;
    } else if (_selectedSyllabusType == '8-4-4') {
      availableLevels = AppConstants.academicLevels844;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.largePadding),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lesson Plan Details',
              style: AppConstants.headline5.copyWith(color: AppConstants.primaryColor),
            ),
            const SizedBox(height: AppConstants.mediumPadding),
            TextFormField(
              controller: _teacherNameController,
              decoration: const InputDecoration(
                labelText: 'Teacher Name',
                prefixIcon: Icon(Icons.person, color: AppConstants.primaryColor),
              ),
              readOnly: true, // Teacher name comes from profile
              validator: (value) => Validators.validateText(value, 'Teacher Name'),
            ),
            const SizedBox(height: AppConstants.mediumPadding),
            DropdownButtonFormField<String>(
              value: _selectedSyllabusType,
              decoration: const InputDecoration(
                labelText: 'Syllabus Type',
                prefixIcon: Icon(Icons.menu_book, color: AppConstants.primaryColor),
              ),
              items: <String>['CBC', '8-4-4']
                  .map((String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, overflow: TextOverflow.ellipsis, maxLines: 1),
                      ))
                  .toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedSyllabusType = newValue;
                  _selectedLevel = null; // Reset level when syllabus changes
                  _selectedStrandTopic = null; // Reset topic/strand
                  _availableStrandTopics = []; // Clear available topics
                  _subStrandSubTopicController.clear();
                  _outcomesObjectivesController.clear();
                });
              },
              validator: (value) => value == null ? 'Please select a syllabus type' : null,
            ),
            const SizedBox(height: AppConstants.mediumPadding),
            DropdownButtonFormField<String>(
              value: _selectedLevel,
              decoration: const InputDecoration(
                labelText: 'Level/Grade',
                prefixIcon: Icon(Icons.grade, color: AppConstants.primaryColor),
              ),
              items: availableLevels
                  .map((String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, overflow: TextOverflow.ellipsis, maxLines: 1),
                      ))
                  .toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLevel = newValue;
                  _fetchStrandTopics(); // Fetch topics when level changes
                });
              },
              validator: (value) => value == null ? 'Please select a level/grade' : null,
            ),
            const SizedBox(height: AppConstants.mediumPadding),
            DropdownButtonFormField<String>(
              value: _selectedSubject,
              decoration: const InputDecoration(
                labelText: 'Subject',
                prefixIcon: Icon(Icons.subject, color: AppConstants.primaryColor),
              ),
              items: (widget.userProfile.subjects) // Use user's subjects
                  .map((String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, overflow: TextOverflow.ellipsis, maxLines: 1),
                      ))
                  .toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedSubject = newValue;
                  _fetchStrandTopics(); // Fetch topics when subject changes
                });
              },
              validator: (value) => value == null ? 'Please select a subject' : null,
            ),
            const SizedBox(height: AppConstants.mediumPadding),
            DropdownButtonFormField<int>( // Changed to DropdownButtonFormField for duration
              value: _selectedDuration,
              decoration: const InputDecoration(
                labelText: 'Lesson Duration (minutes)',
                prefixIcon: Icon(Icons.timer, color: AppConstants.primaryColor),
              ),
              items: AppConstants.lessonDurations
                  .map((int value) => DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value minutes'),
                      ))
                  .toList(),
              onChanged: (int? newValue) {
                setState(() {
                  _selectedDuration = newValue;
                });
              },
              validator: (value) => value == null ? 'Please select a duration.' : null,
            ),
            const SizedBox(height: AppConstants.mediumPadding),

            // Dynamic fields based on syllabus type
            if (_selectedSyllabusType == 'CBC' || _selectedSyllabusType == '8-4-4') ...[
              Text(
                _selectedSyllabusType == 'CBC' ? 'CBC Specifics' : '8-4-4 Specifics',
                style: AppConstants.headline6.copyWith(color: AppConstants.primaryColor),
              ),
              const SizedBox(height: AppConstants.mediumPadding),
              _isLoadingTopics
                  ? const Center(child: CircularProgressIndicator(color: AppConstants.primaryColor))
                  : DropdownButtonFormField<String>(
                      value: _selectedStrandTopic,
                      decoration: InputDecoration(
                        labelText: _selectedSyllabusType == 'CBC' ? 'Strand' : 'Topic',
                        hintText: _selectedSyllabusType == 'CBC' ? 'e.g., Living Things' : 'e.g., Photosynthesis',
                        prefixIcon: Icon(_selectedSyllabusType == 'CBC' ? Icons.category : Icons.topic, color: AppConstants.primaryColor),
                      ),
                      items: _availableStrandTopics
                          .map((String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, overflow: TextOverflow.ellipsis, maxLines: 1),
                              ))
                          .toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedStrandTopic = newValue;
                        });
                      },
                      validator: (value) => value == null ? 'Please select a ${_selectedSyllabusType == 'CBC' ? 'strand' : 'topic'}' : null,
                    ),
              const SizedBox(height: AppConstants.mediumPadding),
              TextFormField(
                controller: _subStrandSubTopicController,
                decoration: InputDecoration(
                  labelText: _selectedSyllabusType == 'CBC' ? 'Sub-Strand' : 'Sub-Topic',
                  hintText: _selectedSyllabusType == 'CBC' ? 'e.g., Plants' : 'e.g., Factors affecting photosynthesis',
                  prefixIcon: const Icon(Icons.subdirectory_arrow_right, color: AppConstants.primaryColor),
                ),
                enabled: _selectedStrandTopic != null, // Enable only if topic/strand is selected
                validator: (value) => Validators.validateText(value, _selectedSyllabusType == 'CBC' ? 'Sub-Strand' : 'Sub-Topic'),
              ),
              const SizedBox(height: AppConstants.mediumPadding),
              TextFormField(
                controller: _outcomesObjectivesController,
                decoration: InputDecoration(
                  labelText: _selectedSyllabusType == 'CBC' ? 'Specific Learning Outcomes (KSA)' : 'Objectives',
                  hintText: _selectedSyllabusType == 'CBC' ? 'Enter outcomes, one per line. e.g.,\n- Identify parts of a plant\n- Describe photosynthesis' : 'Enter objectives, one per line. e.g.,\n- State the definition of photosynthesis\n- List factors affecting photosynthesis',
                  prefixIcon: Icon(_selectedSyllabusType == 'CBC' ? Icons.lightbulb_outline : Icons.checklist, color: AppConstants.primaryColor),
                ),
                maxLines: 5,
                enabled: _selectedStrandTopic != null, // Enable only if topic/strand is selected
                validator: (value) => Validators.validateText(value, _selectedSyllabusType == 'CBC' ? 'Specific Learning Outcomes' : 'Objectives'),
              ),
            ],
            const SizedBox(height: AppConstants.largePadding),

            // Key Inquiry Question with Generate Button
            Text(
              'Key Inquiry Question',
              style: AppConstants.headline5.copyWith(color: AppConstants.primaryColor),
            ),
            const SizedBox(height: AppConstants.mediumPadding),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _keyInquiryQuestionController,
                    decoration: const InputDecoration(
                      labelText: 'Key Inquiry Question',
                      hintText: 'e.g., How do plants make their own food?',
                      prefixIcon: Icon(Icons.question_mark, color: AppConstants.primaryColor),
                    ),
                    maxLines: 2,
                    validator: (value) => Validators.validateText(value, 'Key Inquiry Question'),
                  ),
                ),
                const SizedBox(width: AppConstants.smallPadding),
                CustomButton(
                  text: 'Generate KIQ',
                  onPressed: (_selectedSubject == null || _selectedLevel == null || _selectedSyllabusType == null || _selectedStrandTopic == null || _isGeneratingKIQ)
                      ? null
                      : _generateKeyInquiryQuestion,
                  isLoading: _isGeneratingKIQ,
                  color: AppConstants.accentColor,
                  padding: const EdgeInsets.symmetric(horizontal: AppConstants.mediumPadding, vertical: AppConstants.smallPadding),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.largePadding),

            Text(
              'Lesson Body',
              style: AppConstants.headline5.copyWith(color: AppConstants.primaryColor),
            ),
            const SizedBox(height: AppConstants.mediumPadding),
            TextFormField(
              controller: _introductionController,
              decoration: const InputDecoration(
                labelText: 'Introduction',
                hintText: 'How will you introduce the lesson?',
                prefixIcon: Icon(Icons.info_outline, color: AppConstants.primaryColor),
              ),
              maxLines: 3,
              validator: (value) => Validators.validateText(value, 'Introduction'),
            ),
            const SizedBox(height: AppConstants.mediumPadding),
            Text(
              'Lesson Development Steps',
              style: AppConstants.headline6.copyWith(color: AppConstants.primaryColor),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _lessonDevelopmentSteps.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.mediumPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Step ${index + 1}', style: AppConstants.bodyText1.copyWith(fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: const Icon(Icons.delete, color: AppConstants.errorColor),
                              onPressed: () => _removeLessonDevelopmentStep(index),
                            ),
                          ],
                        ),
                        TextFormField(
                          initialValue: _lessonDevelopmentSteps[index].activity,
                          decoration: const InputDecoration(
                            labelText: 'Activity Description',
                            hintText: 'e.g., Teacher demonstrates how to...',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                          onChanged: (value) {
                            _lessonDevelopmentSteps[index] = _lessonDevelopmentSteps[index].copyWith(activity: value);
                          },
                          validator: (value) => Validators.validateText(value, 'Activity Description'),
                        ),
                        const SizedBox(height: AppConstants.smallPadding),
                        TextFormField(
                          initialValue: _lessonDevelopmentSteps[index].durationMinutes.toString(),
                          decoration: const InputDecoration(
                            labelText: 'Duration (minutes)',
                            hintText: 'e.g., 10',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            _lessonDevelopmentSteps[index] = _lessonDevelopmentSteps[index].copyWith(durationMinutes: int.tryParse(value) ?? 0);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Duration is required.';
                            if (int.tryParse(value) == null || int.parse(value) <= 0) return 'Enter valid minutes.';
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Center(
              child: CustomButton(
                text: 'Add Lesson Step',
                onPressed: _addLessonDevelopmentStep,
                color: AppConstants.primaryColor.withOpacity(0.8),
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.mediumPadding, vertical: AppConstants.smallPadding),
              ),
            ),
            const SizedBox(height: AppConstants.mediumPadding),
            TextFormField(
              controller: _extendedActivityController,
              decoration: const InputDecoration(
                labelText: 'Extended Activity',
                hintText: 'What activities will extend learning?',
                prefixIcon: Icon(Icons.extension, color: AppConstants.primaryColor),
              ),
              maxLines: 3,
              validator: (value) => Validators.validateText(value, 'Extended Activity'),
            ),
            const SizedBox(height: AppConstants.mediumPadding),
            TextFormField(
              controller: _conclusionController,
              decoration: const InputDecoration(
                labelText: 'Conclusion',
                hintText: 'How will you conclude the lesson?',
                prefixIcon: Icon(Icons.done_all, color: AppConstants.primaryColor),
              ),
              maxLines: 3,
              validator: (value) => Validators.validateText(value, 'Conclusion'),
            ),
            const SizedBox(height: AppConstants.mediumPadding),
            TextFormField(
              controller: _summaryController,
              decoration: const InputDecoration(
                labelText: 'Summary',
                hintText: 'Summarize key points of the lesson.',
                prefixIcon: Icon(Icons.summarize, color: AppConstants.primaryColor),
              ),
              maxLines: 3,
              validator: (value) => Validators.validateText(value, 'Summary'),
            ),
            const SizedBox(height: AppConstants.mediumPadding),
            TextFormField(
              controller: _reflectionController,
              decoration: const InputDecoration(
                labelText: 'Reflection',
                hintText: 'Your reflection on the lesson delivery.',
                prefixIcon: Icon(Icons.self_improvement, color: AppConstants.primaryColor),
              ),
              maxLines: 3,
              validator: (value) => Validators.validateText(value, 'Reflection'),
            ),
            const SizedBox(height: AppConstants.largePadding),

            // Core Competencies
            _buildChipInput(
              controller: _coreCompetencyController,
              list: _coreCompetencies,
              labelText: 'Core Competencies',
              hintText: 'e.g., Communication & Collaboration',
              icon: Icons.group,
              onAdd: () => _addChipItem(_coreCompetencyController, _coreCompetencies),
              onRemove: (item) => _removeChipItem(item, _coreCompetencies),
            ),
            const SizedBox(height: AppConstants.mediumPadding),

            // Values
            _buildChipInput(
              controller: _valueController,
              list: _values,
              labelText: 'Values',
              hintText: 'e.g., Responsibility, Respect',
              icon: Icons.favorite_border,
              onAdd: () => _addChipItem(_valueController, _values),
              onRemove: (item) => _removeChipItem(item, _values),
            ),
            const SizedBox(height: AppConstants.mediumPadding),

            // Pertinent and Contemporary Issues (PCIs)
            _buildChipInput(
              controller: _pciController,
              list: _pci,
              labelText: 'Pertinent & Contemporary Issues (PCIs)',
              hintText: 'e.g., Environmental Education',
              icon: Icons.public,
              onAdd: () => _addChipItem(_pciController, _pci),
              onRemove: (item) => _removeChipItem(item, _pci),
            ),
            const SizedBox(height: AppConstants.mediumPadding),

            // Life Skills
            _buildChipInput(
              controller: _lifeSkillController,
              list: _lifeSkills,
              labelText: 'Life Skills',
              hintText: 'e.g., Self-awareness, Problem-solving',
              icon: Icons.psychology,
              onAdd: () => _addChipItem(_lifeSkillController, _lifeSkills),
              onRemove: (item) => _removeChipItem(item, _lifeSkills),
            ),
            const SizedBox(height: AppConstants.largePadding),

            Text(
              'Cross-Curricular Links',
              style: AppConstants.headline5.copyWith(color: AppConstants.primaryColor),
            ),
            const SizedBox(height: AppConstants.mediumPadding),
            TextFormField(
              controller: _communityServiceLearningController,
              decoration: const InputDecoration(
                labelText: 'Community Service Learning',
                hintText: 'Describe link to CSL',
                prefixIcon: Icon(Icons.volunteer_activism, color: AppConstants.primaryColor),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: AppConstants.mediumPadding),
            TextFormField(
              controller: _nonFormalActivityController,
              decoration: const InputDecoration(
                labelText: 'Non-Formal Activity',
                hintText: 'Describe link to non-formal activity',
                prefixIcon: Icon(Icons.sports_soccer, color: AppConstants.primaryColor),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: AppConstants.mediumPadding),
            _buildChipInput(
              controller: _otherSubjectLinkController,
              list: _linksToOtherSubjects,
              labelText: 'Links to Other Subjects',
              hintText: 'e.g., Science (for Mathematics)',
              icon: Icons.link,
              onAdd: () => _addChipItem(_otherSubjectLinkController, _linksToOtherSubjects),
              onRemove: (item) => _removeChipItem(item, _linksToOtherSubjects),
            ),

            const SizedBox(height: AppConstants.largePadding),
            Center(
              child: CustomButton(
                text: widget.initialLessonPlan == null ? 'Generate Lesson Plan' : 'Save Changes',
                onPressed: widget.isLoading ? null : _submitForm,
                isLoading: widget.isLoading,
                color: widget.initialLessonPlan == null ? AppConstants.accentColor : AppConstants.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.largePadding * 2, vertical: AppConstants.mediumPadding),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper widget to build input fields for lists of chips.
  Widget _buildChipInput({
    required TextEditingController controller,
    required List<String> list,
    required String labelText,
    required String hintText,
    required IconData icon,
    required VoidCallback onAdd,
    required Function(String) onRemove,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: AppConstants.headline6.copyWith(color: AppConstants.primaryColor),
        ),
        const SizedBox(height: AppConstants.smallPadding),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Add $labelText',
                  hintText: hintText,
                  prefixIcon: Icon(icon, color: AppConstants.primaryColor),
                ),
                onFieldSubmitted: (_) => onAdd(),
              ),
            ),
            const SizedBox(width: AppConstants.smallPadding),
            CustomButton(
              text: 'Add',
              onPressed: controller.text.trim().isEmpty ? null : onAdd,
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.mediumPadding, vertical: AppConstants.smallPadding),
              borderRadius: BorderRadius.circular(AppConstants.smallPadding),
              color: AppConstants.accentColor,
            ),
          ],
        ),
        const SizedBox(height: AppConstants.smallPadding),
        Wrap(
          spacing: AppConstants.smallPadding,
          runSpacing: AppConstants.smallPadding,
          children: list
              .map(
                (item) => Chip(
                  label: Text(item),
                  onDeleted: () => onRemove(item),
                  deleteIcon: const Icon(Icons.close, size: 18),
                  backgroundColor: AppConstants.primaryColor.withOpacity(0.1),
                  labelStyle: AppConstants.bodyText2.copyWith(color: AppConstants.primaryColor),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

// Extend LessonDevelopmentStep to include copyWith for immutability
extension on LessonDevelopmentStep {
  LessonDevelopmentStep copyWith({
    String? activity,
    int? durationMinutes,
  }) {
    return LessonDevelopmentStep(
      activity: activity ?? this.activity,
      durationMinutes: durationMinutes ?? this.durationMinutes,
    );
  }
}
