import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_icons.dart';
import '../../core/domain/entities/view_mode.dart';
import '../../core/services/layout/responsive_layout_service.dart';
import '../../core/services/persistence/preferences_service.dart';

/// Navigation category for the sidebar
class NavCategory {
  final String name;
  final IconData icon;
  final ViewMode? viewMode;
  final bool isHeader;

  const NavCategory({
    required this.name,
    required this.icon,
    this.viewMode,
    this.isHeader = false,
  });
}

/// Navigation category group
class NavCategoryGroup {
  final String name;
  final List<NavCategory> categories;

  const NavCategoryGroup({required this.name, required this.categories});
}

/// All navigation categories
final navCategories = [
  const NavCategoryGroup(
    name: '计算器',
    categories: [
      NavCategory(
        name: '标准',
        icon: CalculatorIcons.standardCalculator,
        viewMode: ViewMode.standard,
      ),
      NavCategory(
        name: '科学',
        icon: CalculatorIcons.scientificCalculator,
        viewMode: ViewMode.scientific,
      ),
      NavCategory(
        name: '程序员',
        icon: CalculatorIcons.programmerCalculator,
        viewMode: ViewMode.programmer,
      ),
      NavCategory(
        name: '日期计算',
        icon: CalculatorIcons.dateCalculation,
        viewMode: ViewMode.dateCalculation,
      ),
    ],
  ),
  const NavCategoryGroup(
    name: '转换器',
    categories: [
      NavCategory(
        name: '体积',
        icon: CalculatorIcons.volume,
        viewMode: ViewMode.volumeConverter,
      ),
    ],
  ),
];

/// Navigation state
class NavigationState {
  final bool isDrawerOpen;
  final ViewMode currentMode;
  final bool showHistoryPanel;

  const NavigationState({
    this.isDrawerOpen = false,
    this.currentMode = ViewMode.standard,
    this.showHistoryPanel = false,
  });

  NavigationState copyWith({
    bool? isDrawerOpen,
    ViewMode? currentMode,
    bool? showHistoryPanel,
  }) {
    return NavigationState(
      isDrawerOpen: isDrawerOpen ?? this.isDrawerOpen,
      currentMode: currentMode ?? this.currentMode,
      showHistoryPanel: showHistoryPanel ?? this.showHistoryPanel,
    );
  }
}

/// Navigation notifier
/// Refactored to use domain entities and services
class NavigationNotifier extends Notifier<NavigationState> {
  @override
  NavigationState build() {
    // Load the last used view mode from preferences
    final savedMode = PreferencesService.getLastViewMode();

    return NavigationState(
      currentMode: savedMode ?? ViewMode.standard,
    );
  }

  /// Toggle drawer open/close
  void toggleDrawer() {
    state = state.copyWith(isDrawerOpen: !state.isDrawerOpen);
  }

  /// Open drawer
  void openDrawer() {
    state = state.copyWith(isDrawerOpen: true);
  }

  /// Close drawer
  void closeDrawer() {
    state = state.copyWith(isDrawerOpen: false);
  }

  /// Set current mode
  void setMode(ViewMode mode) {
    state = state.copyWith(currentMode: mode, isDrawerOpen: false);
    // Save the selected mode to preferences
    PreferencesService.saveLastViewMode(mode);
  }

  /// Toggle history panel visibility
  void toggleHistoryPanel() {
    state = state.copyWith(showHistoryPanel: !state.showHistoryPanel);
  }

  /// Set history panel visibility based on screen width
  /// Uses ResponsiveLayoutService to determine visibility
  void updateHistoryPanelVisibility(double width) {
    final shouldShow = ResponsiveLayoutService.shouldShowHistoryPanel(width);
    if (state.showHistoryPanel != shouldShow) {
      state = state.copyWith(showHistoryPanel: shouldShow);
    }
  }
}

/// Navigation provider
final navigationProvider =
    NotifierProvider<NavigationNotifier, NavigationState>(
      NavigationNotifier.new,
    );

/// Current view mode provider
final currentModeProvider = Provider<ViewMode>((ref) {
  return ref.watch(navigationProvider).currentMode;
});

/// Show history panel provider
final showHistoryPanelProvider = Provider<bool>((ref) {
  return ref.watch(navigationProvider).showHistoryPanel;
});
