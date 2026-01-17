import '../../l10n/app_localizations.dart';

/// Mapping from engine unit names to localized display names
/// Used for volume converter and other unit converters
class UnitLocalization {
  /// Get localized display name for a unit
  ///
  /// [unitName] - The English name returned from the engine
  /// [l10n] - The AppLocalizations instance
  ///
  /// Returns the localized name if mapping exists, otherwise returns the original name
  static String getLocalizedUnitName(String unitName, AppLocalizations l10n) {
    return _getUnitName(unitName, l10n) ?? unitName;
  }

  /// Get localized unit name by mapping
  static String? _getUnitName(String unitName, AppLocalizations l10n) {
    switch (unitName) {
      // Volume units
      case 'Cubic meters':
        return l10n.cubicMeters;
      case 'Cubic centimeters':
        return l10n.cubicCentimeters;
      case 'Cubic millimeters':
        return l10n.cubicMillimeters;
      case 'Cubic yards':
        return l10n.cubicYards;
      case 'Liters':
        return l10n.liters;
      case 'Milliliters':
        return l10n.milliliters;
      case 'Cubic feet':
        return l10n.cubicFeet;
      case 'Cubic inches':
        return l10n.cubicInches;
      case 'US gallons':
        return l10n.usGallons;
      case 'UK gallons':
        return l10n.ukGallons;
      case 'US fluid ounces':
        return l10n.usFluidOunces;
      case 'UK fluid ounces':
        return l10n.ukFluidOunces;
      case 'Tablespoons':
        return l10n.tablespoons;
      case 'Teaspoons':
        return l10n.teaspoons;
      case 'US quarts':
        return l10n.usQuarts;
      case 'US pints':
        return l10n.usPints;
      case 'US cups':
        return l10n.usCups;
      case 'Imperial gallons':
        return l10n.imperialGallons;
      case 'Imperial quarts':
        return l10n.imperialQuarts;
      case 'Imperial pints':
        return l10n.imperialPints;
      case 'Imperial tablespoons':
        return l10n.imperialTablespoons;
      case 'Imperial teaspoons':
        return l10n.imperialTeaspoons;
      case 'Imperial fluid ounces':
        return l10n.imperialFluidOunces;
      case 'US tablespoons':
        return l10n.usTablespoons;
      case 'US teaspoons':
        return l10n.usTeaspoons;
      case 'Metric cups':
        return l10n.metricCups;
      // Temperature units
      case 'Celsius':
        return l10n.celsius;
      case 'Fahrenheit':
        return l10n.fahrenheit;
      case 'Kelvin':
        return l10n.kelvin;
      default:
        return null;
    }
  }
}
