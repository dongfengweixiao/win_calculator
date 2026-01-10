import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/calculator_service.dart';
import '../../domain/entities/view_mode.dart';
import 'mode_converter.dart';

/// Mode synchronizer service
/// Handles synchronization between navigation mode and calculator mode
class ModeSynchronizer {
  /// Synchronize navigation mode with calculator mode
  ///
  /// This should be called when the view mode changes to ensure
  /// the calculator's internal mode is updated accordingly
  static void syncModes(
    WidgetRef ref,
    ViewMode viewMode,
  ) {
    // Convert ViewMode to CalculatorMode
    // Note: Mode conversion is available but not currently used
    // This will be implemented after we refactor calculator_provider.dart
    // For now, this is a placeholder
    ModeConverter.viewToCalculator(viewMode);
  }

  /// Synchronize modes with custom handling
  ///
  /// Allows for custom logic when synchronizing modes
  static void syncModesWithCallback(
    WidgetRef ref,
    ViewMode viewMode,
    void Function(CalculatorMode) onModeChange,
  ) {
    final calcMode = ModeConverter.viewToCalculator(viewMode);
    onModeChange(calcMode);
  }

  /// Check if mode synchronization is needed
  static bool needsSync(ViewMode currentViewMode, CalculatorMode currentCalcMode) {
    final expectedCalcMode = ModeConverter.viewToCalculator(currentViewMode);
    return expectedCalcMode != currentCalcMode;
  }

  /// Private constructor to prevent instantiation
  ModeSynchronizer._();
}
