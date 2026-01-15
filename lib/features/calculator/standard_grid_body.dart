import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/calc_button.dart';
import '../../shared/theme/theme_provider.dart';
import '../../shared/navigation/navigation_provider.dart';
import '../calculator/calculator_provider.dart';
import '../../l10n/l10n.dart';
import 'display_panel.dart';

/// Standard calculator complete body using grid layout
/// 4 columns × 9 rows
///
/// Grid structure:
/// - Row 0: Header (spans all 4 columns)
/// - Row 1: Display (spans all 4 columns)
/// - Row 2: Memory buttons (MC, MR, M+, M-, MS) - spans all 4 columns
/// - Row 3-8: Button rows
class StandardGridBody extends ConsumerWidget {
  /// Callback when hamburger menu button is pressed
  final VoidCallback? onMenuPressed;

  const StandardGridBody({super.key, this.onMenuPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calculator = ref.read(calculatorProvider.notifier);
    final theme = ref.watch(calculatorThemeProvider);
    final showHistoryPanel = ref.watch(showHistoryPanelProvider);
    final navState = ref.watch(navigationProvider);
    final memoryCount = ref.watch(calculatorProvider).memoryCount;

    return LayoutGrid(
      // 4 equal columns
      columnSizes: [1.fr, 1.fr, 1.fr, 1.fr],

      // 9 rows with different heights
      rowSizes: [
        48.px,   // Row 0: Header
        2.fr,    // Row 1: Display
        40.px,   // Row 2: Memory buttons
        1.fr,    // Row 3: Clear row (%, CE, C, ⌫)
        1.fr,    // Row 4: Function row (1/x, x², √x, ÷)
        1.fr,    // Row 5: Number row (7, 8, 9, ×)
        1.fr,    // Row 6: Number row (4, 5, 6, -)
        1.fr,    // Row 7: Number row (1, 2, 3, +)
        1.fr,    // Row 8: Last row (±, 0, ., =)
      ],

      // Add gaps between columns and rows
      columnGap: 0,
      rowGap: 0,

      children: [
        // Row 0: Header (spans all 4 columns)
        _buildHeader(context, ref, theme, navState, showHistoryPanel, onMenuPressed)
            .withGridPlacement(columnStart: 0, rowStart: 0, columnSpan: 4, rowSpan: 1),

        // Row 1: Display (spans all 4 columns)
        const DisplayPanel()
            .withGridPlacement(columnStart: 0, rowStart: 1, columnSpan: 4, rowSpan: 1),

        // Row 2: Memory buttons (spans all 4 columns, uses Row inside)
        // When history panel is visible, add 'M' button at the end
        (Container(
          color: theme.background,
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              Expanded(
                child: CalcButton(
                  text: 'MC',
                  type: CalcButtonType.memory,
                  onPressed: calculator.memoryClear,
                  isDisabled: memoryCount == 0,
                ),
              ),
              Expanded(
                child: CalcButton(
                  text: 'MR',
                  type: CalcButtonType.memory,
                  onPressed: calculator.memoryRecall,
                  isDisabled: memoryCount == 0,
                ),
              ),
              Expanded(
                child: CalcButton(
                  text: 'M+',
                  type: CalcButtonType.memory,
                  onPressed: calculator.memoryAdd,
                ),
              ),
              Expanded(
                child: CalcButton(
                  text: 'M-',
                  type: CalcButtonType.memory,
                  onPressed: calculator.memorySubtract,
                ),
              ),
              Expanded(
                child: CalcButton(
                  text: 'MS',
                  type: CalcButtonType.memory,
                  onPressed: calculator.memoryStore,
                ),
              ),
              // Add M button when history panel is hidden (no right panel)
              if (!showHistoryPanel)
                Expanded(
                  child: CalcButton(
                    text: 'M',
                    type: CalcButtonType.memory,
                    onPressed: calculator.memoryRecall,
                    isDisabled: memoryCount == 0,
                  ),
                ),
            ],
          ),
        )).withGridPlacement(columnStart: 0, rowStart: 2, columnSpan: 4, rowSpan: 1),

        // Row 3: Clear row (%, CE, C, ⌫)
        _buildButton(theme, calculator, icon: CalculatorIcons.percent, type: CalcButtonType.operator, onPressed: calculator.percent)
            .withGridPlacement(columnStart: 0, rowStart: 3),
        _buildButton(theme, calculator, text: 'CE', type: CalcButtonType.operator, onPressed: calculator.clearEntry)
            .withGridPlacement(columnStart: 1, rowStart: 3),
        _buildButton(theme, calculator, text: 'C', type: CalcButtonType.operator, onPressed: calculator.clear)
            .withGridPlacement(columnStart: 2, rowStart: 3),
        _buildButton(theme, calculator, icon: CalculatorIcons.backspace, type: CalcButtonType.operator, onPressed: calculator.backspace)
            .withGridPlacement(columnStart: 3, rowStart: 3),

        // Row 4: Function row (1/x, x², √x, ÷)
        _buildButton(theme, calculator, icon: CalculatorIcons.reciprocal, type: CalcButtonType.operator, onPressed: calculator.reciprocal)
            .withGridPlacement(columnStart: 0, rowStart: 4),
        _buildButton(theme, calculator, icon: CalculatorIcons.square, type: CalcButtonType.operator, onPressed: calculator.square)
            .withGridPlacement(columnStart: 1, rowStart: 4),
        _buildButton(theme, calculator, icon: CalculatorIcons.squareRoot, type: CalcButtonType.operator, onPressed: calculator.squareRoot)
            .withGridPlacement(columnStart: 2, rowStart: 4),
        _buildButton(theme, calculator, icon: CalculatorIcons.divide, type: CalcButtonType.operator, onPressed: calculator.divide)
            .withGridPlacement(columnStart: 3, rowStart: 4),

        // Row 5: Number row (7, 8, 9, ×)
        _buildButton(theme, calculator, text: '7', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(7))
            .withGridPlacement(columnStart: 0, rowStart: 5),
        _buildButton(theme, calculator, text: '8', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(8))
            .withGridPlacement(columnStart: 1, rowStart: 5),
        _buildButton(theme, calculator, text: '9', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(9))
            .withGridPlacement(columnStart: 2, rowStart: 5),
        _buildButton(theme, calculator, icon: CalculatorIcons.multiply, type: CalcButtonType.operator, onPressed: calculator.multiply)
            .withGridPlacement(columnStart: 3, rowStart: 5),

        // Row 6: Number row (4, 5, 6, -)
        _buildButton(theme, calculator, text: '4', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(4))
            .withGridPlacement(columnStart: 0, rowStart: 6),
        _buildButton(theme, calculator, text: '5', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(5))
            .withGridPlacement(columnStart: 1, rowStart: 6),
        _buildButton(theme, calculator, text: '6', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(6))
            .withGridPlacement(columnStart: 2, rowStart: 6),
        _buildButton(theme, calculator, icon: CalculatorIcons.minus, type: CalcButtonType.operator, onPressed: calculator.subtract)
            .withGridPlacement(columnStart: 3, rowStart: 6),

        // Row 7: Number row (1, 2, 3, +)
        _buildButton(theme, calculator, text: '1', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(1))
            .withGridPlacement(columnStart: 0, rowStart: 7),
        _buildButton(theme, calculator, text: '2', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(2))
            .withGridPlacement(columnStart: 1, rowStart: 7),
        _buildButton(theme, calculator, text: '3', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(3))
            .withGridPlacement(columnStart: 2, rowStart: 7),
        _buildButton(theme, calculator, icon: CalculatorIcons.plus, type: CalcButtonType.operator, onPressed: calculator.add)
            .withGridPlacement(columnStart: 3, rowStart: 7),

        // Row 8: Last row (±, 0, ., =)
        _buildButton(theme, calculator, icon: CalculatorIcons.negate, type: CalcButtonType.number, onPressed: calculator.inputNegate)
            .withGridPlacement(columnStart: 0, rowStart: 8),
        _buildButton(theme, calculator, text: '0', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(0))
            .withGridPlacement(columnStart: 1, rowStart: 8),
        _buildButton(theme, calculator, text: '.', type: CalcButtonType.number, onPressed: calculator.inputDecimal)
            .withGridPlacement(columnStart: 2, rowStart: 8),
        _buildButton(theme, calculator, icon: CalculatorIcons.equals, type: CalcButtonType.emphasized, onPressed: calculator.equals)
            .withGridPlacement(columnStart: 3, rowStart: 8),
      ],
    );
  }

  /// Build header widget
  Widget _buildHeader(
    BuildContext context,
    WidgetRef ref,
    CalculatorTheme theme,
    navState,
    bool showHistoryPanel,
    VoidCallback? onMenuPressed,
  ) {
    return Container(
      height: 48,
      color: theme.background,
      child: Row(
        children: [
          // Hamburger button and mode name
          _buildHamburgerButton(context, ref, theme, onMenuPressed),

          const Spacer(),

          // History button (only when panel is hidden)
          if (!showHistoryPanel)
            _HeaderButton(
              icon: Icons.history,
              theme: theme,
              onPressed: () {
                // TODO: Show bottom history sheet
              },
            ),

          // Theme toggle button
          _HeaderButton(
            icon: theme.brightness == Brightness.dark
                ? Icons.light_mode_outlined
                : Icons.dark_mode_outlined,
            theme: theme,
            onPressed: () {
              ref.read(themeProvider.notifier).toggleTheme();
            },
          ),
        ],
      ),
    );
  }

  /// Build hamburger button with mode name
  Widget _buildHamburgerButton(
    BuildContext context,
    WidgetRef ref,
    CalculatorTheme theme,
    VoidCallback? onMenuPressed,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onMenuPressed,
        child: Container(
          height: 48,
          padding: const EdgeInsets.only(left: 8, right: 16),
          color: theme.background,
          child: Row(
            children: [
              // Hamburger button
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: Icon(
                  Icons.menu,
                  color: theme.textPrimary,
                  size: 20,
                ),
              ),

              // Mode name
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  _getModeDisplayName(context),
                  style: TextStyle(
                    color: theme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Get mode display name
  String _getModeDisplayName(BuildContext context) {
    final l10n = context.l10n;
    // Standard mode
    return l10n.standardMode;
  }

  /// Helper to build a CalcButton
  Widget _buildButton(
    CalculatorTheme theme,
    CalculatorNotifier calculator, {
    String? text,
    IconData? icon,
    CalcButtonType type = CalcButtonType.number,
    VoidCallback? onPressed,
  }) {
    // Return CalcButton directly - it already has Expanded and Padding internally
    // Do not wrap in Container as it will cause Expanded to be placed incorrectly
    return CalcButton(
      text: text,
      icon: icon,
      type: type,
      onPressed: onPressed,
    );
  }
}

/// Header button widget
class _HeaderButton extends StatefulWidget {
  final IconData icon;
  final dynamic theme;
  final VoidCallback onPressed;

  const _HeaderButton({
    required this.icon,
    required this.theme,
    required this.onPressed,
  });

  @override
  State<_HeaderButton> createState() => _HeaderButtonState();
}

class _HeaderButtonState extends State<_HeaderButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: _isHovered
                ? widget.theme.textPrimary.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(widget.icon, color: widget.theme.textSecondary, size: 18),
        ),
      ),
    );
  }
}
