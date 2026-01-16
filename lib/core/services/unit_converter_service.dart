import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:wincalc_engine/wincalc_engine.dart';

/// Unit data model from the native converter
class ConverterUnit {
  final int id;
  final String name;
  final String abbreviation;
  final bool isWhimsical;

  const ConverterUnit({
    required this.id,
    required this.name,
    required this.abbreviation,
    this.isWhimsical = false,
  });

  @override
  String toString() => '$name ($abbreviation)';
}

/// Category data model from the native converter
class ConverterCategory {
  final int id;
  final String name;
  final List<ConverterUnit> units;

  const ConverterCategory({
    required this.id,
    required this.name,
    required this.units,
  });
}

/// Simple unit converter service - follows Microsoft Calculator architecture
class UnitConverterService {
  Pointer<UnitConverterInstance>? _converter;
  bool _isInitialized = false;

  /// Current category
  ConverterCategory? _currentCategory;

  bool _switchedActive = false;

  ConverterUnit? _fromType;
  ConverterUnit? _toType;

  /// Display values
  String _currentDisplay = '0';
  String _returnDisplay = '0';

  /// Whether the converter is initialized
  bool get isInitialized => _isInitialized;

  /// Current category
  ConverterCategory? get currentCategory => _currentCategory;

  /// Current from unit
  ConverterUnit? get fromUnit => _fromType;

  /// Current to unit
  ConverterUnit? get toUnit => _toType;

  /// Initialize the converter with a specific category
  void initialize({int categoryId = 11}) {
    if (_isInitialized) {
      dispose();
    }
    _converter = unit_converter_create();
    _isInitialized = true;
    _switchedActive = false;
    _setCategory(categoryId);
  }

  /// Dispose the converter
  void dispose() {
    if (_isInitialized && _converter != null) {
      unit_converter_destroy(_converter!);
      _converter = null;
      _isInitialized = false;
      _currentCategory = null;
      _fromType = null;
      _toType = null;
      _switchedActive = false;
    }
  }

  /// Get all available categories
  List<ConverterCategory> getAllCategories() {
    if (!_isInitialized) {
      throw StateError('UnitConverterService not initialized');
    }

    final categories = <ConverterCategory>[];
    final categoryCount = unit_converter_get_category_count(_converter!);

    for (int i = 0; i < categoryCount; i++) {
      final nameBuffer = calloc<Char>(256);
      try {
        final length = unit_converter_get_category_name(
          _converter!,
          i,
          nameBuffer,
          256,
        );
        final name = nameBuffer.cast<Utf8>().toDartString(length: length);
        final id = unit_converter_get_category_id(_converter!, i);

        // Temporarily set category to get units
        final currentCat = unit_converter_get_current_category(_converter!);
        unit_converter_set_category(_converter!, id);

        // Get units for this category
        final units = _getUnitsForCategory();

        // Restore previous category
        if (currentCat >= 0) {
          unit_converter_set_category(_converter!, currentCat);
        }

        categories.add(ConverterCategory(
          id: id,
          name: name,
          units: units,
        ));
      } finally {
        calloc.free(nameBuffer);
      }
    }

    return categories;
  }

  /// Set the current category
  void _setCategory(int categoryId) {
    if (!_isInitialized) {
      throw StateError('UnitConverterService not initialized');
    }

    unit_converter_set_category(_converter!, categoryId);
    _currentCategory = ConverterCategory(
      id: categoryId,
      name: _getCategoryName(categoryId),
      units: _getUnitsForCategory(),
    );

    // Set default units (first two units)
    if (_currentCategory!.units.isNotEmpty) {
      _fromType = _currentCategory!.units[0];
      _toType = _currentCategory!.units.length > 1
          ? _currentCategory!.units[1]
          : _currentCategory!.units[0];

      unit_converter_set_from_unit(_converter!, _fromType!.id);
      unit_converter_set_to_unit(_converter!, _toType!.id);
    }
  }

  /// Get category name by ID
  String _getCategoryName(int categoryId) {
    final nameBuffer = calloc<Char>(256);
    try {
      // Find category by ID
      final categoryCount = unit_converter_get_category_count(_converter!);
      for (int i = 0; i < categoryCount; i++) {
        if (unit_converter_get_category_id(_converter!, i) == categoryId) {
          final length = unit_converter_get_category_name(
            _converter!,
            i,
            nameBuffer,
            256,
          );
          return nameBuffer.cast<Utf8>().toDartString(length: length);
        }
      }
      return 'Unknown';
    } finally {
      calloc.free(nameBuffer);
    }
  }

  /// Get all units for the current category (excluding whimsical units)
  List<ConverterUnit> _getUnitsForCategory() {
    final units = <ConverterUnit>[];
    final unitCount = unit_converter_get_unit_count(_converter!);

    for (int i = 0; i < unitCount; i++) {
      final nameBuffer = calloc<Char>(256);
      final abbrBuffer = calloc<Char>(64);

      try {
        final nameLength = unit_converter_get_unit_name(
          _converter!,
          i,
          nameBuffer,
          256,
        );
        final abbrLength = unit_converter_get_unit_abbreviation(
          _converter!,
          i,
          abbrBuffer,
          64,
        );
        final id = unit_converter_get_unit_id(_converter!, i);

        // Check if this unit is whimsical (e.g., fun/humorous units)
        // Returns 1 if whimsical, 0 if not
        final isWhimsicalInt = unit_converter_is_unit_whimsical(_converter!, i);
        final isWhimsical = isWhimsicalInt != 0;

        // Skip whimsical units - they shouldn't appear in dropdown menus
        if (isWhimsical) {
          continue;
        }

        units.add(ConverterUnit(
          id: id,
          name: nameBuffer.cast<Utf8>().toDartString(length: nameLength),
          abbreviation: abbrBuffer.cast<Utf8>().toDartString(length: abbrLength),
          isWhimsical: isWhimsical,
        ));
      } finally {
        calloc.free(nameBuffer);
        calloc.free(abbrBuffer);
      }
    }

    return units;
  }

  /// Set the current unit selections
  void setUnits({required int fromUnitId, required int toUnitId}) {
    if (!_isInitialized) return;

    final category = _currentCategory;
    if (category == null) return;

    _fromType = category.units.firstWhere((u) => u.id == fromUnitId);
    _toType = category.units.firstWhere((u) => u.id == toUnitId);

    unit_converter_set_from_unit(_converter!, fromUnitId);
    unit_converter_set_to_unit(_converter!, toUnitId);

    // Read updated values after changing units
    _readCurrentValues();
  }

  /// Switch active field (when user clicks the other input)
  void switchActive(String newValue) {
    if (!_isInitialized) return;

    // Use native swap function to swap units in the converter
    unit_converter_swap_units(_converter!);

    // Swap our internal unit references
    final temp = _fromType;
    _fromType = _toType;
    _toType = temp;

    // Swap the display values (the converted value becomes the input value)
    // If user typed "1" L and got "1000" mL, after clicking mL field:
    // - fromType becomes Milliliters
    // - toType becomes Liters
    // - _currentDisplay should become "1000" (the previous result)
    // - _returnDisplay should become "1" (will be recalculated on next input)

    // Actually, looking at microsoft/calculator, the swap just marks that we've switched
    // and the next digit input will clear and start fresh
    // So we should keep _currentDisplay as-is (what user will edit)
    // And use newValue (which is the current converted value) for display purposes only

    // Mark as switched - next digit will clear the converter
    _switchedActive = true;
  }

  /// Send a digit command to the converter
  void sendDigit(int digit) {
    if (!_isInitialized) return;

    // Similar to Microsoft Calculator's SendCommand
    if (digit >= 0 && digit <= 9) {
      if (_switchedActive) {
        // If we're in switched mode, clear everything first
        _switchedActive = false;
        unit_converter_send_command(_converter!, UNIT_CMD_CLEAR);
      }

      // Send the digit command to the native converter
      unit_converter_send_command(_converter!, digit);

      // Read the updated values from the native converter
      final fromBuffer = calloc<Char>(256);
      final toBuffer = calloc<Char>(256);
      try {
        final fromLength = unit_converter_get_from_value(_converter!, fromBuffer, 256);
        final toLength = unit_converter_get_to_value(_converter!, toBuffer, 256);

        _currentDisplay = fromLength > 0
            ? fromBuffer.cast<Utf8>().toDartString(length: fromLength)
            : '0';
        _returnDisplay = toLength > 0
            ? toBuffer.cast<Utf8>().toDartString(length: toLength)
            : '0';
      } finally {
        calloc.free(fromBuffer);
        calloc.free(toBuffer);
      }
    }
  }

  /// Send a decimal point command
  void sendDecimal() {
    if (!_isInitialized) return;

    unit_converter_send_command(_converter!, UNIT_CMD_DECIMAL);

    // Read updated values
    _readCurrentValues();
  }

  /// Send a negate command
  void sendNegate() {
    if (!_isInitialized) return;

    unit_converter_send_command(_converter!, UNIT_CMD_NEGATE);

    // Read updated values
    _readCurrentValues();
  }

  /// Send a backspace command
  void sendBackspace() {
    if (!_isInitialized) return;

    unit_converter_send_command(_converter!, UNIT_CMD_BACKSPACE);

    // Read updated values
    _readCurrentValues();
  }

  /// Send a clear command
  void sendClear() {
    if (!_isInitialized) return;

    unit_converter_send_command(_converter!, UNIT_CMD_CLEAR);
    _switchedActive = false;

    // Read updated values
    _readCurrentValues();
  }

  /// Read current values from the native converter
  void _readCurrentValues() {
    final fromBuffer = calloc<Char>(256);
    final toBuffer = calloc<Char>(256);
    try {
      final fromLength = unit_converter_get_from_value(_converter!, fromBuffer, 256);
      final toLength = unit_converter_get_to_value(_converter!, toBuffer, 256);

      _currentDisplay = fromLength > 0
          ? fromBuffer.cast<Utf8>().toDartString(length: fromLength)
          : '0';
      _returnDisplay = toLength > 0
          ? toBuffer.cast<Utf8>().toDartString(length: toLength)
          : '0';
    } finally {
      calloc.free(fromBuffer);
      calloc.free(toBuffer);
    }
  }

  /// Get the current from value (what user is typing)
  String getFromValue() {
    if (!_isInitialized) return '0';
    return _currentDisplay;
  }

  /// Get the current to value (conversion result)
  String getToValue() {
    if (!_isInitialized) return '0';
    return _returnDisplay;
  }

  /// Reset the converter
  void reset() {
    if (!_isInitialized) return;

    unit_converter_reset(_converter!);
    _switchedActive = false;
    _currentDisplay = '0';
    _returnDisplay = '0';
  }

  /// Get suggested values from the converter
  /// Returns a list of maps containing 'value', 'unit', 'unitId', and 'isWhimsical' for each suggestion
  List<Map<String, dynamic>> getSuggestedValues() {
    if (!_isInitialized) return [];

    final suggestions = <Map<String, dynamic>>[];
    final count = unit_converter_get_suggested_count(_converter!);

    for (int i = 0; i < count; i++) {
      final valueBuffer = calloc<Char>(256);
      final unitBuffer = calloc<Char>(256);

      try {
        // result is the unitId, not length!
        final unitId = unit_converter_get_suggested_value(
          _converter!,
          i,
          valueBuffer,
          256,
          unitBuffer,
          256,
        );

        // Check for error codes (negative values)
        if (unitId < 0) {
          continue;
        }

        // Strings are null-terminated, just read them directly
        final value = valueBuffer.cast<Utf8>().toDartString();
        final unit = unitBuffer.cast<Utf8>().toDartString();

        // Parse the value as double to check if it's zero
        final valueNum = double.tryParse(value) ?? 0.0;

        // Check if this unit is whimsical using UnitIcons
        final isWhimsical = _isUnitWhimsical(unitId);

        suggestions.add({
          'value': value,
          'valueNum': valueNum,
          'unit': unit,
          'unitId': unitId,
          'isWhimsical': isWhimsical,
        });
      } catch (e) {
        // Skip this suggestion if there's any error
        continue;
      } finally {
        calloc.free(valueBuffer);
        calloc.free(unitBuffer);
      }
    }

    return suggestions;
  }

  /// Check if a unit is whimsical based on its ID
  bool _isUnitWhimsical(int unitId) {
    // Volume whimsical unit IDs from UnitIcons
    const whimsicalUnitIds = {
      1220, // CoffeeCup (Metric cup)
      1221, // Bathtub
      1222, // SwimmingPool
      // Length whimsical units would be here if needed
      // 129, 130, // Banana, Cake (from engine test)
    };
    return whimsicalUnitIds.contains(unitId);
  }
}
