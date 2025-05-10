// lib/utils/currency_formatter.dart

import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String format(double amount, {String currency = 'CNY', bool showSymbol = true}) {
    final formatter = NumberFormat('#,##0', 'en_US');
    String formatted = formatter.format(amount.toInt());
    
    if (showSymbol) {
      switch (currency) {
        case 'CNY':
        case 'JPY':
          return '¥$formatted';
        case 'USD':
          return '\$$formatted';
        case 'EUR':
          return '€$formatted';
        default:
          return formatted;
      }
    }
    
    return formatted;
  }

  static String formatWithDecimals(double amount, {String currency = 'CNY', bool showSymbol = true}) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    String formatted = formatter.format(amount);
    
    if (showSymbol) {
      switch (currency) {
        case 'CNY':
        case 'JPY':
          return '¥$formatted';
        case 'USD':
          return '\$$formatted';
        case 'EUR':
          return '€$formatted';
        default:
          return formatted;
      }
    }
    
    return formatted;
  }

  static String formatCompact(double amount, {String currency = 'CNY'}) {
    if (amount >= 10000) {
      return '${formatWithDecimals(amount / 10000, currency: currency, showSymbol: false)}万';
    } else if (amount >= 1000) {
      return '${formatWithDecimals(amount / 1000, currency: currency, showSymbol: false)}千';
    }
    return format(amount, currency: currency, showSymbol: false);
  }

  static String getCurrencySymbol(String currency) {
    switch (currency) {
      case 'CNY':
      case 'JPY':
        return '¥';
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      default:
        return currency;
    }
  }
}