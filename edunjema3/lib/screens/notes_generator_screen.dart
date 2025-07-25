import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../services/openai_service.dart';

class NotesGeneratorScreen extends StatefulWidget {
  const NotesGeneratorScreen({super.key});

  @override
  State<NotesGeneratorScreen> createState() => _NotesGeneratorScreenState();
}

class _NotesGeneratorScreenState extends State<NotesGeneratorScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedSyllabus;
  String? _selectedGrade;
  String? _selectedSubject;
  String? _selectedStrandTopic;
  String? _selectedSubstrandSubtopic;

  String? _generatedNotes;
  bool _isGenerating = false;
  bool _isLoadingInitialData = true;
  String? _initialDataError;

  Map<String, dynamic> _syllabusContent = {};
  Map<String, String> _userSettings = {};

  final FirestoreService _firestoreService = FirestoreService();
  final OpenAIService _openAIService = OpenAIService();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoadingInitialData = true;
      _initialDataError = null;
    });
    try {
      _syllabusContent = await _firestoreService.getSyllabusContent();
      _userSettings = await _firestoreService.getUserSettings();

      setState(() {
        _selectedSyllabus = _userSettings['syllabus'];
        _selectedGrade = _userSettings['grade'];
        _selectedSubject = _userSettings['subject'];
      });
    } catch (e) {
      print('Error loading initial notes data: $e');
      setState(() {
        _initialDataError = 'Failed to load initial data: $e';
      });
    } finally {
      setState(() {
        _isLoadingInitialData = false;
      });
    }
  }

  void _generateNotes() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isGenerating = true;
      _generatedNotes = null;
    });

    try {
      final generatedContent = await _openAIService.generateNotes(
        syllabus: _selectedSyllabus!,
        grade: _selectedGrade!,
        subject: _selectedSubject!,
        strandTopic: _selectedStrandTopic!,
        substrandSubtopic: _selectedSubstrandSubtopic!,
      );

      setState(() {
        _generatedNotes = generatedContent;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notes generation complete!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating notes: $e')),
      );
      setState(() {
        _generatedNotes = 'Error: $e';
      });
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoadingInitialData && _userSettings['syllabus'] != _selectedSyllabus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadInitialData();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes Generator'),
        centerTitle: true,
      ),
      body: _isLoadingInitialData
          ? const Center(child: CircularProgressIndicator())
          : _initialDataError != null
              ? Center(child: Text('Error: $_initialDataError'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Generate notes for a specific topic',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                        ),
                        const SizedBox(height: 24),
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Notes Details',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 16),
                                Text('Syllabus: ${_selectedSyllabus ?? 'N/A'}', style: Theme.of(context).textTheme.titleMedium),
                                const SizedBox(height: 8),
                                Text('Grade/Form: ${_selectedGrade ?? 'N/A'}', style: Theme.of(context).textTheme.titleMedium),
                                const SizedBox(height: 8),
                                Text('Subject: ${_selectedSubject ?? 'N/A'}', style: Theme.of(context).textTheme.titleMedium),
                                const SizedBox(height: 24),

                                DropdownButtonFormField<String>(
                                  value: _selectedStrandTopic,
                                  decoration: InputDecoration(
                                    labelText: _selectedSyllabus == 'CBC' ? 'Strand' : 'Topic',
                                    prefixIcon: const Icon(Icons.category),
                                  ),
                                  items: (_selectedSyllabus != null && _selectedGrade != null && _selectedSubject != null)
                                      ? (_syllabusContent[_selectedSyllabus!]?[_selectedGrade!]?[_selectedSubject!] as Map<String, dynamic>?)
                                          ?.keys
                                          .map<DropdownMenuItem<String>>((item) { // MODIFIED: Explicit type argument
                                            return DropdownMenuItem<String>(
                                              value: item.toString(),
                                              child: Text(item.toString()),
                                            );
                                          }).toList() ?? []
                                      : [],
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedStrandTopic = newValue;
                                      _selectedSubstrandSubtopic = null;
                                    });
                                  },
                                  validator: (value) => value == null ? 'Please select a ${_selectedSyllabus == 'CBC' ? 'strand' : 'topic'}' : null,
                                ),
                                const SizedBox(height: 16),

                                DropdownButtonFormField<String>(
                                  value: _selectedSubstrandSubtopic,
                                  decoration: InputDecoration(
                                    labelText: _selectedSyllabus == 'CBC' ? 'Substrand' : 'Subtopic',
                                    prefixIcon: const Icon(Icons.subtitles),
                                  ),
                                  items: (_selectedSyllabus != null && _selectedGrade != null && _selectedSubject != null && _selectedStrandTopic != null)
                                      ? (_syllabusContent[_selectedSyllabus!]?[_selectedGrade!]?[_selectedSubject!]?[_selectedStrandTopic!] as List<dynamic>?)
                                          ?.map<DropdownMenuItem<String>>((item) { // MODIFIED: Explicit type argument
                                            return DropdownMenuItem<String>(
                                              value: item.toString(),
                                              child: Text(item.toString()),
                                            );
                                          }).toList() ?? []
                                      : [],
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedSubstrandSubtopic = newValue;
                                    });
                                  },
                                  validator: (value) => value == null ? 'Please select a ${_selectedSyllabus == 'CBC' ? 'substrand' : 'subtopic'}' : null,
                                ),
                                const SizedBox(height: 32),
                                Center(
                                  child: _isGenerating
                                      ? const CircularProgressIndicator()
                                      : ElevatedButton(
                                          onPressed: _generateNotes,
                                          child: const Text('Generate Notes'),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_generatedNotes != null) ...[
                          const SizedBox(height: 24),
                          Text(
                            'Generated Notes',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: SelectableText(
                                _generatedNotes!,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
    );
  }
}
