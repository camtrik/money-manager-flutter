// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Money Manager';

  @override
  String get settings => 'Settings';

  @override
  String get categories => 'Categories';

  @override
  String get transactions => 'Transactions';

  @override
  String get newTransaction => 'New Transaction';

  @override
  String get save => 'Save';

  @override
  String get deleted => 'Deleted';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get cancel => 'Cancel';

  @override
  String get amount => 'Amount';

  @override
  String get category => 'Category';

  @override
  String get currency => 'Currency';

  @override
  String get date => 'Date';

  @override
  String get notes => 'Notes';

  @override
  String get categoryDining => 'Dining';

  @override
  String get categoryTransport => 'Transport';

  @override
  String get categoryShopping => 'Shopping';

  @override
  String get categoryEntertainment => 'Entertainment';

  @override
  String get categoryMedical => 'Medical';

  @override
  String get categoryHousing => 'Housing';

  @override
  String get categoryCommunication => 'Communication';

  @override
  String get categoryDaily => 'Daily';

  @override
  String get categoryClothing => 'Clothes';

  @override
  String get categoryOther => 'Other';

  @override
  String get addCategory => 'Add Category';

  @override
  String get editCategory => 'Edit Category';

  @override
  String get categoryName => 'Category Name';

  @override
  String get selectIcon => 'Select Icon';

  @override
  String get selectColor => 'Select Color';

  @override
  String get preview => 'Preview';

  @override
  String get noTransactions => 'No transactions yet';

  @override
  String get expense => 'Expense';

  @override
  String get totalExpense => 'Total expense';

  @override
  String get today => 'Today';

  @override
  String get selectMonth => 'Select Month';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get chinese => 'Chinese';

  @override
  String get japanese => 'Japanese';

  @override
  String get startingBalance => 'Starting Balance';

  @override
  String get endingBalance => 'Ending Balance';

  @override
  String get bankCard => 'Bank Card';

  @override
  String get amountRequired => 'Amount is required';

  @override
  String get categoryNameRequired => 'Category name is required';

  @override
  String confirmDeleteCategory(Object name) {
    return 'Are you sure you want to delete the \"$name\" category?';
  }

  @override
  String deleteRelatedTransactions(Object count) {
    return 'This will also delete all related transactions($count).';
  }

  @override
  String get confirmDeleteTransaction => 'Are you sure you want to delete this transaction?';

  @override
  String get deleteTransaction => 'This transaction will be deleted, this operation cannot be undone';

  @override
  String get selectSpecificDate => 'Select Specific Date';

  @override
  String get viewByDay => 'View by Day';

  @override
  String get viewByWeek => 'View by Week';

  @override
  String get viewByMonth => 'View by Month';

  @override
  String get viewByYear => 'View by Year';

  @override
  String get customDateRange => 'Custom Date Range';

  @override
  String get periodTitle => 'Period';

  @override
  String get selectRange => 'Select Range';

  @override
  String get allTime => 'All Time';

  @override
  String get week => 'Week';

  @override
  String get year => 'Year';

  @override
  String get month => 'Month';
}
