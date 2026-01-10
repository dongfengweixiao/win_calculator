// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get standardMode => 'Standard';

  @override
  String get scientificMode => 'Scientific';

  @override
  String get programmerMode => 'Programmer';

  @override
  String get history => 'History';

  @override
  String get memory => 'Memory';

  @override
  String get noHistoryTitle => 'No history yet';

  @override
  String get noHistoryMessage => 'No history records yet';

  @override
  String get noMemoryTitle => 'Memory is empty';

  @override
  String get noMemoryMessage => 'No data in memory';

  @override
  String get noMemoryHint => 'Use memory buttons to store numbers';

  @override
  String get degree => 'Degree';

  @override
  String get radian => 'Radian';

  @override
  String get gradian => 'Grad';
}
