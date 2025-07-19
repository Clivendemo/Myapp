import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;

  // Mock sign in
  Future<bool> signInWithEmail(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock successful login
    _currentUser = UserModel(
      uid: 'mock_uid_123',
      email: email,
      displayName: 'Test Teacher',
      registeredAt: DateTime.now(),
      generatedPlansCount: 1,
    );

    _isLoading = false;
    notifyListeners();
    return true;
  }

  // Mock sign up
  Future<bool> signUpWithEmail(String email, String password, String name) async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock successful registration
    _currentUser = UserModel(
      uid: 'mock_uid_123',
      email: email,
      displayName: name,
      registeredAt: DateTime.now(),
    );

    _isLoading = false;
    notifyListeners();
    return true;
  }

  // Sign out
  Future<void> signOut() async {
    _currentUser = null;
    notifyListeners();
  }

  // Increment plan count (for testing freemium logic)
  void incrementPlanCount() {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        generatedPlansCount: _currentUser!.generatedPlansCount + 1,
      );
      notifyListeners();
    }
  }
}
