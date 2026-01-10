import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/navigation/navigation_provider.dart';
import '../../shared/theme/theme_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/domain/entities/view_mode.dart';
import '../../l10n/l10n.dart';
import '../../l10n/app_localizations.dart';

/// Navigation drawer for calculator mode selection
class CalculatorNavigationDrawer extends ConsumerWidget {
  const CalculatorNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(calculatorThemeProvider);

    return Drawer(
      backgroundColor: theme.navPaneBackground,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Navigation categories
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final group in navCategories)
                      _buildCategoryGroup(context, ref, theme, group),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGroup(
    BuildContext context,
    WidgetRef ref,
    CalculatorTheme theme,
    NavCategoryGroup group,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Group header
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
          child: Text(
            group.name,
            style: TextStyle(
              color: theme.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        // Category items
        for (final category in group.categories)
          _buildCategoryItem(context, ref, theme, category),
      ],
    );
  }

  Widget _buildCategoryItem(
    BuildContext context,
    WidgetRef ref,
    CalculatorTheme theme,
    NavCategory category,
  ) {
    final navState = ref.watch(navigationProvider);
    final isSelected = category.viewMode == navState.currentMode;
    final l10n = context.l10n;

    // Get localized label
    String localizedLabel;
    if (category.viewMode != null) {
      localizedLabel = _getModeDisplayName(l10n, category.viewMode!);
    } else {
      localizedLabel = category.name;
    }

    return _NavigationItem(
      icon: category.icon,
      label: localizedLabel,
      isSelected: isSelected,
      theme: theme,
      onPressed: category.viewMode != null
          ? () {
              ref.read(navigationProvider.notifier).setMode(category.viewMode!);
              Navigator.of(context).pop();
            }
          : null,
    );
  }

  String _getModeDisplayName(AppLocalizations l10n, ViewMode mode) {
    switch (mode.localizationKey) {
      case 'standardMode':
        return l10n.standardMode;
      case 'scientificMode':
        return l10n.scientificMode;
      case 'programmerMode':
        return l10n.programmerMode;
      default:
        return mode.localizationKey;
    }
  }
}

/// Navigation item (mode selector)
class _NavigationItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final CalculatorTheme theme;
  final VoidCallback? onPressed;

  const _NavigationItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.theme,
    this.onPressed,
  });

  @override
  State<_NavigationItem> createState() => _NavigationItemState();
}

class _NavigationItemState extends State<_NavigationItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    if (widget.isSelected) {
      backgroundColor = widget.theme.accentColor.withValues(alpha: 0.15);
    } else if (_isHovered) {
      backgroundColor = widget.theme.textPrimary.withValues(alpha: 0.08);
    } else {
      backgroundColor = Colors.transparent;
    }

    return InkWell(
      onHover: (value) {
        setState(() {
          _isHovered = value;
        });
      },
      onTap: widget.onPressed,
      child: Container(
        height: 48,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(4),
          border: widget.isSelected
              ? Border(
                  left: BorderSide(color: widget.theme.accentColor, width: 3),
                )
              : null,
        ),
        child: Row(
          children: [
            // Icon
            SizedBox(
              width: 48,
              child: Center(
                child: Icon(
                  widget.icon,
                  color: widget.isSelected
                      ? widget.theme.accentColor
                      : widget.theme.textPrimary,
                  size: 20,
                ),
              ),
            ),
            // Label
            Expanded(
              child: Text(
                widget.label,
                style: TextStyle(
                  color: widget.isSelected
                      ? widget.theme.accentColor
                      : widget.theme.textPrimary,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
