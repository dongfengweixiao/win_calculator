import 'package:example/core/theme/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/calc_button.dart';

/// Button layout configuration for converter keypad
class ConverterKeypadLayout {
  final List<List<ConverterKeyButton?>> buttons;
  final int columnCount;

  const ConverterKeypadLayout({
    required this.buttons,
    required this.columnCount,
  });
}

/// Button definition for converter keypad
class ConverterKeyButton {
  final String? text;
  final IconData? icon;
  final CalcButtonType type;
  final VoidCallback onPressed;

  const ConverterKeyButton({
    this.text,
    this.icon,
    required this.type,
    required this.onPressed,
  });
}

/// A reusable keypad widget for converter pages
/// Uses flutter_layout_grid with CalcButton for consistent styling
class ConverterKeypad extends StatelessWidget {
  /// Button layout configuration
  final ConverterKeypadLayout layout;

  /// Theme for styling
  final CalculatorTheme theme;

  const ConverterKeypad._({
    required this.layout,
    required this.theme,
  });

  /// Create converter keypad
  /// 5 rows × 3 columns layout
  ///
  /// [showSignToggle] - Whether to show sign toggle button (±/-). Defaults to false.
  ///   - When false:
  ///     |     |  CE |  DEL  |
  ///     |  7  |  8  |  9    |
  ///     |  4  |  5  |  6    |
  ///     |  1  |  2  |  3    |
  ///     |     |  0  |  .    |
  ///   - When true:
  ///     |     |  CE |  DEL  |
  ///     |  7  |  8  |  9    |
  ///     |  4  |  5  |  6    |
  ///     |  1  |  2  |  3    |
  ///     |  ±  |  0  |  .    |
  factory ConverterKeypad({
    required CalculatorTheme theme,
    required VoidCallback onClearEntry,
    required VoidCallback onDelete,
    required void Function(String digit) onNumber,
    VoidCallback? onNegate,
    bool showSignToggle = false,
  }) {
    // Build last row based on showSignToggle
    final List<ConverterKeyButton?> lastRow;
    if (showSignToggle && onNegate != null) {
      final negateCallback = onNegate;
      lastRow = [
        ConverterKeyButton(
          icon: CalculatorIcons.negate,
          type: CalcButtonType.number,
          onPressed: negateCallback,
        ),
        ConverterKeyButton(
          text: '0',
          type: CalcButtonType.number,
          onPressed: () => onNumber('0'),
        ),
        ConverterKeyButton(
          text: '.',
          type: CalcButtonType.number,
          onPressed: () => onNumber('.'),
        ),
      ];
    } else {
      lastRow = [
        null,
        ConverterKeyButton(
          text: '0',
          type: CalcButtonType.number,
          onPressed: () => onNumber('0'),
        ),
        ConverterKeyButton(
          text: '.',
          type: CalcButtonType.number,
          onPressed: () => onNumber('.'),
        ),
      ];
    }

    return ConverterKeypad._(
      theme: theme,
      layout: ConverterKeypadLayout(
        columnCount: 3,
        buttons: [
          // Row 0: null, CE, DEL
          [
            null,
            ConverterKeyButton(
              text: 'CE',
              type: CalcButtonType.operator,
              onPressed: onClearEntry,
            ),
            ConverterKeyButton(
              icon: CalculatorIcons.backspace,
              type: CalcButtonType.operator,
              onPressed: onDelete,
            ),
          ],
          // Row 1: 7, 8, 9
          [
            ConverterKeyButton(
              text: '7',
              type: CalcButtonType.number,
              onPressed: () => onNumber('7'),
            ),
            ConverterKeyButton(
              text: '8',
              type: CalcButtonType.number,
              onPressed: () => onNumber('8'),
            ),
            ConverterKeyButton(
              text: '9',
              type: CalcButtonType.number,
              onPressed: () => onNumber('9'),
            ),
          ],
          // Row 2: 4, 5, 6
          [
            ConverterKeyButton(
              text: '4',
              type: CalcButtonType.number,
              onPressed: () => onNumber('4'),
            ),
            ConverterKeyButton(
              text: '5',
              type: CalcButtonType.number,
              onPressed: () => onNumber('5'),
            ),
            ConverterKeyButton(
              text: '6',
              type: CalcButtonType.number,
              onPressed: () => onNumber('6'),
            ),
          ],
          // Row 3: 1, 2, 3
          [
            ConverterKeyButton(
              text: '1',
              type: CalcButtonType.number,
              onPressed: () => onNumber('1'),
            ),
            ConverterKeyButton(
              text: '2',
              type: CalcButtonType.number,
              onPressed: () => onNumber('2'),
            ),
            ConverterKeyButton(
              text: '3',
              type: CalcButtonType.number,
              onPressed: () => onNumber('3'),
            ),
          ],
          lastRow,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rowCount = layout.buttons.length;

    // Build list of column sizes (all equal width)
    final columnSizes = List.filled(layout.columnCount, 1.fr);

    // Build list of row sizes (all equal height)
    final rowSizes = List.filled(rowCount, 1.fr);

    return Container(
      padding: const EdgeInsets.all(4),
      child: LayoutGrid(
        columnSizes: columnSizes,
        rowSizes: rowSizes,
        columnGap: 0,
        rowGap: 0,
        children: _buildButtons(),
      ),
    );
  }

  List<Widget> _buildButtons() {
    final List<Widget> widgets = [];

    for (int row = 0; row < layout.buttons.length; row++) {
      final rowData = layout.buttons[row];

      for (int col = 0; col < rowData.length; col++) {
        final button = rowData[col];

        // Skip null buttons (empty spaces)
        if (button == null) continue;

        widgets.add(
          CalcButton(
            text: button.text,
            icon: button.icon,
            type: button.type,
            onPressed: button.onPressed,
          ).withGridPlacement(
            columnStart: col,
            rowStart: row,
          ),
        );
      }
    }

    return widgets;
  }
}
