/// Button visibility service
/// Handles button visibility logic based on calculator state
class ButtonVisibilityService {
  /// Determine if CE (Clear Entry) should be shown
  static bool shouldShowCE({
    required String display,
    required String expression,
  }) {
    // Show CE if there's input beyond "0" or if there's an expression
    return display != '0' || expression.isNotEmpty;
  }

  /// Determine if C (Clear) should be shown
  static bool shouldShowC({
    required String display,
    required String expression,
  }) {
    // Show C if display is "0" and expression is empty
    return display == '0' && expression.isEmpty;
  }

  /// Get the clear button text
  static String getClearButtonText({
    required String display,
    required String expression,
  }) {
    return shouldShowCE(display: display, expression: expression)
        ? 'CE'
        : 'C';
  }

  /// Get clear button command
  static int getClearButtonCommand({
    required String display,
    required String expression,
  }) {
    // Return different commands based on state
    // This will be mapped to actual calculator commands later
    return shouldShowCE(display: display, expression: expression) ? 0 : 1;
  }

  /// Determine if shift button should be highlighted
  static bool shouldHighlightShift(bool isShifted) {
    return isShifted;
  }

  /// Determine if trig button should show hyperbolic label
  static bool shouldShowHyperbolicLabel(bool isTrigHyperbolic) {
    return isTrigHyperbolic;
  }

  /// Private constructor to prevent instantiation
  ButtonVisibilityService._();
}
