import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:edunjema3/models/user_profile.dart';
import 'package:edunjema3/services/firestore_service.dart';
import 'package:edunjema3/utils/constants.dart';
import 'package:edunjema3/utils/validators.dart';
import 'package:edunjema3/widgets/custom_button.dart';

/// A screen for users to view and edit their profile information.
class ProfileScreen extends StatefulWidget {
  /// Creates a [ProfileScreen] instance.
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  UserProfile? _userProfile;
  bool _isLoading = true;
  String? _selectedSyllabus;
  List<String> _subjects = []; // List to hold user's selected subjects
  String? _selectedSubjectToAdd; // Holds the subject selected from the dropdown

  final FirestoreService _firestoreService = FirestoreService();
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  /// Loads the current user's profile data from Firestore.
  Future<void> _loadUserProfile() async {
    if (_currentUser == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    try {
      final profile = await _firestoreService.getUserProfile(_currentUser!.uid);
      if (profile != null) {
        setState(() {
          _userProfile = profile;
          _nameController.text = profile.name;
          _emailController.text = profile.email;
          _selectedSyllabus = profile.syllabusPreference;
          _subjects = List.from(profile.subjects); // Copy to mutable list
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Handles the update profile action.
  Future<void> _updateProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      try {
        if (_currentUser != null && _userProfile != null) {
          // Prepare data for update
          Map<String, dynamic> dataToUpdate = {
            'name': _nameController.text,
            'subjects': _subjects,
            'syllabusPreference': _selectedSyllabus,
          };
          await _firestoreService.updateUserProfile(_currentUser!.uid, dataToUpdate);

          // Update local profile instance
          setState(() {
            _userProfile = _userProfile!.copyWith(
              name: _nameController.text,
              subjects: _subjects,
              syllabusPreference: _selectedSyllabus,
            );
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully!')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: ${e.toString()}')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Adds the currently selected subject from the dropdown to the list of subjects.
  void _addSubject() {
    if (_selectedSubjectToAdd != null && !_subjects.contains(_selectedSubjectToAdd!)) {
      setState(() {
        _subjects.add(_selectedSubjectToAdd!);
        _selectedSubjectToAdd = null; // Reset dropdown selection
      });
    }
  }

  /// Removes a subject from the list.
  void _removeSubject(String subject) {
    setState(() {
      _subjects.remove(subject);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppConstants.primaryColor))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.largePadding),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personal Information',
                      style: AppConstants.headline5.copyWith(color: AppConstants.primaryColor),
                    ),
                    const SizedBox(height: AppConstants.mediumPadding),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person, color: AppConstants.primaryColor),
                      ),
                      validator: (value) => Validators.validateText(value, 'Full Name'),
                    ),
                    const SizedBox(height: AppConstants.mediumPadding),
                    TextFormField(
                      controller: _emailController,
                      readOnly: true, // Email should not be editable directly from profile
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email, color: AppConstants.primaryColor),
                        filled: true,
                        fillColor: AppConstants.backgroundColor, // Indicate it's read-only
                      ),
                    ),
                    const SizedBox(height: AppConstants.largePadding),
                    Text(
                      'Teaching Details',
                      style: AppConstants.headline5.copyWith(color: AppConstants.primaryColor),
                    ),
                    const SizedBox(height: AppConstants.mediumPadding),
                    DropdownButtonFormField<String>(
                      value: _selectedSyllabus,
                      decoration: const InputDecoration(
                        labelText: 'Preferred Syllabus',
                        prefixIcon: Icon(Icons.menu_book, color: AppConstants.primaryColor),
                      ),
                      items: <String>['CBC', '8-4-4']
                          .map((String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, overflow: TextOverflow.ellipsis, maxLines: 1), // Added overflow handling
                              ))
                          .toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedSyllabus = newValue;
                        });
                      },
                      validator: (value) => value == null ? 'Please select a syllabus' : null,
                    ),
                    const SizedBox(height: AppConstants.mediumPadding),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedSubjectToAdd,
                            decoration: const InputDecoration(
                              labelText: 'Select Subject',
                              prefixIcon: Icon(Icons.subject, color: AppConstants.primaryColor),
                            ),
                            items: AppConstants.commonSubjects
                                .where((subject) => !_subjects.contains(subject)) // Only show unselected subjects
                                .map((String subject) => DropdownMenuItem<String>(
                                      value: subject,
                                      child: Text(subject, overflow: TextOverflow.ellipsis, maxLines: 1), // Added overflow handling
                                    ))
                                .toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedSubjectToAdd = newValue;
                              });
                            },
                            // No validator needed here as it's for adding, not a required field for form submission
                          ),
                        ),
                        const SizedBox(width: AppConstants.smallPadding),
                        CustomButton(
                          text: 'Add',
                          onPressed: _selectedSubjectToAdd == null ? null : _addSubject, // This now correctly passes null
                          padding: const EdgeInsets.symmetric(horizontal: AppConstants.mediumPadding, vertical: AppConstants.smallPadding),
                          borderRadius: BorderRadius.circular(AppConstants.smallPadding),
                          color: AppConstants.accentColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.mediumPadding),
                    Wrap(
                      spacing: AppConstants.smallPadding,
                      runSpacing: AppConstants.smallPadding,
                      children: _subjects
                          .map(
                            (subject) => Chip(
                              label: Text(subject),
                              onDeleted: () => _removeSubject(subject),
                              deleteIcon: const Icon(Icons.close, size: 18),
                              backgroundColor: AppConstants.primaryColor.withOpacity(0.1),
                              labelStyle: AppConstants.bodyText2.copyWith(color: AppConstants.primaryColor),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: AppConstants.largePadding * 2),
                    Center(
                      child: CustomButton(
                        text: 'Save Profile',
                        onPressed: _updateProfile,
                        isLoading: _isLoading,
                        color: AppConstants.primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: AppConstants.largePadding * 2, vertical: AppConstants.mediumPadding),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
