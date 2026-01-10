import '../../domain/constants/display_limits.dart';

/// Input formatting service
/// Formats calculator input and output for display
class InputFormatter {
  /// Format display value
  static String formatDisplay(String value) {
    if (value.isEmpty) {
      return '0';
    }

    // Truncate if exceeds display limit
    if (DisplayLimits.exceedsDisplayLimit(value)) {
      return DisplayLimits.truncateToDisplayLimit(value);
    }

    return value;
  }

  /// Format expression for display
  static String formatExpression(String expression) {
    if (expression.isEmpty) {
      return '';
    }

    // Truncate if exceeds expression limit
    if (DisplayLimits.exceedsExpressionLimit(expression)) {
      final maxLength = DisplayLimits.maxExpressionLength;
      return expression.substring(0, maxLength - 3) + '...';
    }

    return expression;
  }

  /// Format number with decimal places
  static String formatNumber(String number, {int maxDecimals = 10}) {
    if (!number.contains('.')) {
      return number;
    }

    // Split into integer and decimal parts
    final parts = number.split('.');
    final integer = parts[0];
    String decimal = parts[1];

    // Truncate decimal places if needed
    if (decimal.length > maxDecimals) {
      decimal = decimal.substring(0, maxDecimals);
    }

    // Remove trailing zeros
    decimal = decimal.replaceAll(RegExp(r'0+$'), '');
    if (decimal.isEmpty) {
      return integer;
    }

    return '$integer.$decimal';
  }

  /// Format scientific notation
  static String formatScientificNotation(String value) {
    // This is a placeholder for future implementation
    // Actual scientific notation formatting would depend on the value
    return value;
  }

  /// Format error message
  static String formatError(String error) {
    if (error.isEmpty) {
      return 'Error';
    }

    // Capitalize first letter
    return error[0].toUpperCase() + error.substring(1);
  }

  /// Format history item for display
  static String formatHistoryItem({
    required String expression,
    required String result,
    bool showExpression = true,
    bool showResult = true,
  }) {
    final buffer = StringBuffer();

    if (showExpression) {
      buffer.write(formatExpression(expression));
    }

    if (showExpression && showResult) {
      buffer.write(' = ');
    }

    if (showResult) {
      buffer.write(formatDisplay(result));
    }

    return buffer.toString();
  }

  /// Format memory value for display
  static String formatMemoryValue(String value) {
    return formatDisplay(value);
  }

  /// Format percentage display
  static String formatPercentage(String value) {
    // This is a placeholder for future implementation
    return '$value%';
  }

  /// Private constructor to prevent instantiation
  InputFormatter._();
}
