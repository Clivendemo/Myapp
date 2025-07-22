import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:edunjema3/models/user_profile.dart';
import 'package:edunjema3/services/firestore_service.dart';
import 'package:edunjema3/utils/constants.dart';
import 'package:edunjema3/utils/validators.dart';
import 'package:edunjema3/widgets/custom_button.dart';
import 'package:edunjema3/services/ai_service.dart';
//import 'package:edunjema3/screens/notes_generator/notes_generator_screen.dart';

/// A screen for users to generate study notes using AI.
class NotesGeneratorScreen extends StatefulWidget {
  /// Creates a [NotesGeneratorScreen] instance.
  const NotesGeneratorScreen({super.key});

  @override
  State<NotesGeneratorScreen> createState() => _NotesGeneratorScreenState();
}

class _NotesGeneratorScreenState extends State<NotesGeneratorScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _keywordsController = TextEditingController();
  final TextEditingController _generatedNotesController = TextEditingController();

  UserProfile? _userProfile;
  bool _isLoadingProfile = true;
  bool _isGenerating = false;
  String? _selectedSubject;
  String? _selectedLevel;

  final FirestoreService _firestoreService = FirestoreService();
  final AiService _aiService = AiService();
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserProfileAndInitializeForm();
  }

  /// Loads the user profile and initializes form fields.
  Future<void> _loadUserProfileAndInitializeForm() async {
    if (_currentUser == null) {
      setState(() {
        _isLoadingProfile = false;
      });
      return;
    }
    try {
      final profile = await _firestoreService.getUserProfile(_currentUser!.uid);
      if (profile != null) {
        setState(() {
          _userProfile = profile;
          // Pre-select first subject if available, or leave null
          _selectedSubject = profile.subjects.isNotEmpty ? profile.subjects.first : null;
          // Default to CBC levels, user can change syllabus type if needed
          _selectedLevel = AppConstants.academicLevelsCBC.isNotEmpty ? AppConstants.academicLevelsCBC.first : null;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user profile: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoadingProfile = false;
      });
    }
  }

  void _generateNotes() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isGenerating = true;
        _generatedNotesController.clear(); // Clear previous notes
      });

      try {
        final notesInput = {
          'subject': _selectedSubject!,
          'level': _selectedLevel!,
          'topic': _topicController.text,
          'keywords': _keywordsController.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
        };

        final generatedContent = await _aiService.generateNotes(notesInput);
        setState(() {
          _generatedNotesController.text = generatedContent['notes'] ?? 'No notes generated.';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notes generated successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate notes: ${e.toString()}')),
        );
      } finally {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _topicController.dispose();
    _keywordsController.dispose();
    _generatedNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingProfile) {
      return Scaffold(
        appBar: AppBar(title: const Text('Generate Notes')),
        body: const Center(child: CircularProgressIndicator(color: AppConstants.primaryColor)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Notes'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notes Generation Details',
                style: AppConstants.headline5.copyWith(color: AppConstants.primaryColor),
              ),
              const SizedBox(height: AppConstants.mediumPadding),
              DropdownButtonFormField<String>(
                value: _selectedSubject,
                decoration: const InputDecoration(
                  labelText: 'Subject',
                  prefixIcon: Icon(Icons.subject, color: AppConstants.primaryColor),
                ),
                items: (_userProfile?.subjects ?? [])
                    .map((String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, overflow: TextOverflow.ellipsis, maxLines: 1),
                        ))
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedSubject = newValue;
                  });
                },
                validator: (value) => value == null ? 'Please select a subject' : null,
              ),
              const SizedBox(height: AppConstants.mediumPadding),
              DropdownButtonFormField<String>(
                value: _selectedLevel,
                decoration: const InputDecoration(
                  labelText: 'Level/Grade',
                  prefixIcon: Icon(Icons.grade, color: AppConstants.primaryColor),
                ),
                items: AppConstants.academicLevelsCBC // Assuming CBC levels for notes, can be made dynamic
                    .map((String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, overflow: TextOverflow.ellipsis, maxLines: 1),
                        ))
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLevel = newValue;
                  });
                },
                validator: (value) => value == null ? 'Please select a level/grade' : null,
              ),
              const SizedBox(height: AppConstants.mediumPadding),
              TextFormField(
                controller: _topicController,
                decoration: const InputDecoration(
                  labelText: 'Topic for Notes',
                  hintText: 'e.g., Photosynthesis in Plants',
                  prefixIcon: Icon(Icons.topic, color: AppConstants.primaryColor),
                ),
                maxLines: 2,
                validator: (value) => Validators.validateText(value, 'Topic'),
              ),
              const SizedBox(height: AppConstants.mediumPadding),
              TextFormField(
                controller: _keywordsController,
                decoration: const InputDecoration(
                  labelText: 'Keywords (comma-separated)',
                  hintText: 'e.g., chlorophyll, light, glucose, oxygen',
                  prefixIcon: Icon(Icons.vpn_key, color: AppConstants.primaryColor),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: AppConstants.largePadding),
              Center(
                child: CustomButton(
                  text: 'Generate Notes',
                  onPressed: _isGenerating ? null : _generateNotes,
                  isLoading: _isGenerating,
                  color: AppConstants.accentColor,
                  padding: const EdgeInsets.symmetric(horizontal: AppConstants.largePadding * 2, vertical: AppConstants.mediumPadding),
                ),
              ),
              const SizedBox(height: AppConstants.largePadding),
              Text(
                'Generated Notes',
                style: AppConstants.headline5.copyWith(color: AppConstants.primaryColor),
              ),
              const SizedBox(height: AppConstants.mediumPadding),
              Container(
                padding: const EdgeInsets.all(AppConstants.mediumPadding),
                decoration: BoxDecoration(
                  color: AppConstants.cardColor,
                  borderRadius: BorderRadius.circular(AppConstants.mediumPadding),
                  border: Border.all(color: AppConstants.primaryColor.withOpacity(0.2)),
                ),
                constraints: const BoxConstraints(minHeight: 150),
                child: SelectableText( // Use SelectableText for easy copying
                  _generatedNotesController.text.isEmpty && !_isGenerating
                      ? 'Your generated notes will appear here.'
                      : _generatedNotesController.text,
                  style: AppConstants.bodyText1.copyWith(color: AppConstants.textColor),
                ),
              ),
              const SizedBox(height: AppConstants.largePadding),
            ],
          ),
        ),
      ),
    );
  }
}
