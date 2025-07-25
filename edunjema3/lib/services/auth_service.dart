import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print('[AuthService] FirebaseAuthException during signIn: Code: ${e.code}, Message: ${e.message}');
      throw e.message ?? 'An unknown error occurred during sign-in.';
    } catch (e, st) {
      print('[AuthService] Unexpected error during signIn. Type: ${e.runtimeType}, Message: $e');
      print('Stack Trace: $st');
      throw 'An unexpected error occurred: ${e.toString()}';
    }
  }

  Future<UserCredential> createUserWithEmailAndPassword(String email, String password) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print('[AuthService] FirebaseAuthException during createUser: Code: ${e.code}, Message: ${e.message}');
      throw e.message ?? 'An unknown error occurred during registration.';
    } catch (e, st) {
      print('[AuthService] Unexpected error during createUser. Type: ${e.runtimeType}, Message: $e');
      print('Stack Trace: $st');
      throw 'An unexpected error occurred: ${e.toString()}';
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e, st) {
      print('[AuthService] Error during signOut. Type: ${e.runtimeType}, Message: $e');
      print('Stack Trace: $st');
      rethrow;
    }
  }
}
