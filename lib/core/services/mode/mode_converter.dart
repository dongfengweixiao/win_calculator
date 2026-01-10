import '../../services/calculator_service.dart';
import '../../domain/entities/view_mode.dart';
import '../../domain/entities/calculator_mode.dart';

/// Mode conversion service
/// Handles conversion between ViewMode and CalculatorMode
class ModeConverter {
  /// Convert ViewMode to CalculatorMode
  static CalculatorMode viewToCalculator(ViewMode viewMode) {
    switch (viewMode) {
      case ViewMode.standard:
        return CalculatorMode.standard;
      case ViewMode.scientific:
        return CalculatorMode.scientific;
      case ViewMode.programmer:
        return CalculatorMode.programmer;
    }
  }

  /// Convert CalculatorMode to ViewMode
  static ViewMode calculatorToView(CalculatorMode calcMode) {
    switch (calcMode) {
      case CalculatorMode.standard:
        return ViewMode.standard;
      case CalculatorMode.scientific:
        return ViewMode.scientific;
      case CalculatorMode.programmer:
        return ViewMode.programmer;
    }
  }

  /// Get display name for ViewMode
  static String getViewModeDisplayName(ViewMode mode) {
    return mode.displayName;
  }

  /// Get display name for CalculatorMode
  static String getCalculatorModeDisplayName(CalculatorMode mode) {
    return mode.displayName;
  }

  /// Check if two modes are compatible
  static bool areModesCompatible(ViewMode viewMode, CalculatorMode calcMode) {
    return viewToCalculator(viewMode) == calcMode;
  }

  /// Private constructor to prevent instantiation
  ModeConverter._();
}
