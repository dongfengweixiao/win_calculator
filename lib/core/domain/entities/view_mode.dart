/// View mode enum
/// Represents the different calculator modes available in the UI
enum ViewMode {
  /// Standard calculator mode
  standard,

  /// Scientific calculator mode
  scientific,

  /// Programmer calculator mode
  programmer,

  /// Date calculation mode
  dateCalculation,

  /// Volume converter mode
  volumeConverter,
}

/// Extension on ViewMode to provide conversion and display methods
extension ViewModeExtension on ViewMode {
  /// Get the localization key for the view mode
  String get localizationKey {
    switch (this) {
      case ViewMode.standard:
        return 'standardMode';
      case ViewMode.scientific:
        return 'scientificMode';
      case ViewMode.programmer:
        return 'programmerMode';
      case ViewMode.dateCalculation:
        return 'dateCalculationMode';
      case ViewMode.volumeConverter:
        return 'volumeConverterMode';
    }
  }

  /// Get the icon label for the view mode
  String get iconLabel {
    switch (this) {
      case ViewMode.standard:
        return 'STD';
      case ViewMode.scientific:
        return 'SCI';
      case ViewMode.programmer:
        return 'PROG';
      case ViewMode.dateCalculation:
        return 'DATE';
      case ViewMode.volumeConverter:
        return 'VOLUME';
    }
  }
}
