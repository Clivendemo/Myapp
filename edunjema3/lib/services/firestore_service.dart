import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edunjema3/models/user_profile.dart';
import 'package:edunjema3/models/lesson_plan.dart'; // Import LessonPlan

/// A service class for interacting with Firestore database.
class FirestoreService {
  /// Firestore instance.
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Reference to the 'users' collection in Firestore.
  CollectionReference<Map<String, dynamic>> get _usersCollection => _db.collection('users');
  /// Reference to the 'lessonPlans' collection in Firestore.
  CollectionReference<Map<String, dynamic>> get _lessonPlansCollection => _db.collection('lessonPlans');

  /// Creates or updates a user profile in Firestore.
  ///
  /// [userProfile] The [UserProfile] object to be saved.
  ///
  /// Throws an [Exception] if the operation fails.
  Future<void> createUserProfile(UserProfile userProfile) async {
    try {
      await _usersCollection.doc(userProfile.uid).set(userProfile.toFirestore());
    } catch (e) {
      throw Exception('Failed to create/update user profile: $e');
    }
  }

  /// Retrieves a user profile from Firestore by UID.
  ///
  /// [uid] The unique ID of the user.
  ///
  /// Returns the [UserProfile] if found, otherwise null.
  /// Throws an [Exception] if the operation fails.
  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      DocumentSnapshot doc = await _usersCollection.doc(uid).get();
      if (doc.exists) {
        return UserProfile.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  /// Updates specific fields of an existing user profile.
  ///
  /// [uid] The unique ID of the user whose profile is to be updated.
  /// [data] A map of fields to update (e.g., {'name': 'New Name'}).
  ///
  /// Throws an [Exception] if the operation fails.
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    try {
      await _usersCollection.doc(uid).update(data);
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  /// Saves a new lesson plan to Firestore.
  ///
  /// [lessonPlan] The [LessonPlan] object to be saved.
  ///
  /// Returns the ID of the newly created document.
  /// Throws an [Exception] if the operation fails.
  Future<String> saveLessonPlan(LessonPlan lessonPlan) async {
    try {
      DocumentReference docRef = await _lessonPlansCollection.add(lessonPlan.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to save lesson plan: $e');
    }
  }

  /// Updates specific fields of an existing lesson plan.
  ///
  /// [planId] The ID of the lesson plan to update.
  /// [data] A map of fields to update (e.g., {'introduction': 'New Intro'}).
  ///
  /// Throws an [Exception] if the operation fails.
  Future<void> updateLessonPlan(String planId, Map<String, dynamic> data) async {
    try {
      await _lessonPlansCollection.doc(planId).update(data);
    } catch (e) {
      throw Exception('Failed to update lesson plan: $e');
    }
  }

  /// Retrieves a stream of lesson plans for a specific user from Firestore.
  ///
  /// [userId] The ID of the user whose lesson plans are to be fetched.
  ///
  /// Returns a [Stream] of a list of [LessonPlan] objects, ordered by creation date.
  Stream<List<LessonPlan>> getLessonPlansForUser(String userId) {
    return _lessonPlansCollection
        .where('teacherId', isEqualTo: userId)
        .orderBy('createdAt', descending: true) // Order by creation date
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => LessonPlan.fromFirestore(doc)).toList());
  }
}
