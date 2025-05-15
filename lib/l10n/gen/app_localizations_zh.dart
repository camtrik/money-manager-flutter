// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '记账本';

  @override
  String get settings => '设置';

  @override
  String get categories => '分类';

  @override
  String get transactions => '交易';

  @override
  String get newTransaction => '新交易';

  @override
  String get save => '保存';

  @override
  String get deleted => '已删除交易';

  @override
  String get delete => '删除';

  @override
  String get cancel => '取消';

  @override
  String get amount => '金额';

  @override
  String get category => '分类';

  @override
  String get currency => '币种';

  @override
  String get date => '日期';

  @override
  String get notes => '备注';

  @override
  String get categoryDining => '餐饮';

  @override
  String get categoryTransport => '交通';

  @override
  String get categoryShopping => '购物';

  @override
  String get categoryEntertainment => '娱乐';

  @override
  String get categoryMedical => '医疗';

  @override
  String get categoryHousing => '住房';

  @override
  String get categoryCommunication => '通讯';

  @override
  String get categoryDaily => '日用';

  @override
  String get categoryOther => '其他';

  @override
  String get addCategory => '添加分类';

  @override
  String get editCategory => '编辑分类';

  @override
  String get categoryName => '分类名称';

  @override
  String get selectIcon => '选择图标';

  @override
  String get selectColor => '选择颜色';

  @override
  String get preview => '预览';

  @override
  String get categoryNameRequired => '分类名称不能为空';

  @override
  String confirmDeleteCategory(Object name) {
    return '确定要删除 $name 吗？';
  }

  @override
  String deleteRelatedTransactions(Object count) {
    return '与该类别关联的所有交易记录($count)将会被删除。';
  }

  @override
  String get noTransactions => '暂无交易记录';

  @override
  String get expense => '支出';

  @override
  String get totalExpense => '总支出';

  @override
  String get today => '今天';

  @override
  String get selectMonth => '选择月份';

  @override
  String get language => '语言';

  @override
  String get english => '英语';

  @override
  String get chinese => '中文';

  @override
  String get japanese => '日语';

  @override
  String get startingBalance => '起始余额';

  @override
  String get endingBalance => '结余';

  @override
  String get bankCard => '银行卡';
}
