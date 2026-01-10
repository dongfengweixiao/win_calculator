import '../../domain/entities/history_item.dart';

/// History formatting service
/// Handles formatting of history and memory items for display
class HistoryFormatter {
  /// Format history item for display
  static String formatHistoryItem(HistoryItem item) {
    return '${item.expression} = ${item.result}';
  }

  /// Format memory value for display
  static String formatMemoryValue(String value) {
    if (value.isEmpty) {
      return '0';
    }
    return value;
  }

  /// Get label for history item index
  static String getHistoryItemLabel(int index) {
    return 'HS${index + 1}';
  }

  /// Get label for memory item index
  static String getMemoryItemLabel(int index) {
    return 'M${index + 1}';
  }

  /// Format expression for display
  static String formatExpression(String expression) {
    if (expression.length > 50) {
      return '${expression.substring(0, 47)}...';
    }
    return expression;
  }

  /// Format result for display
  static String formatResult(String result) {
    if (result.length > 32) {
      return '${result.substring(0, 29)}...';
    }
    return result;
  }

  /// Format history item with custom formatting
  static String formatHistoryItemCustom({
    required HistoryItem item,
    bool showExpression = true,
    bool showResult = true,
    String separator = ' = ',
  }) {
    final buffer = StringBuffer();

    if (showExpression) {
      buffer.write(item.expression);
    }

    if (showExpression && showResult) {
      buffer.write(separator);
    }

    if (showResult) {
      buffer.write(item.result);
    }

    return buffer.toString();
  }

  /// Validate history item
  static bool isValidHistoryItem(HistoryItem item) {
    return item.expression.isNotEmpty && item.result.isNotEmpty;
  }

  /// Private constructor to prevent instantiation
  HistoryFormatter._();
}
