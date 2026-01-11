import 'package:flutter/material.dart';
import '../programmer_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_icons.dart';

/// Bit shift flyout button
/// Displays a button that opens a menu with shift mode options when clicked
class ShiftFlyoutButton extends StatefulWidget {
  final ProgrammerNotifier programmer;
  final CalculatorTheme theme;
  final ShiftMode currentMode;

  const ShiftFlyoutButton({
    super.key,
    required this.programmer,
    required this.theme,
    required this.currentMode,
  });

  @override
  State<ShiftFlyoutButton> createState() => _ShiftFlyoutButtonState();
}

class _ShiftFlyoutButtonState extends State<ShiftFlyoutButton> {
  bool _isHovered = false;

  void _showShiftMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final Offset position = button.localToGlobal(
      Offset.zero,
      ancestor: overlay,
    );

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => ShiftFlyoutMenu(
        programmer: widget.programmer,
        theme: widget.theme,
        position: position,
        buttonSize: button.size,
        currentMode: widget.currentMode,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _isHovered
        ? widget.theme.buttonSubtleHover
        : widget.theme.buttonSubtleDefault;

    return Padding(
      padding: const EdgeInsets.all(1),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: () => _showShiftMenu(context),
          child: Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  String.fromCharCode(CalculatorIcons.shiftButton.codePoint),
                  style: TextStyle(
                    fontFamily: CalculatorIcons.shiftButton.fontFamily,
                    fontSize: 14,
                    color: widget.theme.textPrimary,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '位移位',
                  style: TextStyle(
                    color: widget.theme.textPrimary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  Icons.arrow_drop_down,
                  color: widget.theme.textPrimary,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Bit shift flyout menu
/// Displays radio options for shift mode selection
class ShiftFlyoutMenu extends StatelessWidget {
  final ProgrammerNotifier programmer;
  final CalculatorTheme theme;
  final Offset position;
  final Size buttonSize;
  final ShiftMode currentMode;

  const ShiftFlyoutMenu({
    super.key,
    required this.programmer,
    required this.theme,
    required this.position,
    required this.buttonSize,
    required this.currentMode,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(color: Colors.transparent),
          ),
        ),
        Positioned(
          left: position.dx,
          top: position.dy + buttonSize.height + 4,
          child: Material(
            color: theme.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
            elevation: 8,
            child: Container(
              padding: const EdgeInsets.all(8),
              width: 200,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: ShiftMode.values.map((mode) {
                  return _ShiftModeRadio(
                    mode: mode,
                    isSelected: currentMode == mode,
                    theme: theme,
                    onTap: () {
                      programmer.setShiftMode(mode);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Radio button for shift mode selection
class _ShiftModeRadio extends StatefulWidget {
  final ShiftMode mode;
  final bool isSelected;
  final CalculatorTheme theme;
  final VoidCallback onTap;

  const _ShiftModeRadio({
    required this.mode,
    required this.isSelected,
    required this.theme,
    required this.onTap,
  });

  @override
  State<_ShiftModeRadio> createState() => _ShiftModeRadioState();
}

class _ShiftModeRadioState extends State<_ShiftModeRadio> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    if (widget.isSelected) {
      backgroundColor = widget.theme.accentColor.withValues(alpha: 0.3);
    } else if (_isHovered) {
      backgroundColor = widget.theme.buttonAltHover;
    } else {
      backgroundColor = widget.theme.buttonAltDefault;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          margin: const EdgeInsets.only(bottom: 4),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(4),
            border: widget.isSelected
                ? Border.all(color: widget.theme.accentColor, width: 1)
                : null,
          ),
          child: Row(
            children: [
              // Radio indicator
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.isSelected
                        ? widget.theme.accentColor
                        : widget.theme.textSecondary,
                    width: 2,
                  ),
                ),
                child: widget.isSelected
                    ? Center(
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.theme.accentColor,
                          ),
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              // Mode label
              Text(
                widget.mode.label,
                style: TextStyle(
                  fontSize: 13,
                  color: widget.isSelected
                      ? widget.theme.accentColor
                      : widget.theme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
