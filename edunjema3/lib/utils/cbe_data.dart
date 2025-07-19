class CBEData {
  // CBE Classes (Grade 1-10 + Form 2-4 for transition)
  static const List<String> classes = [
    'Grade 1',
    'Grade 2', 
    'Grade 3',
    'Grade 4',
    'Grade 5',
    'Grade 6',
    'Grade 7',
    'Grade 8',
    'Grade 9',
    'Grade 10',
    'Form 2', // Transition - 8-4-4 being phased out
    'Form 3', // Transition - 8-4-4 being phased out
    'Form 4', // Transition - 8-4-4 being phased out
  ];

  // CBE Subjects by Class Level
  static const Map<String, List<String>> subjectsByClass = {
    'Grade 1': [
      'English Activities',
      'Kiswahili Activities', 
      'Mathematical Activities',
      'Environmental Activities',
      'Hygiene and Nutrition Activities',
      'Religious Education',
      'Movement and Creative Activities',
    ],
    'Grade 2': [
      'English Activities',
      'Kiswahili Activities',
      'Mathematical Activities', 
      'Environmental Activities',
      'Hygiene and Nutrition Activities',
      'Religious Education',
      'Movement and Creative Activities',
    ],
    'Grade 3': [
      'English Activities',
      'Kiswahili Activities',
      'Mathematical Activities',
      'Environmental Activities', 
      'Hygiene and Nutrition Activities',
      'Religious Education',
      'Movement and Creative Activities',
    ],
    'Grade 4': [
      'English',
      'Kiswahili',
      'Mathematics',
      'Science and Technology',
      'Social Studies',
      'Health Education',
      'Religious Education',
      'Creative Arts',
      'Physical and Health Education',
    ],
    'Grade 5': [
      'English',
      'Kiswahili', 
      'Mathematics',
      'Science and Technology',
      'Social Studies',
      'Health Education',
      'Religious Education',
      'Creative Arts',
      'Physical and Health Education',
    ],
    'Grade 6': [
      'English',
      'Kiswahili',
      'Mathematics', 
      'Science and Technology',
      'Social Studies',
      'Health Education',
      'Religious Education',
      'Creative Arts',
      'Physical and Health Education',
    ],
    'Grade 7': [
      'English',
      'Kiswahili',
      'Mathematics',
      'Integrated Science',
      'Health Education',
      'Pre-Technical and Pre-Career Education',
      'Social Studies',
      'Religious Education',
      'Creative Arts',
      'Physical and Health Education',
    ],
    'Grade 8': [
      'English',
      'Kiswahili',
      'Mathematics',
      'Integrated Science',
      'Health Education', 
      'Pre-Technical and Pre-Career Education',
      'Social Studies',
      'Religious Education',
      'Creative Arts',
      'Physical and Health Education',
    ],
    'Grade 9': [
      'English',
      'Kiswahili',
      'Mathematics',
      'Integrated Science',
      'Health Education',
      'Pre-Technical and Pre-Career Education', 
      'Social Studies',
      'Religious Education',
      'Creative Arts',
      'Physical and Health Education',
    ],
    'Grade 10': [
      'English',
      'Kiswahili',
      'Mathematics',
      'Integrated Science',
      'Health Education',
      'Pre-Technical and Pre-Career Education',
      'Social Studies', 
      'Religious Education',
      'Creative Arts',
      'Physical and Health Education',
    ],
    'Form 2': [
      'English',
      'Kiswahili',
      'Mathematics',
      'Biology',
      'Chemistry',
      'Physics',
      'History',
      'Geography',
      'Religious Education',
      'Business Studies',
    ],
    'Form 3': [
      'English',
      'Kiswahili', 
      'Mathematics',
      'Biology',
      'Chemistry',
      'Physics',
      'History',
      'Geography',
      'Religious Education',
      'Business Studies',
    ],
    'Form 4': [
      'English',
      'Kiswahili',
      'Mathematics',
      'Biology',
      'Chemistry', 
      'Physics',
      'History',
      'Geography',
      'Religious Education',
      'Business Studies',
    ],
  };

  // Core Competencies for CBE
  static const List<String> coreCompetencies = [
    'Communication and Collaboration',
    'Critical Thinking and Problem Solving',
    'Creativity and Imagination',
    'Citizenship',
    'Digital Literacy',
    'Learning to Learn',
    'Self-Efficacy',
  ];

  // Core Values for CBE
  static const List<String> coreValues = [
    'Love',
    'Responsibility',
    'Respect',
    'Unity',
    'Peace',
    'Patriotism',
    'Social Justice',
  ];

  // Pertinent and Contemporary Issues (PCIs)
  static const List<String> pcis = [
    'Education for Sustainable Development',
    'Safety and Security Education',
    'Disaster Risk Reduction',
    'Social Cohesion and National Unity',
    'Life Skills Education',
    'Citizenship Education',
    'Financial Literacy',
    'Entrepreneurship Education',
    'Health Education',
    'Environmental Education',
  ];

  // Lesson Duration Options
  static const List<String> lessonDurations = [
    '30 minutes',
    '40 minutes', 
    '60 minutes',
    '80 minutes',
    '90 minutes',
  ];

  static List<String> getSubjectsForClass(String className) {
    return subjectsByClass[className] ?? [];
  }

  static List<String> getTopicsForSubject(String subject) {
    // Sample topics - in real app, this would come from database
    switch (subject.toLowerCase()) {
      case 'mathematics':
      case 'mathematical activities':
        return [
          'Number Concepts',
          'Addition and Subtraction',
          'Multiplication and Division',
          'Fractions and Decimals',
          'Geometry and Measurement',
          'Data Handling',
        ];
      case 'english':
      case 'english activities':
        return [
          'Reading and Comprehension',
          'Grammar and Language Use',
          'Writing Skills',
          'Speaking and Listening',
          'Literature',
          'Vocabulary Development',
        ];
      case 'integrated science':
      case 'science and technology':
        return [
          'Living and Non-living Things',
          'Plants and Animals',
          'Matter and Materials',
          'Energy and Forces',
          'Earth and Space',
          'Health and Environment',
        ];
      default:
        return [
          'Introduction to $subject',
          'Basic Concepts',
          'Practical Applications',
          'Assessment and Evaluation',
        ];
    }
  }
}
