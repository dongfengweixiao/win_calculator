import 'package:flutter_riverpod/flutter_riverpod.dart';

/// History panel tab enum
enum HistoryPanelTab { history, memory }

/// Delete type enum
enum DeleteType { history, memory }

/// History deleter service
/// Handles deletion of history and memory items
class HistoryDeleter {
  /// Determine delete type based on current tab
  static DeleteType determineDeleteType(HistoryPanelTab currentTab) {
    switch (currentTab) {
      case HistoryPanelTab.history:
        return DeleteType.history;
      case HistoryPanelTab.memory:
        return DeleteType.memory;
    }
  }

  /// Delete history item at index
  static void deleteHistoryItem(
    WidgetRef ref,
    int index,
  ) {
    // This will be implemented when we refactor history_panel.dart
    // For now, this is a placeholder that shows the pattern
  }

  /// Delete memory item at index
  static void deleteMemoryItem(
    WidgetRef ref,
    int index,
  ) {
    // This will be implemented when we refactor history_panel.dart
    // For now, this is a placeholder that shows the pattern
  }

  /// Delete item based on current tab
  static void deleteItem(
    WidgetRef ref,
    HistoryPanelTab currentTab,
    int index,
  ) {
    final deleteType = determineDeleteType(currentTab);

    switch (deleteType) {
      case DeleteType.history:
        deleteHistoryItem(ref, index);
        break;
      case DeleteType.memory:
        deleteMemoryItem(ref, index);
        break;
    }
  }

  /// Clear all history
  static void clearAllHistory(WidgetRef ref) {
    // This will be implemented when we refactor calculator_provider.dart
  }

  /// Clear all memory
  static void clearAllMemory(WidgetRef ref) {
    // This will be implemented when we refactor calculator_provider.dart
  }

  /// Private constructor to prevent instantiation
  HistoryDeleter._();
}
