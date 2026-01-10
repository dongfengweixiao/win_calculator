import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/calculator/calculator_provider.dart';
import '../input/input_validator.dart';

/// History recall service
/// Handles recalling history items into the calculator
class HistoryRecallService {
  /// Validate history index
  static bool isValidIndex(int totalCount, int index) {
    return InputValidator.isValidHistoryIndex(index, totalCount);
  }

  /// Recall history item using calculator provider
  static void recallToCalculator(
    WidgetRef ref,
    int totalCount,
    int index,
  ) {
    if (!isValidIndex(totalCount, index)) {
      return;
    }

    // Use the calculator provider's recallHistory method
    ref.read(calculatorProvider.notifier).recallHistory(index);
  }

  /// Recall memory item at index
  static void recallMemory(
    WidgetRef ref,
    int index,
  ) {
    // Use the calculator provider's memoryRecallAt method
    ref.read(calculatorProvider.notifier).memoryRecallAt(index);
  }

  /// Add to memory item at index
  static void addMemory(
    WidgetRef ref,
    int index,
  ) {
    ref.read(calculatorProvider.notifier).memoryAddAt(index);
  }

  /// Subtract from memory item at index
  static void subtractMemory(
    WidgetRef ref,
    int index,
  ) {
    ref.read(calculatorProvider.notifier).memorySubtractAt(index);
  }

  /// Private constructor to prevent instantiation
  HistoryRecallService._();
}
