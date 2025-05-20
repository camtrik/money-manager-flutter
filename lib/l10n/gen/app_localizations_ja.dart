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
  String get settings => '設定';

  @override
  String get categories => 'カテゴリー';

  @override
  String get transactions => '取引';

  @override
  String get newTransaction => '新規取引';

  @override
  String get save => '保存';

  @override
  String get deleted => '取引が削除されました';

  @override
  String get delete => '削除';

  @override
  String get edit => '編集';

  @override
  String get cancel => 'キャンセル';

  @override
  String get amount => '金額';

  @override
  String get category => 'カテゴリー';

  @override
  String get currency => '通貨';

  @override
  String get date => '日付';

  @override
  String get notes => 'メモ';

  @override
  String get categoryDining => '食事';

  @override
  String get categoryTransport => '交通';

  @override
  String get categoryShopping => 'ショッピング';

  @override
  String get categoryEntertainment => '娯楽';

  @override
  String get categoryMedical => '医療';

  @override
  String get categoryHousing => '住宅';

  @override
  String get categoryCommunication => '通信';

  @override
  String get categoryDaily => '日用品';

  @override
  String get categoryClothing => '服';

  @override
  String get categoryOther => 'その他';

  @override
  String get addCategory => 'カテゴリーを追加';

  @override
  String get editCategory => 'カテゴリーを編集';

  @override
  String get categoryName => 'カテゴリー名';

  @override
  String get selectIcon => 'アイコンを選択';

  @override
  String get selectColor => '色を選択';

  @override
  String get preview => 'プレビュー';

  @override
  String get noTransactions => '取引はまだありません';

  @override
  String get expense => '支出';

  @override
  String get totalExpense => '総支出';

  @override
  String get today => '今日';

  @override
  String get selectMonth => '月を選択';

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
  String get endingBalance => '終了残高';

  @override
  String get bankCard => '銀行カード';

  @override
  String get amountRequired => '金額は必須です';

  @override
  String get categoryNameRequired => 'カテゴリー名は必須です';

  @override
  String confirmDeleteCategory(Object name) {
    return '「$name」カテゴリを削除してもよろしいですか？';
  }

  @override
  String deleteRelatedTransactions(Object count) {
    return 'これにより関連する取引($count)も削除されます。';
  }

  @override
  String get confirmDeleteTransaction => 'この取引を削除してもよろしいですか？';

  @override
  String get deleteTransaction => 'この取引は削除されます。この操作は元に戻せません';

  @override
  String get selectSpecificDate => '特定の日付を選択';

  @override
  String get viewByDay => '日別表示';

  @override
  String get viewByWeek => '週別表示';

  @override
  String get viewByMonth => '月別表示';

  @override
  String get viewByYear => '年別表示';

  @override
  String get customDateRange => 'カスタム期間';

  @override
  String get periodTitle => '期間';

  @override
  String get selectRange => '範囲を選択';

  @override
  String get allTime => '全期間';

  @override
  String get week => '週';

  @override
  String get year => '年';

  @override
  String get month => '月';
}
