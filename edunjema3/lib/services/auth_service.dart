import 'package:firebase_auth/firebase_auth.dart';
import 'package:edunjema3/models/user_profile.dart';
import 'package:edunjema3/services/firestore_service.dart'; // Import FirestoreService

/// A service class for handling user authentication with Firebase.
class AuthService {
  /// Firebase Authentication instance.
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  /// Firestore Service instance for managing user profiles.
  final FirestoreService _firestoreService = FirestoreService();

  /// Stream of [User] objects representing the current authentication state.
  ///
  /// Emits null if the user is signed out, or a [User] object if signed in.
  Stream<User?> get user => _firebaseAuth.authStateChanges();

  /// Registers a new user with email and password.
  ///
  /// [email] The user's email address.
  /// [password] The user's password.
  /// [name] The user's full name, to be stored in their profile.
  ///
  /// Returns the [UserCredential] upon successful registration.
  /// Throws a [FirebaseAuthException] if registration fails.
  Future<UserCredential> registerWithEmailAndPassword(String email, String password, String name) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create a user profile in Firestore immediately after successful registration
      if (userCredential.user != null) {
        UserProfile newUserProfile = UserProfile(
          uid: userCredential.user!.uid,
          email: email,
          name: name,
          subjects: [], // Initial empty subjects
          syllabusPreference: 'CBC', // Default preference
        );
        await _firestoreService.createUserProfile(newUserProfile);
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase authentication errors
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('An account already exists for that email.');
      }
      throw Exception(e.message); // Re-throw other Firebase exceptions
    } catch (e) {
      throw Exception('Failed to register: $e'); // Handle general errors
    }
  }

  /// Signs in a user with email and password.
  ///
  /// [email] The user's email address.
  /// [password] The user's password.
  ///
  /// Returns the [UserCredential] upon successful sign-in.
  /// Throws a [FirebaseAuthException] if sign-in fails.
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase authentication errors
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      }
      throw Exception(e.message); // Re-throw other Firebase exceptions
    } catch (e) {
      throw Exception('Failed to sign in: $e'); // Handle general errors
    }
  }

  /// Sends a password reset email to the given email address.
  ///
  /// [email] The email address to send the reset link to.
  ///
  /// Throws a [FirebaseAuthException] if the operation fails.
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message); // Re-throw Firebase exceptions
    } catch (e) {
      throw Exception('Failed to send password reset email: $e'); // Handle general errors
    }
  }

  /// Signs out the current user.
  ///
  /// Throws an [Exception] if sign-out fails.
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e'); // Handle general errors
    }
  }
}
