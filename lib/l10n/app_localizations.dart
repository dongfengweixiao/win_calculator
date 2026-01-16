import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// Name for the standard calculator mode
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get standardMode;

  /// Name for the scientific calculator mode
  ///
  /// In en, this message translates to:
  /// **'Scientific'**
  String get scientificMode;

  /// Name for the programmer calculator mode
  ///
  /// In en, this message translates to:
  /// **'Programmer'**
  String get programmerMode;

  /// Name for the date calculation mode
  ///
  /// In en, this message translates to:
  /// **'Date Calculation'**
  String get dateCalculationMode;

  /// Name for the volume converter mode
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get volumeConverterMode;

  /// History panel tab label
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// Memory panel tab label
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get memory;

  /// Title shown when history is empty
  ///
  /// In en, this message translates to:
  /// **'No history yet'**
  String get noHistoryTitle;

  /// Message shown when history is empty
  ///
  /// In en, this message translates to:
  /// **'No history records yet'**
  String get noHistoryMessage;

  /// Title shown when memory is empty
  ///
  /// In en, this message translates to:
  /// **'Memory is empty'**
  String get noMemoryTitle;

  /// Message shown when memory is empty
  ///
  /// In en, this message translates to:
  /// **'No data in memory'**
  String get noMemoryMessage;

  /// Hint shown when memory is empty
  ///
  /// In en, this message translates to:
  /// **'Use memory buttons to store numbers'**
  String get noMemoryHint;

  /// Degree angle unit
  ///
  /// In en, this message translates to:
  /// **'Degree'**
  String get degree;

  /// Radian angle unit
  ///
  /// In en, this message translates to:
  /// **'Radian'**
  String get radian;

  /// Gradian angle unit
  ///
  /// In en, this message translates to:
  /// **'Grad'**
  String get gradian;

  /// Shift operation
  ///
  /// In en, this message translates to:
  /// **'Shift'**
  String get shift;

  /// Bitwise operation
  ///
  /// In en, this message translates to:
  /// **'Bitwise'**
  String get bitwise;

  /// Full keypad input mode
  ///
  /// In en, this message translates to:
  /// **'Full Keypad'**
  String get fullKeypad;

  /// Bit flip input mode
  ///
  /// In en, this message translates to:
  /// **'Bit Flip'**
  String get bitFlip;

  /// Arithmetic shift mode
  ///
  /// In en, this message translates to:
  /// **'Arithmetic Shift'**
  String get arithmeticShift;

  /// Logical shift mode
  ///
  /// In en, this message translates to:
  /// **'Logical Shift'**
  String get logicalShift;

  /// Rotate shift mode
  ///
  /// In en, this message translates to:
  /// **'Rotate Shift'**
  String get rotateShift;

  /// Rotate through carry shift mode
  ///
  /// In en, this message translates to:
  /// **'Rotate Through Carry'**
  String get rotateCarryShift;

  /// Hexadecimal
  ///
  /// In en, this message translates to:
  /// **'HEX'**
  String get hex;

  /// Decimal
  ///
  /// In en, this message translates to:
  /// **'DEC'**
  String get dec;

  /// Octal
  ///
  /// In en, this message translates to:
  /// **'OCT'**
  String get oct;

  /// Binary
  ///
  /// In en, this message translates to:
  /// **'BIN'**
  String get bin;

  /// Quadword
  ///
  /// In en, this message translates to:
  /// **'QWORD'**
  String get qword;

  /// Doubleword
  ///
  /// In en, this message translates to:
  /// **'DWORD'**
  String get dword;

  /// Word
  ///
  /// In en, this message translates to:
  /// **'WORD'**
  String get word;

  /// Byte
  ///
  /// In en, this message translates to:
  /// **'BYTE'**
  String get byte;

  /// Title for date calculation page
  ///
  /// In en, this message translates to:
  /// **'Date Calculation'**
  String get dateCalculationTitle;

  /// Option to calculate difference between two dates
  ///
  /// In en, this message translates to:
  /// **'Calculate Difference Between Dates'**
  String get calculateDifferenceBetweenDates;

  /// Option to add or subtract duration from a date
  ///
  /// In en, this message translates to:
  /// **'Add or Subtract from Date'**
  String get addOrSubtractFromDate;

  /// Label for the starting date in date difference calculation
  ///
  /// In en, this message translates to:
  /// **'From Date'**
  String get fromDate;

  /// Label for the ending date in date difference calculation
  ///
  /// In en, this message translates to:
  /// **'To Date'**
  String get toDate;

  /// Label for the starting date in add/subtract calculation
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// Add operation for date calculation
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Subtract operation for date calculation
  ///
  /// In en, this message translates to:
  /// **'Subtract'**
  String get subtract;

  /// Years label for date offset
  ///
  /// In en, this message translates to:
  /// **'Years'**
  String get years;

  /// Months label for date offset
  ///
  /// In en, this message translates to:
  /// **'Months'**
  String get months;

  /// Days label for date offset
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// Label for date difference result
  ///
  /// In en, this message translates to:
  /// **'Difference'**
  String get difference;

  /// Label for calculation result
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get result;

  /// Placeholder text when no date is selected
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// Message shown when dates are not selected
  ///
  /// In en, this message translates to:
  /// **'Select both dates'**
  String get selectBothDates;

  /// Singular form of year
  ///
  /// In en, this message translates to:
  /// **'year'**
  String get year;

  /// Plural form of years
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get years_plural;

  /// Singular form of month
  ///
  /// In en, this message translates to:
  /// **'month'**
  String get month;

  /// Plural form of months
  ///
  /// In en, this message translates to:
  /// **'months'**
  String get months_plural;

  /// Singular form of week
  ///
  /// In en, this message translates to:
  /// **'week'**
  String get week;

  /// Plural form of weeks
  ///
  /// In en, this message translates to:
  /// **'weeks'**
  String get weeks_plural;

  /// Singular form of day
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get day;

  /// Plural form of days
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days_plural;

  /// Title for volume converter page
  ///
  /// In en, this message translates to:
  /// **'Volume Converter'**
  String get volumeConverterTitle;

  /// Label for from unit field
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get fromUnit;

  /// Label for to unit field
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get toUnit;

  /// Cubic meters unit
  ///
  /// In en, this message translates to:
  /// **'Cubic Meters'**
  String get cubicMeters;

  /// Cubic centimeters unit
  ///
  /// In en, this message translates to:
  /// **'Cubic Centimeters'**
  String get cubicCentimeters;

  /// Cubic millimeters unit
  ///
  /// In en, this message translates to:
  /// **'Cubic Millimeters'**
  String get cubicMillimeters;

  /// Cubic yards unit
  ///
  /// In en, this message translates to:
  /// **'Cubic Yards'**
  String get cubicYards;

  /// Liters unit
  ///
  /// In en, this message translates to:
  /// **'Liters'**
  String get liters;

  /// Milliliters unit
  ///
  /// In en, this message translates to:
  /// **'Milliliters'**
  String get milliliters;

  /// Cubic feet unit
  ///
  /// In en, this message translates to:
  /// **'Cubic Feet'**
  String get cubicFeet;

  /// Cubic inches unit
  ///
  /// In en, this message translates to:
  /// **'Cubic Inches'**
  String get cubicInches;

  /// US gallons unit
  ///
  /// In en, this message translates to:
  /// **'US Gallons'**
  String get usGallons;

  /// UK gallons unit
  ///
  /// In en, this message translates to:
  /// **'UK Gallons'**
  String get ukGallons;

  /// US fluid ounces unit
  ///
  /// In en, this message translates to:
  /// **'US Fluid Ounces'**
  String get usFluidOunces;

  /// UK fluid ounces unit
  ///
  /// In en, this message translates to:
  /// **'UK Fluid Ounces'**
  String get ukFluidOunces;

  /// Tablespoons unit
  ///
  /// In en, this message translates to:
  /// **'Tablespoons'**
  String get tablespoons;

  /// Teaspoons unit
  ///
  /// In en, this message translates to:
  /// **'Teaspoons'**
  String get teaspoons;

  /// US quarts unit
  ///
  /// In en, this message translates to:
  /// **'US Quarts'**
  String get usQuarts;

  /// US pints unit
  ///
  /// In en, this message translates to:
  /// **'US Pints'**
  String get usPints;

  /// US cups unit
  ///
  /// In en, this message translates to:
  /// **'US Cups'**
  String get usCups;

  /// Imperial gallons unit
  ///
  /// In en, this message translates to:
  /// **'Imperial Gallons'**
  String get imperialGallons;

  /// Imperial quarts unit
  ///
  /// In en, this message translates to:
  /// **'Imperial Quarts'**
  String get imperialQuarts;

  /// Imperial pints unit
  ///
  /// In en, this message translates to:
  /// **'Imperial Pints'**
  String get imperialPints;

  /// Imperial tablespoons unit
  ///
  /// In en, this message translates to:
  /// **'Imperial Tablespoons'**
  String get imperialTablespoons;

  /// Imperial teaspoons unit
  ///
  /// In en, this message translates to:
  /// **'Imperial Teaspoons'**
  String get imperialTeaspoons;

  /// Imperial fluid ounces unit
  ///
  /// In en, this message translates to:
  /// **'Imperial Fluid Ounces'**
  String get imperialFluidOunces;

  /// US tablespoons unit
  ///
  /// In en, this message translates to:
  /// **'US Tablespoons'**
  String get usTablespoons;

  /// US teaspoons unit
  ///
  /// In en, this message translates to:
  /// **'US Teaspoons'**
  String get usTeaspoons;

  /// Metric cups unit
  ///
  /// In en, this message translates to:
  /// **'Metric Cups'**
  String get metricCups;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
