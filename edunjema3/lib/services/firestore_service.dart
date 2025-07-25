import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  Future<Map<String, dynamic>> getSyllabusContent() async {
    try {
      final doc = await _db.collection('syllabus').doc('content').get();
      if (doc.exists && doc.data() != null) {
        return doc.data()!;
      }
      return {};
    } catch (e) {
      print('Error fetching syllabus content: $e');
      return {};
    }
  }

  Future<void> saveUserSettings(Map<String, String> settings) async {
    if (currentUserId == null) return;
    try {
      await _db.collection('users').doc(currentUserId).set(
        {'settings': settings},
        SetOptions(merge: true),
      );
    } catch (e) {
      print('Error saving user settings: $e');
      rethrow;
    }
  }

  Future<Map<String, String>> getUserSettings() async {
    if (currentUserId == null) return {};
    try {
      final doc = await _db.collection('users').doc(currentUserId).get();
      if (doc.exists && doc.data() != null && doc.data()!.containsKey('settings')) {
        return Map<String, String>.from(doc.data()!['settings']);
      }
      return {};
    } catch (e) {
      print('Error fetching user settings: $e');
      return {};
    }
  }
}
