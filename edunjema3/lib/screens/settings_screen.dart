import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? _selectedSyllabus;
  String? _selectedGrade;
  String? _selectedSubject;

  bool _isLoadingSettings = true;
  String? _settingsError;
  Map<String, dynamic> _syllabusContent = {};
  Map<String, String> _userSettings = {};

  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoadingSettings = true;
      _settingsError = null;
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
      print('Error loading initial settings data: $e');
      setState(() {
        _settingsError = 'Failed to load settings: $e';
      });
    } finally {
      setState(() {
        _isLoadingSettings = false;
      });
    }
  }

  void _saveSettings() async {
    setState(() {
      _isLoadingSettings = true;
      _settingsError = null;
    });
    try {
      final newSettings = {
        'syllabus': _selectedSyllabus ?? '',
        'grade': _selectedGrade ?? '',
        'subject': _selectedSubject ?? '',
      };
      await _firestoreService.saveUserSettings(newSettings);
      setState(() {
        _userSettings = newSettings;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings saved successfully!')),
      );
    } catch (e) {
      print('Error saving settings: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save settings: $e')),
      );
      setState(() {
        _settingsError = 'Failed to save settings: $e';
      });
    } finally {
      setState(() {
        _isLoadingSettings = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: _isLoadingSettings
          ? const Center(child: CircularProgressIndicator())
          : _settingsError != null
              ? Center(child: Text('Error: $_settingsError'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Personalize your experience',
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
                                'Syllabus Preference',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                value: _selectedSyllabus,
                                decoration: const InputDecoration(
                                  labelText: 'Syllabus',
                                  prefixIcon: Icon(Icons.menu_book),
                                ),
                                items: _syllabusContent.keys.map<DropdownMenuItem<String>>((item) { // MODIFIED: Explicit type argument
                                  return DropdownMenuItem<String>(
                                    value: item.toString(),
                                    child: Text(item.toString()),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedSyllabus = newValue;
                                    _selectedGrade = null;
                                    _selectedSubject = null;
                                  });
                                },
                                validator: (value) => value == null ? 'Please select a syllabus' : null,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Grade/Form Level',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                value: _selectedGrade,
                                decoration: const InputDecoration(
                                  labelText: 'Grade/Form',
                                  prefixIcon: Icon(Icons.grade),
                                ),
                                items: _selectedSyllabus != null
                                    ? (_syllabusContent[_selectedSyllabus!] as Map<String, dynamic>?)
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
                                    _selectedGrade = newValue;
                                    _selectedSubject = null;
                                  });
                                },
                                validator: (value) => value == null ? 'Please select a grade/form' : null,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Subject',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                value: _selectedSubject,
                                decoration: const InputDecoration(
                                  labelText: 'Subject',
                                  prefixIcon: Icon(Icons.subject),
                                ),
                                items: (_selectedSyllabus != null && _selectedGrade != null)
                                    ? (_syllabusContent[_selectedSyllabus!]?[_selectedGrade!] as Map<String, dynamic>?)
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
                                    _selectedSubject = newValue;
                                  });
                                },
                                validator: (value) => value == null ? 'Please select a subject' : null,
                              ),
                              const SizedBox(height: 32),
                              Center(
                                child: ElevatedButton(
                                  onPressed: _isLoadingSettings ? null : _saveSettings,
                                  child: _isLoadingSettings
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                        )
                                      : const Text('Save Settings'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
