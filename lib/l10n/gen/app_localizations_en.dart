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
  String get categories => 'Categories';

  @override
  String get transactions => 'Transactions';

  @override
  String get newTransaction => 'New Transaction';

  @override
  String get amount => 'Amount';

  @override
  String get category => 'Category';

  @override
  String get currency => 'Currency';

  @override
  String get date => 'Date';

  @override
  String get save => 'Save';

  @override
  String get noTransactions => 'No transactions yet';

  @override
  String get deleted => 'Deleted';

  @override
  String totalExpense(Object amount) {
    return 'Total expense: ¥$amount';
  }

  @override
  String get settings => 'Settings';

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
  String get selectMonth => 'Select Month';

  @override
  String get bankCard => 'Bank Card';
}
