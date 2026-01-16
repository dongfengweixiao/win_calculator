import 'package:flutter/material.dart';
import '../../core/theme/app_font_sizes.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/unit_icons.dart';
import '../../l10n/app_localizations.dart';

/// Unit dropdown widget for converter
/// Styled like scientific calculator's trig button
class ConverterUnitDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?> onChanged;
  final CalculatorTheme theme;

  const ConverterUnitDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: theme.buttonSubtleDefault,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items: items,
          onChanged: onChanged,
          dropdownColor: theme.surface,
          icon: Icon(
            Icons.arrow_drop_down,
            color: theme.textPrimary,
            size: 20,
          ),
          style: TextStyle(
            color: theme.textPrimary,
            fontSize: 18,
          ),
          selectedItemBuilder: (context) {
            return items.map((item) {
              return DropdownMenuItem<String>(
                value: item.value,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontSize: 18,
                    ),
                    child: item.child,
                  ),
                ),
              );
            }).toList();
          },
          iconEnabledColor: theme.textPrimary,
          focusColor: Colors.transparent,
        ),
      ),
    );
  }
}

/// Display/value widget for converter
/// Styled like standard calculator's display panel
class ConverterValueDisplay extends StatelessWidget {
  final String value;
  final CalculatorTheme theme;
  final bool isActive;
  final VoidCallback? onTap;

  const ConverterValueDisplay({
    super.key,
    required this.value,
    required this.theme,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          color: Colors.transparent,
          alignment: Alignment.centerLeft,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                fontSize: CalculatorFontSizes.operatorCaptionExtraLarge,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w300,
                color: theme.textPrimary,
              ),
              maxLines: 1,
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ),
    );
  }
}

/// Suggested values data model
class SuggestedValue {
  final String value;
  final String unit;
  final int unitId;
  final bool isWhimsical;

  const SuggestedValue({
    required this.value,
    required this.unit,
    required this.unitId,
    this.isWhimsical = false,
  });

  /// Get the display text with icon if whimsical
  String get displayText {
    if (isWhimsical) {
      final icon = UnitIcons.getIcon(unitId);
      if (icon.isNotEmpty) {
        return '$icon $value$unit';
      }
    }
    return '$value$unit';
  }
}

/// Converter display panel
/// Used by volume converter and other converter pages
/// Layout:
/// Row 1: value1 display
/// Row 2: unit1 dropdown
/// Row 3: value2 display
/// Row 4: unit2 dropdown
/// Row 5: Suggested values (two lines)
class ConverterDisplayPanel extends StatelessWidget {
  final String value1;
  final String value2;
  final String unit1;
  final String unit2;
  final List<DropdownMenuItem<String>> unitItems1;
  final List<DropdownMenuItem<String>> unitItems2;
  final ValueChanged<String?> onUnit1Changed;
  final ValueChanged<String?> onUnit2Changed;
  final bool isValue1Active; // Track which input field is active
  final VoidCallback? onValue1Activated;
  final VoidCallback? onValue2Activated;
  final List<SuggestedValue> nonWhimsicalSuggestions;
  final SuggestedValue? whimsicalSuggestion;

  const ConverterDisplayPanel({
    super.key,
    required this.value1,
    required this.value2,
    required this.unit1,
    required this.unit2,
    required this.unitItems1,
    required this.unitItems2,
    required this.onUnit1Changed,
    required this.onUnit2Changed,
    required this.onValue1Activated,
    required this.onValue2Activated,
    this.isValue1Active = true,
    this.nonWhimsicalSuggestions = const [],
    this.whimsicalSuggestion,
  });

  @override
  Widget build(BuildContext context) {
    final theme = CalculatorThemeProvider.of(context);
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row 1: value1 display
        ConverterValueDisplay(
          value: value1,
          theme: theme,
          isActive: isValue1Active,
          onTap: onValue1Activated,
        ),
        const SizedBox(height: 4),

        // Row 2: unit1 dropdown
        ConverterUnitDropdown(
          label: l10n.fromUnit,
          value: unit1,
          items: unitItems1,
          onChanged: onUnit1Changed,
          theme: theme,
        ),
        const SizedBox(height: 8),

        // Row 3: value2 display
        ConverterValueDisplay(
          value: value2,
          theme: theme,
          isActive: !isValue1Active,
          onTap: onValue2Activated,
        ),
        const SizedBox(height: 4),

        // Row 4: unit2 dropdown
        ConverterUnitDropdown(
          label: l10n.toUnit,
          value: unit2,
          items: unitItems2,
          onChanged: onUnit2Changed,
          theme: theme,
        ),
        const SizedBox(height: 8),

        // Row 5: Suggested values (two lines)
        if (nonWhimsicalSuggestions.isNotEmpty || whimsicalSuggestion != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Line 1: "约等于"
              Text(
                '约等于',
                style: TextStyle(
                  color: theme.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              // Line 2: Values and units (two columns)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Column 1: Non-whimsical suggestions (single line with horizontal scroll)
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: nonWhimsicalSuggestions
                            .map((sv) => Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: Text(
                                    sv.displayText,
                                    style: TextStyle(
                                      color: theme.textSecondary,
                                      fontSize: 14,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                  // Column 2: Whimsical suggestion (if exists)
                  if (whimsicalSuggestion != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        whimsicalSuggestion!.displayText,
                        style: TextStyle(
                          color: theme.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}
