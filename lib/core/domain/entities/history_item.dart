/// History item entity
/// Represents a single calculation history entry with expression and result
class HistoryItem {
  /// The mathematical expression that was calculated
  final String expression;

  /// The result of the calculation
  final String result;

  const HistoryItem({
    required this.expression,
    required this.result,
  });

  /// Create a HistoryItem from a record
  factory HistoryItem.fromRecord(
    ({String expression, String result}) record,
  ) {
    return HistoryItem(
      expression: record.expression,
      result: record.result,
    );
  }

  /// Convert to a record
  ({String expression, String result}) toRecord() {
    return (expression: expression, result: result);
  }

  /// Create a copy with modified fields
  HistoryItem copyWith({
    String? expression,
    String? result,
  }) {
    return HistoryItem(
      expression: expression ?? this.expression,
      result: result ?? this.result,
    );
  }

  /// Format history item for display
  String format({bool showExpression = true, bool showResult = true}) {
    final buffer = StringBuffer();
    if (showExpression) {
      buffer.write(expression);
    }
    if (showExpression && showResult) {
      buffer.write(' = ');
    }
    if (showResult) {
      buffer.write(result);
    }
    return buffer.toString();
  }

  /// Get the expression only
  String get expressionOnly => expression;

  /// Get the result only
  String get resultOnly => result;

  /// Validate history item
  bool get isValid => expression.isNotEmpty && result.isNotEmpty;

  @override
  String toString() => format();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryItem &&
          other.expression == expression &&
          other.result == result;

  @override
  int get hashCode => Object.hash(expression, result);
}
