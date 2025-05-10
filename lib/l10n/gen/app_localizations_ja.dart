// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'マネーマネージャー';

  @override
  String get categories => 'カテゴリー';

  @override
  String get transactions => '取引';

  @override
  String get newTransaction => '新規取引';

  @override
  String get amount => '金額';

  @override
  String get category => 'カテゴリー';

  @override
  String get currency => '通貨';

  @override
  String get date => '日付';

  @override
  String get save => '保存';

  @override
  String get noTransactions => '取引記録がありません';

  @override
  String get deleted => '取引が削除されました';

  @override
  String totalExpense(Object amount) {
    return '今月の支出：¥$amount';
  }

  @override
  String get settings => '設定';

  @override
  String get language => '言語';

  @override
  String get english => '英語';

  @override
  String get chinese => '中国語';

  @override
  String get japanese => '日本語';

  @override
  String get startingBalance => '開始残高';

  @override
  String get endingBalance => '期末残高';

  @override
  String get selectMonth => '月を選択';

  @override
  String get bankCard => '銀行カード';
}
