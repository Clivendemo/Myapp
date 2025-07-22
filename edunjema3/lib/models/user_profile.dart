import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a user's profile information stored in Firestore.
class UserProfile {
  /// Unique identifier for the user, typically from Firebase Auth UID.
  final String uid;
  /// The user's email address.
  final String email;
  /// The user's full name.
  final String name;
  /// A list of subjects the teacher is registered to teach.
  final List<String> subjects;
  /// The teacher's preferred syllabus (e.g., 'CBC', '8-4-4').
  final String syllabusPreference;

  /// Creates a [UserProfile] instance.
  UserProfile({
    required this.uid,
    required this.email,
    required this.name,
    this.subjects = const [],
    this.syllabusPreference = 'CBC', // Default preference
  });

  /// Creates a [UserProfile] instance from a Firestore document snapshot.
  ///
  /// [doc] The [DocumentSnapshot] containing the user profile data.
  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      uid: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      subjects: List<String>.from(data['subjects'] ?? []),
      syllabusPreference: data['syllabusPreference'] ?? 'CBC',
    );
  }

  /// Converts this [UserProfile] instance into a JSON format suitable for Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'subjects': subjects,
      'syllabusPreference': syllabusPreference,
      'createdAt': FieldValue.serverTimestamp(), // Add a timestamp for creation
    };
  }

  /// Creates a new [UserProfile] instance with updated values.
  ///
  /// This is useful for immutably updating parts of the profile.
  UserProfile copyWith({
    String? uid,
    String? email,
    String? name,
    List<String>? subjects,
    String? syllabusPreference,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      subjects: subjects ?? this.subjects,
      syllabusPreference: syllabusPreference ?? this.syllabusPreference,
    );
  }
}
