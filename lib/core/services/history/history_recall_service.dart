import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/history_item.dart';
import '../input/input_validator.dart';

/// History recall service
/// Handles recalling history items into the calculator
class HistoryRecallService {
  /// Recall history item to calculator display
  static String recallHistory(
    List<HistoryItem> items,
    int index,
  ) {
    if (!isValidIndex(items, index)) {
      throw ArgumentError('Invalid history index: $index');
    }

    return items[index].result;
  }

  /// Validate history index
  static bool isValidIndex(List<HistoryItem> items, int index) {
    return InputValidator.isValidHistoryIndex(index, items.length);
  }

  /// Get history item at index
  static HistoryItem? getItemAt(
    List<HistoryItem> items,
    int index,
  ) {
    if (!isValidIndex(items, index)) {
      return null;
    }

    return items[index];
  }

  /// Get most recent history item
  static HistoryItem? getMostRecent(List<HistoryItem> items) {
    if (items.isEmpty) {
      return null;
    }

    return items.first;
  }

  /// Get oldest history item
  static HistoryItem? getOldest(List<HistoryItem> items) {
    if (items.isEmpty) {
      return null;
    }

    return items.last;
  }

  /// Recall history item using calculator service
  static void recallToCalculator(
    WidgetRef ref,
    List<HistoryItem> items,
    int index,
  ) {
    final result = recallHistory(items, index);

    // This will be implemented when we refactor calculator_provider.dart
    // For now, this is a placeholder that shows the pattern
  }

  /// Private constructor to prevent instantiation
  HistoryRecallService._();
}
