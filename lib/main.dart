import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';
import 'package:chinese_font_library/chinese_font_library.dart';
import 'l10n/l10n.dart';
import 'l10n/app_localizations.dart';
import 'shared/theme/theme_provider.dart';
import 'features/calculator/calculator_view.dart';
import 'core/services/persistence/preferences_service.dart';

void main() async {
  // Initialize window manager
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  // Initialize preferences service
  await PreferencesService.init();

  // Set window options
  WindowOptions windowOptions = WindowOptions(
    minimumSize: const Size(340, 560),
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const ProviderScope(child: CalculatorApp()));
}

class CalculatorApp extends ConsumerWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);

    return MaterialApp(
      title: 'WinCalc',
      debugShowCheckedModeBanner: false,
      theme: themeState.theme.toThemeData().useSystemChineseFont(themeState.theme.brightness),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: supportedLocales,
      home: const CalculatorView(),
    );
  }
}
