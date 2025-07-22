/// Utility class for input field validation.
class Validators {
  /// Validates an email address.
  /// Returns an error message if the email is invalid, otherwise returns null.
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required.';
    }
    // Regular expression for email validation
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email.';
    }
    return null;
  }

  /// Validates a password.
  /// Returns an error message if the password is too short, otherwise returns null.
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long.';
    }
    return null;
  }

  /// Validates a confirmation password against the original password.
  /// Returns an error message if passwords do not match, otherwise returns null.
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required.';
    }
    if (value != password) {
      return 'Passwords do not match.';
    }
    return null;
  }

  /// Validates a general text input (e.g., name).
  /// Returns an error message if the input is empty, otherwise returns null.
  static String? validateText(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required.';
    }
    return null;
  }
}
