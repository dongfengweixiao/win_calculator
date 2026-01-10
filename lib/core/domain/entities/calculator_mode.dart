import '../../services/calculator_service.dart';

/// Extension on CalculatorMode to provide additional functionality
/// CalculatorMode is defined in calculator_service.dart
extension CalculatorModeExtension on CalculatorMode {
  /// Get the display name for the calculator mode
  String get displayName {
    switch (this) {
      case CalculatorMode.standard:
        return '标准';
      case CalculatorMode.scientific:
        return '科学';
      case CalculatorMode.programmer:
        return '程序员';
    }
  }

  /// Check if this is standard mode
  bool get isStandard => this == CalculatorMode.standard;

  /// Check if this is scientific mode
  bool get isScientific => this == CalculatorMode.scientific;

  /// Check if this is programmer mode
  bool get isProgrammer => this == CalculatorMode.programmer;
}
