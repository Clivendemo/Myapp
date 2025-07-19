import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart';
import '../../utils/cbe_data.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_input_field.dart';
import '../../services/auth_service.dart';
import 'lesson_plan_display.dart';

class PlanGenerator extends StatefulWidget {
  const PlanGenerator({super.key});

  @override
  State<PlanGenerator> createState() => _PlanGeneratorState();
}

class _PlanGeneratorState extends State<PlanGenerator> {
  final _formKey = GlobalKey<FormState>();
  final _topicController = TextEditingController();
  final _inquiryQuestionController = TextEditingController();
  
  String? _selectedClass;
  String? _selectedSubject;
  String? _selectedDuration;
  bool _isGenerating = false;

  @override
  void dispose() {
    _topicController.dispose();
    _inquiryQuestionController.dispose();
    super.dispose();
  }

  Future<void> _generateLessonPlan() async {
    if (!_formKey.currentState!.validate()) return;

    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.currentUser;

    if (user == null) return;

    // Check freemium logic
    if (!user.hasActivePremium && !user.canGenerateFreePlan) {
      _showUpgradeDialog();
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    // Simulate AI generation
    await Future.delayed(const Duration(seconds: 4));

    // Increment plan count
    authService.incrementPlanCount();

    setState(() {
      _isGenerating = false;
    });

    if (mounted) {
      // Navigate to lesson plan display
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LessonPlanDisplay(
            className: _selectedClass!,
            subject: _selectedSubject!,
            topic: _topicController.text,
            duration: _selectedDuration!,
            keyInquiryQuestion: _inquiryQuestionController.text,
          ),
        ),
      );
    }
  }

  void _showUpgradeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upgrade Required'),
        content: const Text(
          'You have used all your free lesson plans. Upgrade to premium to continue generating unlimited CBE-aligned plans.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Upgrade feature coming soon!')),
              );
            },
            child: const Text('Upgrade'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CBE Lesson Plan Generator'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Section
                Container(
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppConstants.primaryColor, AppConstants.accentColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.school,
                        size: 48,
                        color: Colors.white,
                      ),
                      SizedBox(height: AppConstants.paddingMedium),
                      Text(
                        'Create CBE-Aligned Lesson Plan',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppConstants.paddingSmall),
                      Text(
                        'Generate professional lesson plans aligned with Kenya\'s Competency-Based Education curriculum',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: AppConstants.paddingXLarge),
                
                // Usage Info
                Consumer<AuthService>(
                  builder: (context, authService, child) {
                    final user = authService.currentUser;
                    if (user == null) return const SizedBox.shrink();
                    
                    return Container(
                      padding: const EdgeInsets.all(AppConstants.paddingMedium),
                      decoration: BoxDecoration(
                        color: user.hasActivePremium 
                            ? AppConstants.successColor.withOpacity(0.1)
                            : AppConstants.warningColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                        border: Border.all(
                          color: user.hasActivePremium 
                              ? AppConstants.successColor
                              : AppConstants.warningColor,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            user.hasActivePremium ? Icons.star : Icons.info,
                            color: user.hasActivePremium 
                                ? AppConstants.successColor
                                : AppConstants.warningColor,
                          ),
                          const SizedBox(width: AppConstants.paddingSmall),
                          Expanded(
                            child: Text(
                              user.hasActivePremium
                                  ? 'Premium Active - Unlimited lesson plans'
                                  : 'Free Plan: ${AppConstants.freePlanLimit - user.generatedPlansCount} plans remaining',
                              style: TextStyle(
                                color: user.hasActivePremium 
                                    ? AppConstants.successColor
                                    : AppConstants.warningColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: AppConstants.paddingLarge),
                
                // Form Section
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.paddingLarge),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Lesson Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.textPrimary,
                          ),
                        ),
                        
                        const SizedBox(height: AppConstants.paddingLarge),
                        
                        // Class Selection
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Class Level',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppConstants.textPrimary,
                              ),
                            ),
                            const SizedBox(height: AppConstants.paddingSmall),
                            DropdownButtonFormField<String>(
                              value: _selectedClass,
                              decoration: InputDecoration(
                                hintText: 'Select class level',
                                prefixIcon: const Icon(Icons.class_),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                                ),
                                contentPadding: const EdgeInsets.all(AppConstants.paddingMedium),
                              ),
                              items: CBEData.classes.map((String className) {
                                return DropdownMenuItem<String>(
                                  value: className,
                                  child: Text(className),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedClass = newValue;
                                  _selectedSubject = null; // Reset subject when class changes
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a class level';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: AppConstants.paddingMedium),
                        
                        // Subject Selection
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Subject',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppConstants.textPrimary,
                              ),
                            ),
                            const SizedBox(height: AppConstants.paddingSmall),
                            DropdownButtonFormField<String>(
                              value: _selectedSubject,
                              decoration: InputDecoration(
                                hintText: _selectedClass == null 
                                    ? 'Select class first' 
                                    : 'Select subject',
                                prefixIcon: const Icon(Icons.subject),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                                ),
                                contentPadding: const EdgeInsets.all(AppConstants.paddingMedium),
                              ),
                              items: _selectedClass == null 
                                  ? []
                                  : CBEData.getSubjectsForClass(_selectedClass!).map((String subject) {
                                      return DropdownMenuItem<String>(
                                        value: subject,
                                        child: Text(subject),
                                      );
                                    }).toList(),
                              onChanged: _selectedClass == null 
                                  ? null 
                                  : (String? newValue) {
                                      setState(() {
                                        _selectedSubject = newValue;
                                      });
                                    },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a subject';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: AppConstants.paddingMedium),
                        
                        // Topic Input
                        CustomInputField(
                          label: 'Topic/Strand',
                          hint: 'Enter the lesson topic or strand',
                          controller: _topicController,
                          prefixIcon: Icons.topic,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a topic';
                            }
                            if (value.length < 3) {
                              return 'Topic must be at least 3 characters';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: AppConstants.paddingMedium),
                        
                        // Duration Selection
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Lesson Duration',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppConstants.textPrimary,
                              ),
                            ),
                            const SizedBox(height: AppConstants.paddingSmall),
                            DropdownButtonFormField<String>(
                              value: _selectedDuration,
                              decoration: InputDecoration(
                                hintText: 'Select lesson duration',
                                prefixIcon: const Icon(Icons.schedule),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                                ),
                                contentPadding: const EdgeInsets.all(AppConstants.paddingMedium),
                              ),
                              items: CBEData.lessonDurations.map((String duration) {
                                return DropdownMenuItem<String>(
                                  value: duration,
                                  child: Text(duration),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedDuration = newValue;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select lesson duration';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: AppConstants.paddingMedium),
                        
                        // Key Inquiry Question
                        CustomInputField(
                          label: 'Key Inquiry Question (Optional)',
                          hint: 'What key question will guide this lesson?',
                          controller: _inquiryQuestionController,
                          prefixIcon: Icons.help_outline,
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: AppConstants.paddingLarge),
                
                // Generate Button
                CustomButton(
                  text: _isGenerating ? 'Generating CBE Lesson Plan...' : 'Generate CBE Lesson Plan',
                  onPressed: _generateLessonPlan,
                  isLoading: _isGenerating,
                  icon: Icons.auto_awesome,
                ),
                
                const SizedBox(height: AppConstants.paddingMedium),
                
                // Info Text
                Container(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppConstants.primaryColor,
                        size: 20,
                      ),
                      SizedBox(width: AppConstants.paddingSmall),
                      Expanded(
                        child: Text(
                          'Your lesson plan will include specific learning outcomes, core competencies, values, PCIs, and self-reflection sections as per CBE requirements.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppConstants.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
