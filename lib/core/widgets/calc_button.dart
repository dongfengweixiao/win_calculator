import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../theme/app_font_sizes.dart';
import '../theme/app_dimensions.dart';
import '../../shared/theme/theme_provider.dart';

/// Unified calculator button widget for all calculator modes
///
/// Supports text and icon display, handles hover/pressed states,
/// and applies theme-based styling based on button type.
class CalcButton extends ConsumerStatefulWidget {
  /// Text content (for buttons without icons)
  final String? text;

  /// Icon data (for buttons with calculator font icons)
  final IconData? icon;

  /// Button type for styling (number, operator, function, emphasized, memory)
  final CalcButtonType type;

  /// Callback when button is pressed
  final VoidCallback? onPressed;

  /// Whether the button is disabled
  final bool isDisabled;

  /// Custom font size (optional, defaults based on button type)
  final double? fontSize;

  /// Flex value for layout
  final int flex;

  const CalcButton({
    super.key,
    this.text,
    this.icon,
    this.type = CalcButtonType.number,
    this.onPressed,
    this.isDisabled = false,
    this.fontSize,
    this.flex = 1,
  }) : assert(
         text != null || icon != null,
         'Either text or icon must be provided',
       );

  @override
  ConsumerState<CalcButton> createState() => _CalcButtonState();
}

class _CalcButtonState extends ConsumerState<CalcButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  CalcButtonState get _buttonState {
    if (widget.isDisabled || widget.onPressed == null) return CalcButtonState.disabled;
    if (_isPressed) return CalcButtonState.pressed;
    if (_isHovered) return CalcButtonState.hover;
    return CalcButtonState.normal;
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(calculatorThemeProvider);
    final backgroundColor = theme.getButtonBackground(
      widget.type,
      _buttonState,
    );
    final foregroundColor = theme.getButtonForeground(
      widget.type,
      _buttonState,
    );

    // Determine font size based on button type or custom value
    double fontSize = widget.fontSize ?? _getDefaultFontSize(theme);

    // Determine cursor based on disabled state
    final cursor = widget.isDisabled
        ? SystemMouseCursors.forbidden
        : SystemMouseCursors.click;

    return Expanded(
      flex: widget.flex,
      child: Padding(
        padding: const EdgeInsets.all(CalculatorDimensions.buttonMargin),
        child: MouseRegion(
          cursor: cursor,
          onEnter: widget.isDisabled
              ? null
              : (_) => setState(() => _isHovered = true),
          onExit: widget.isDisabled
              ? null
              : (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTapDown: widget.isDisabled
                ? null
                : (_) => setState(() => _isPressed = true),
            onTapUp: widget.isDisabled
                ? null
                : (_) {
                    setState(() => _isPressed = false);
                    widget.onPressed?.call();
                  },
            onTapCancel: widget.isDisabled
                ? null
                : () => setState(() => _isPressed = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(
                  CalculatorDimensions.controlCornerRadius,
                ),
              ),
              constraints: const BoxConstraints(
                minWidth: CalculatorDimensions.buttonMinWidth,
                minHeight: CalculatorDimensions.buttonMinHeight,
              ),
              child: Center(
                child: _buildContent(foregroundColor, fontSize),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(Color foregroundColor, double fontSize) {
    if (widget.icon != null) {
      // Use icon font
      return Text(
        String.fromCharCode(widget.icon!.codePoint),
        style: TextStyle(
          fontFamily: widget.icon!.fontFamily,
          fontSize: fontSize,
          color: foregroundColor,
        ),
      );
    } else {
      // Use regular text
      return Text(
        widget.text!,
        style: TextStyle(
          color: foregroundColor,
          fontSize: fontSize,
          fontWeight: FontWeight.w400,
        ),
      );
    }
  }

  double _getDefaultFontSize(CalculatorTheme theme) {
    switch (widget.type) {
      case CalcButtonType.number:
        return CalculatorFontSizes.numeric24;
      case CalcButtonType.operator:
        return CalculatorFontSizes.numeric24;
      case CalcButtonType.function:
        return CalculatorFontSizes.numeric18;
      case CalcButtonType.emphasized:
        return CalculatorFontSizes.numeric24;
      case CalcButtonType.memory:
        return CalculatorFontSizes.numeric14;
    }
  }
}
