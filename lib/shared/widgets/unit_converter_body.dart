import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/theme_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/unit_converter_service.dart';
import '../../core/utils/unit_localization.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/converter_keypad.dart';
import '../widgets/converter_display_panel.dart';

/// Configuration for unit converter
class UnitConverterConfig {
  /// Category ID from the converter engine
  final int categoryId;

  /// Page title localization key
  final String titleKey;

  /// Default unit for field 1
  final String defaultUnit1;

  /// Default unit for field 2
  final String defaultUnit2;

  /// Whether to show sign toggle button (±)
  final bool showSignToggle;

  const UnitConverterConfig({
    required this.categoryId,
    required this.titleKey,
    required this.defaultUnit1,
    required this.defaultUnit2,
    this.showSignToggle = false,
  });
}

/// Generic unit converter page body
///
/// Business logic:
/// - Two-way converter: value1 ↔ value2
/// - Active field determines conversion direction
///   - value1 active: unit1 → unit2
///   - value2 active: unit2 → unit1
/// - Switching activation doesn't recalculate immediately
/// - Next input after switching triggers reset and new conversion
/// - Optionally supports positive/negative values (±)
class UnitConverterBody extends ConsumerStatefulWidget {
  final VoidCallback onMenuPressed;
  final UnitConverterConfig config;

  const UnitConverterBody({
    super.key,
    required this.onMenuPressed,
    required this.config,
  });

  @override
  ConsumerState<UnitConverterBody> createState() => _UnitConverterBodyState();
}

class _UnitConverterBodyState extends ConsumerState<UnitConverterBody> {
  // ===== Core State =====

  /// Which field is currently active (receiving input)
  bool _isValue1Active = true;

  /// Display values for the two fields
  String _value1 = '0';
  String _value2 = '0';

  /// Selected units for the two fields
  late String _selectedUnit1;
  late String _selectedUnit2;

  /// Track whether activation has switched since last input
  bool _hasActivationSwitched = false;

  /// Track whether units have changed since last input
  bool _hasUnitChanged = false;

  /// Suggested values from the converter
  List<Map<String, dynamic>> _suggestedValues = [];

  // ===== Service & Mapping =====

  late final UnitConverterService _converter;
  final Map<String, int> _unitNameToId = {};

  // ===== Lifecycle =====

  @override
  void initState() {
    super.initState();
    _selectedUnit1 = widget.config.defaultUnit1;
    _selectedUnit2 = widget.config.defaultUnit2;
    _initializeConverter();
  }

  @override
  void dispose() {
    _converter.dispose();
    super.dispose();
  }

  /// Initialize the converter service
  void _initializeConverter() {
    _converter = UnitConverterService();
    _converter.initialize(categoryId: widget.config.categoryId);
    _buildUnitMapping();
    _updateConverterUnits();
    _updateDisplayFromEngine();
  }

  /// Build mapping from unit names to engine IDs
  void _buildUnitMapping() {
    final category = _converter.currentCategory;
    if (category == null) return;

    for (final unit in category.units) {
      _unitNameToId[unit.name] = unit.id;
    }
  }

  // ===== Conversion Core =====

  /// Update converter units based on active field
  ///
  /// Conversion direction:
  /// - value1 active: unit1 → unit2 (from=unit1, to=unit2)
  /// - value2 active: unit2 → unit1 (from=unit2, to=unit1)
  void _updateConverterUnits() {
    final unitId1 = _unitNameToId[_selectedUnit1];
    final unitId2 = _unitNameToId[_selectedUnit2];

    if (unitId1 == null || unitId2 == null) return;

    if (_isValue1Active) {
      _converter.setUnits(fromUnitId: unitId1, toUnitId: unitId2);
    } else {
      _converter.setUnits(fromUnitId: unitId2, toUnitId: unitId1);
    }
  }

  /// Update display values from engine
  ///
  /// Reads current values from engine and maps them to UI based on active field.
  void _updateDisplayFromEngine() {
    final fromValue = _converter.getFromValue();
    final toValue = _converter.getToValue();

    setState(() {
      if (_isValue1Active) {
        _value1 = fromValue;
        _value2 = toValue;
      } else {
        _value2 = fromValue;
        _value1 = toValue;
      }
    });
  }

  /// Update suggested values from engine
  void _updateSuggestedValues() {
    setState(() {
      _suggestedValues = _converter.getSuggestedValues();
    });
  }

  // ===== Pending Reset Handling =====

  /// Handle pending reset before new input
  ///
  /// Called before processing new input. Only activation switch triggers reset.
  /// Unit changes don't need reset - engine auto-recalculates.
  void _handlePendingResetIfNeeded() {
    if (!_hasActivationSwitched) return;

    _converter.reset();
    _updateConverterUnits();

    setState(() {
      _hasActivationSwitched = false;
      _hasUnitChanged = false;
    });
  }

  // ===== Input Handlers =====

  /// Handle digit/decimal point input
  void _onNumberPressed(String number) {
    // Handle pending reset (only for activation switch)
    _handlePendingResetIfNeeded();

    // Clear unit change flag - it doesn't affect input
    if (_hasUnitChanged) {
      setState(() {
        _hasUnitChanged = false;
      });
    }

    // Send input to engine
    if (number == '.') {
      _converter.sendDecimal();
    } else {
      final digit = int.tryParse(number);
      if (digit != null && digit >= 0 && digit <= 9) {
        _converter.sendDigit(digit);
      }
    }

    // Read from engine and update UI
    _updateDisplayFromEngine();
    // Update suggested values
    _updateSuggestedValues();
  }

  /// Handle negate (sign toggle)
  void _onNegatePressed() {
    // Handle pending reset (only for activation switch)
    _handlePendingResetIfNeeded();

    // Clear unit change flag - it doesn't affect negate
    if (_hasUnitChanged) {
      setState(() {
        _hasUnitChanged = false;
      });
    }

    // Send negate to engine
    _converter.sendNegate();

    // Read from engine and update UI
    _updateDisplayFromEngine();
    // Update suggested values
    _updateSuggestedValues();
  }

  /// Handle backspace
  void _onBackPressed() {
    // If activation just switched, reset and clear both fields
    if (_hasActivationSwitched) {
      _converter.reset();
      _updateConverterUnits();

      setState(() {
        _hasActivationSwitched = false;
        _hasUnitChanged = false;
      });

      _updateDisplayFromEngine();
      _updateSuggestedValues();
      return;
    }

    // Clear unit change flag - it doesn't affect backspace
    if (_hasUnitChanged) {
      setState(() {
        _hasUnitChanged = false;
      });
    }

    // Perform normal backspace
    _converter.sendBackspace();
    _updateDisplayFromEngine();
    _updateSuggestedValues();
  }

  /// Handle clear
  void _onClearPressed() {
    _converter.sendClear();
    _hasActivationSwitched = false;
    _hasUnitChanged = false;

    // Read '0' from engine and update UI
    _updateDisplayFromEngine();
    _updateSuggestedValues();
  }

  // ===== Unit Change Handlers =====

  /// Handle unit1 change
  void _onUnit1Changed(String? unitName) {
    if (unitName == null) return;

    setState(() {
      _selectedUnit1 = unitName;
      _hasUnitChanged = true;
    });

    _updateConverterUnits();

    // Immediately read from engine and update UI
    _updateDisplayFromEngine();
    _updateSuggestedValues();
  }

  /// Handle unit2 change
  void _onUnit2Changed(String? unitName) {
    if (unitName == null) return;

    setState(() {
      _selectedUnit2 = unitName;
      _hasUnitChanged = true;
    });

    _updateConverterUnits();

    // Immediately read from engine and update UI
    _updateDisplayFromEngine();
    _updateSuggestedValues();
  }

  // ===== Activation Handlers =====

  /// Handle value1 activation
  void _onValue1Activated() {
    // Only process if actually switching from value2
    if (_isValue1Active) return;

    setState(() {
      _hasActivationSwitched = true;
      _isValue1Active = true;
    });

    _updateConverterUnits();
    // Don't update UI - keep current display
  }

  /// Handle value2 activation
  void _onValue2Activated() {
    // Only process if actually switching from value1
    if (!_isValue1Active) return;

    setState(() {
      _hasActivationSwitched = true;
      _isValue1Active = false;
    });

    _updateConverterUnits();
    // Don't update UI - keep current display
  }

  // ===== UI Builders =====

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(calculatorThemeProvider);
    final l10n = AppLocalizations.of(context);

    // Get title from localization using the key
    final title = _getLocalizedTitle(l10n);

    return Scaffold(
      backgroundColor: theme.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideLayout = constraints.maxWidth >= 768;
          return Column(
            children: [
              _buildHeader(theme, title),
              Expanded(
                child: isWideLayout
                    ? _buildWideLayout(theme, l10n)
                    : _buildNarrowLayout(theme, l10n),
              ),
            ],
          );
        },
      ),
    );
  }

  String _getLocalizedTitle(AppLocalizations l10n) {
    // Use the titleKey to get localized title
    switch (widget.config.titleKey) {
      case 'volumeConverterTitle':
        return l10n.volumeConverterTitle;
      case 'temperatureConverterTitle':
        return l10n.temperatureConverterTitle;
      default:
        return widget.config.titleKey;
    }
  }

  Widget _buildHeader(CalculatorTheme theme, String title) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          InkWell(
            onTap: widget.onMenuPressed,
            child: Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              child: Icon(Icons.menu, color: theme.textPrimary, size: 20),
            ),
          ),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: theme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNarrowLayout(CalculatorTheme theme, AppLocalizations l10n) {
    return Column(
      children: [
        _buildConverterSection(theme, l10n),
        const SizedBox(height: 16),
        Expanded(
          child: ConverterKeypad(
            theme: theme,
            onClearEntry: _onClearPressed,
            onDelete: _onBackPressed,
            onNumber: _onNumberPressed,
            onNegate: widget.config.showSignToggle ? _onNegatePressed : null,
            showSignToggle: widget.config.showSignToggle,
          ),
        ),
      ],
    );
  }

  Widget _buildWideLayout(CalculatorTheme theme, AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            child: _buildConverterSection(theme, l10n),
          ),
        ),
        Expanded(
          flex: 1,
          child: ConverterKeypad(
            theme: theme,
            onClearEntry: _onClearPressed,
            onDelete: _onBackPressed,
            onNumber: _onNumberPressed,
            onNegate: widget.config.showSignToggle ? _onNegatePressed : null,
            showSignToggle: widget.config.showSignToggle,
          ),
        ),
      ],
    );
  }

  Widget _buildConverterSection(CalculatorTheme theme, AppLocalizations l10n) {
    final units = _converter.currentCategory?.units ?? [];

    final unitItems1 = units
        .map((u) => DropdownMenuItem<String>(
              value: u.name,
              child: Text(UnitLocalization.getLocalizedUnitName(u.name, l10n)),
            ))
        .toList();

    final unitItems2 = units
        .map((u) => DropdownMenuItem<String>(
              value: u.name,
              child: Text(UnitLocalization.getLocalizedUnitName(u.name, l10n)),
            ))
        .toList();

    // Process suggested values: filter out zeros, separate whimsical/non-whimsical, and sort
    final nonWhimsicalSuggestions = <Map<String, dynamic>>[];
    final whimsicalSuggestions = <Map<String, dynamic>>[];

    for (final sv in _suggestedValues) {
      final valueNum = sv['valueNum'] as double;
      // Skip zero values
      if (valueNum == 0) continue;

      if (sv['isWhimsical'] == true) {
        whimsicalSuggestions.add(sv);
      } else {
        nonWhimsicalSuggestions.add(sv);
      }
    }

    // Sort by deviation from 1 (smaller deviation first)
    nonWhimsicalSuggestions.sort((a, b) {
      final valueNumA = a['valueNum'] as double;
      final valueNumB = b['valueNum'] as double;
      final devA = (valueNumA - 1).abs();
      final devB = (valueNumB - 1).abs();
      return devA.compareTo(devB);
    });

    whimsicalSuggestions.sort((a, b) {
      final valueNumA = a['valueNum'] as double;
      final valueNumB = b['valueNum'] as double;
      final devA = (valueNumA - 1).abs();
      final devB = (valueNumB - 1).abs();
      return devA.compareTo(devB);
    });

    // Convert to SuggestedValue objects with localized unit names
    final nonWhimsicalObjects = nonWhimsicalSuggestions
        .map((sv) => SuggestedValue(
              value: sv['value'] as String,
              unit: UnitLocalization.getLocalizedUnitName(sv['unit'] as String, l10n),
              unitId: sv['unitId'] as int,
              isWhimsical: false,
            ))
        .toList();

    final whimsicalObjects = whimsicalSuggestions
        .map((sv) => SuggestedValue(
              value: sv['value'] as String,
              unit: UnitLocalization.getLocalizedUnitName(sv['unit'] as String, l10n),
              unitId: sv['unitId'] as int,
              isWhimsical: true,
            ))
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ConverterDisplayPanel(
        value1: _value1,
        value2: _value2,
        unit1: _selectedUnit1,
        unit2: _selectedUnit2,
        unitItems1: unitItems1,
        unitItems2: unitItems2,
        onUnit1Changed: _onUnit1Changed,
        onUnit2Changed: _onUnit2Changed,
        onValue1Activated: _onValue1Activated,
        onValue2Activated: _onValue2Activated,
        isValue1Active: _isValue1Active,
        nonWhimsicalSuggestions: nonWhimsicalObjects,
        whimsicalSuggestion: whimsicalObjects.isNotEmpty ? whimsicalObjects.first : null,
      ),
    );
  }
}
