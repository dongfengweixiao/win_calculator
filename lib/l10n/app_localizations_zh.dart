// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get standardMode => '标准';

  @override
  String get scientificMode => '科学';

  @override
  String get programmerMode => '程序员';

  @override
  String get history => '历史记录';

  @override
  String get memory => '内存';

  @override
  String get noHistoryTitle => '还没有历史记录';

  @override
  String get noHistoryMessage => '还没有历史记录';

  @override
  String get noMemoryTitle => '内存中没有数据';

  @override
  String get noMemoryMessage => '内存中没有数据';

  @override
  String get noMemoryHint => '使用内存按钮存储数字';

  @override
  String get degree => '度';

  @override
  String get radian => '弧度';

  @override
  String get gradian => '梯度';
}
