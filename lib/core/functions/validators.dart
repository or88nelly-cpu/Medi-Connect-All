/// Common input validation utility functions.
/// Centralizes input checks to eliminate redundant validation logic.
class ValidationUtils {
  /// Validates that a field is not null or empty.
  static String? validateRequired(String? value, [String? errorMessage]) {
    if (value == null || value.trim().isEmpty) {
      return errorMessage ?? "This field is required";
    }
    return null;
  }

  /// Validates standard email patterns.
  static String? validateEmail(String? value, [String? errorMessage]) {
    final requiredCheck = validateRequired(value, errorMessage);
    if (requiredCheck != null) return requiredCheck;

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value!)) {
      return errorMessage ?? "Enter a valid email address";
    }
    return null;
  }

  /// Validates standard password strength requirements (min 8 chars).
  static String? validatePassword(String? value, [String? errorMessage]) {
    final requiredCheck = validateRequired(value, errorMessage);
    if (requiredCheck != null) return requiredCheck;

    if (value!.length < 8) {
      return errorMessage ?? "Password must be at least 8 characters";
    }
    return null;
  }

  /// Validates typical international phone formats.
  static String? validatePhone(String? value, [String? errorMessage]) {
    if (value == null || value.trim().isEmpty) return null; // Optional fields

    final phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'\s+\-\(\)'), ''))) {
      return errorMessage ?? "Enter a valid phone number";
    }
    return null;
  }

  ValidationUtils._();
}
