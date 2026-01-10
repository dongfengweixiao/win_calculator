import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/calculator/calculator_provider.dart';

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
  /// Note: Current implementation clears all history. Individual item deletion
  /// would require additional FFI methods.
  static void deleteHistoryItem(
    WidgetRef ref,
    int index,
  ) {
    // Clear all history for now
    // Individual deletion would need CMD_DELETE_HISTORY_ITEM or similar
    clearAllHistory(ref);
  }

  /// Delete memory item at index
  static void deleteMemoryItem(
    WidgetRef ref,
    int index,
  ) {
    // Use the memoryClearAt method from calculator provider
    ref.read(calculatorProvider.notifier).memoryClearAt(index);
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
    ref.read(calculatorProvider.notifier).clearHistory();
  }

  /// Clear all memory
  static void clearAllMemory(WidgetRef ref) {
    ref.read(calculatorProvider.notifier).memoryClear();
  }

  /// Private constructor to prevent instantiation
  HistoryDeleter._();
}
