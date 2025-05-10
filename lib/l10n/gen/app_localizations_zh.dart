// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '记账应用';

  @override
  String get categories => '类别';

  @override
  String get transactions => '交易';

  @override
  String get newTransaction => '新增流水';

  @override
  String get amount => '金额';

  @override
  String get category => '类别';

  @override
  String get currency => '币种';

  @override
  String get date => '日期';

  @override
  String get save => '保存';

  @override
  String get noTransactions => '暂无交易记录';

  @override
  String get deleted => '已删除交易';

  @override
  String totalExpense(Object amount) {
    return '本月支出：¥$amount';
  }

  @override
  String get settings => '设置';

  @override
  String get language => '语言';

  @override
  String get english => '英文';

  @override
  String get chinese => '中文';

  @override
  String get japanese => '日文';
}
