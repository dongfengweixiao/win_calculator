import '../../domain/constants/display_limits.dart';

/// Input validation service
/// Provides validation logic for calculator input
class InputValidator {
  /// Validate digit input
  static bool isValidDigit(int digit) {
    return digit >= 0 && digit <= 9;
  }

  /// Validate if decimal point can be added
  static bool canInputDecimal(String currentDisplay) {
    // Check if display already contains a decimal point
    if (currentDisplay.contains('.')) {
      return false;
    }

    // Check if display length would exceed limit
    if (currentDisplay.length >= DisplayLimits.maxDisplayLength) {
      return false;
    }

    return true;
  }

  /// Validate if opening parenthesis can be added
  static bool canInputOpenParen(int openCount, int closeCount) {
    // Check if we've exceeded the maximum parentheses levels
    if (openCount >= DisplayLimits.maxParenthesesLevels) {
      return false;
    }

    // Allow opening parenthesis if we haven't exceeded the limit
    return openCount < DisplayLimits.maxParenthesesLevels;
  }

  /// Validate if closing parenthesis can be added
  static bool canInputCloseParen(int openCount, int closeCount) {
    // Can only add closing parenthesis if we have more open than close
    return closeCount < openCount;
  }

  /// Validate if negate operation can be performed
  static bool canNegate(String currentDisplay) {
    // Cannot negate an empty display or error state
    if (currentDisplay.isEmpty || currentDisplay == 'Error') {
      return false;
    }

    return true;
  }

  /// Validate display value
  static bool isValidDisplayValue(String value) {
    if (value.isEmpty) {
      return false;
    }

    // Check for error state
    if (value == 'Error') {
      return false;
    }

    return true;
  }

  /// Validate history item index
  static bool isValidHistoryIndex(int index, int totalCount) {
    return index >= 0 && index < totalCount;
  }

  /// Validate memory item index
  static bool isValidMemoryIndex(int index, int totalCount) {
    return index >= 0 && index < totalCount;
  }

  /// Check if input would exceed display limit
  static bool wouldExceedDisplayLimit(
    String currentDisplay,
    String input,
  ) {
    final newLength = currentDisplay.length + input.length;
    return newLength > DisplayLimits.maxDisplayLength;
  }

  /// Private constructor to prevent instantiation
  InputValidator._();
}
