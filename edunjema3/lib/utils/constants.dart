import 'package:flutter/material.dart';

/// Defines constants for the application, including colors, text styles, and padding.
class AppConstants {
  // --- Colors ---
  /// Primary color for the application, a deep blue.
  static const Color primaryColor = Color(0xFF1A237E); // Deep Indigo
  /// Accent color, a vibrant orange for highlights and interactive elements.
  static const Color accentColor = Color(0xFFFF9800); // Orange
  /// Background color for most screens.
  static const Color backgroundColor = Color(0xFFF5F5F5); // Light Grey
  /// Card background color, slightly off-white.
  static const Color cardColor = Color(0xFFFFFFFF); // White
  /// Text color for primary content.
  static const Color textColor = Color(0xFF212121); // Dark Grey
  /// Text color for secondary or muted content.
  static const Color mutedTextColor = Color(0xFF757575); // Medium Grey
  /// Error color, typically red.
  static const Color errorColor = Color(0xFFD32F2F); // Red

  // --- Padding & Margins ---
  /// Small padding value.
  static const double smallPadding = 8.0;
  /// Medium padding value.
  static const double mediumPadding = 16.0;
  /// Large padding value.
  static const double largePadding = 24.0;

  // --- Text Styles ---
  /// Headline 4 style, typically for screen titles.
  static const TextStyle headline4 = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.bold,
    color: textColor,
  );
  /// Headline 5 style, for section titles.
  static const TextStyle headline5 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: textColor,
  );
  /// Headline 6 style, for card titles or important labels.
  static const TextStyle headline6 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: textColor,
  );
  /// Body text style for general content.
  static const TextStyle bodyText1 = TextStyle(
    fontSize: 16,
    color: textColor,
  );
  /// Smaller body text style for descriptions or secondary information.
  static const TextStyle bodyText2 = TextStyle(
    fontSize: 14,
    color: mutedTextColor,
  );
  /// Button text style.
  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // --- Subject List for Dropdown ---
  /// A predefined list of common subjects for selection.
  static const List<String> commonSubjects = [
    'Mathematics',
    'English',
    'Kiswahili',
    'Science and Technology',
    'Social Studies',
    'Religious Education (CRE/IRE/HRE)',
    'Home Science',
    'Agriculture',
    'Business Studies',
    'Computer Studies',
    'Art and Design',
    'Music',
    'Physical Education',
    'Life Skills Education',
    'Environmental Activities',
    'Pastoral Program of Instruction (PPI)',
    'Pre-Technical Studies',
    'Foreign Languages (French, German, Chinese, Arabic)',
    'Indigenous Languages',
    'Sign Language',
    'Visual Arts',
    'Performing Arts',
    'Sports and Physical Education',
    'Social Studies and Religious Education',
    'Integrated Science',
    'Health Education',
    'Career Technology Education',
    'Business Studies',
    'Computer Science',
    'History',
    'Geography',
    'Civics',
    'Economics',
    'General Science',
    'Biology',
    'Chemistry',
    'Physics',
  ];

  // --- Levels/Grades for Dropdown ---
  /// A predefined list of academic levels/grades for selection.
  static const List<String> academicLevelsCBC = [
    'PP1', 'PP2', 'Grade 1', 'Grade 2', 'Grade 3', 'Grade 4', 'Grade 5', 'Grade 6', 'Grade 7', 'Grade 8', 'Grade 9', 'Grade 10'
  ];
  static const List<String> academicLevels844 = [
    'Form 1', 'Form 2', 'Form 3', 'Form 4'
  ];

  // --- Lesson Durations ---
  /// A predefined list of common lesson durations in minutes.
  static const List<int> lessonDurations = [
    30, 35, 40, 45, 50, 60, 70, 80
  ];
}
