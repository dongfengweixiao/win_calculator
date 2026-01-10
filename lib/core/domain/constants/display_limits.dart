/// Display limit constants
/// Defines the limits and constraints for calculator display
class DisplayLimits {
  /// Maximum number of digits to display
  static const int maxDigits = 16;

  /// Maximum number of decimal places
  static const int maxDecimalPlaces = 10;

  /// Maximum length of expression to display
  static const int maxExpressionLength = 256;

  /// Maximum length of display string
  static const int maxDisplayLength = 32;

  /// Maximum number of history items
  static const int maxHistoryItems = 100;

  /// Maximum number of memory items
  static const int maxMemoryItems = 10;

  /// Maximum number of parentheses levels
  static const int maxParenthesesLevels = 24;

  /// Minimum font size for display
  static const double minFontSize = 12.0;

  /// Maximum font size for display
  static const double maxFontSize = 48.0;

  /// Default font size for display
  static const double defaultFontSize = 24.0;

  /// Maximum width for history panel
  static const double maxHistoryPanelWidth = 400.0;

  /// Minimum width for history panel
  static const double minHistoryPanelWidth = 250.0;

  /// Breakpoint for showing history panel
  static const double historyPanelBreakpoint = 640.0;

  /// Breakpoint for tablet layout
  static const double tabletBreakpoint = 768.0;

  /// Breakpoint for desktop layout
  static const double desktopBreakpoint = 1024.0;

  /// Check if string exceeds display limit
  static bool exceedsDisplayLimit(String value) {
    return value.length > maxDisplayLength;
  }

  /// Check if expression exceeds limit
  static bool exceedsExpressionLimit(String expression) {
    return expression.length > maxExpressionLength;
  }

  /// Truncate value to display limit
  static String truncateToDisplayLimit(String value) {
    if (exceedsDisplayLimit(value)) {
      return value.substring(0, maxDisplayLength - 3) + '...';
    }
    return value;
  }

  /// Check if history count exceeds limit
  static bool exceedsHistoryLimit(int count) {
    return count > maxHistoryItems;
  }

  /// Check if memory count exceeds limit
  static bool exceedsMemoryLimit(int count) {
    return count > maxMemoryItems;
  }

  /// Check if parentheses count exceeds limit
  static bool exceedsParenthesesLimit(int count) {
    return count > maxParenthesesLevels;
  }

  /// Private constructor to prevent instantiation
  DisplayLimits._();
}
