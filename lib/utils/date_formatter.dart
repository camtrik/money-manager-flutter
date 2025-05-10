// lib/utils/date_formatter.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateFormatter {
  static String formatMonth(DateTime date, BuildContext context) {
    final locale = Localizations.localeOf(context);
    
    if (locale.languageCode == 'zh') {
      return DateFormat('yyyy年M月', 'zh').format(date);
    } else if (locale.languageCode == 'ja' || locale.languageCode == 'jp') {
      return DateFormat('yyyy年M月', 'ja').format(date);
    }
    return DateFormat('MMM yyyy', 'en').format(date);
  }

  static String formatMonthOnly(DateTime date, BuildContext context) {
    final locale = Localizations.localeOf(context);
    
    if (locale.languageCode == 'zh') {
      return DateFormat('M月', 'zh').format(date);
    } else if (locale.languageCode == 'ja' || locale.languageCode == 'jp') {
      return DateFormat('M月', 'ja').format(date);
    }
    return DateFormat('MMM', 'en').format(date);
  }

  static String formatYear(DateTime date) {
    return DateFormat('yyyy').format(date);
  }

  static String formatDay(DateTime date) {
    return DateFormat('d').format(date);
  }

  static String formatMonthYear(DateTime date, BuildContext context) {
    final locale = Localizations.localeOf(context);
    
    if (locale.languageCode == 'zh') {
      return '${date.month}月 ${date.year}';
    } else if (locale.languageCode == 'ja' || locale.languageCode == 'jp') {
      return '${date.month}月 ${date.year}年';
    }
    return DateFormat('MMM yyyy', 'en').format(date);
  }

  static String formatWeekday(DateTime date, BuildContext context) {
    final locale = Localizations.localeOf(context);
    
    if (locale.languageCode == 'zh') {
      final weekdays = ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'];
      return weekdays[date.weekday % 7];
    } else if (locale.languageCode == 'ja' || locale.languageCode == 'jp') {
      final weekdays = ['日曜日', '月曜日', '火曜日', '水曜日', '木曜日', '金曜日', '土曜日'];
      return weekdays[date.weekday % 7];
    }
    
    return DateFormat('EEEE', 'en').format(date);
  }

  static String formatFullDate(DateTime date, BuildContext context) {
    final locale = Localizations.localeOf(context);
    
    if (locale.languageCode == 'zh') {
      return DateFormat('yyyy年M月d日', 'zh').format(date);
    } else if (locale.languageCode == 'ja' || locale.languageCode == 'jp') {
      return DateFormat('yyyy年M月d日', 'ja').format(date);
    }
    return DateFormat('MMM d, yyyy', 'en').format(date);
  }

  static String formatShortDate(DateTime date, BuildContext context) {
    final locale = Localizations.localeOf(context);
    
    if (locale.languageCode == 'zh' || locale.languageCode == 'ja' || locale.languageCode == 'jp') {
      return DateFormat('M/d', locale.languageCode).format(date);
    }
    return DateFormat('MM/dd', 'en').format(date);
  }

  // For database storage or internal use
  static String formatForStorage(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static DateTime? parseFromStorage(String dateString) {
    try {
      return DateFormat('yyyy-MM-dd').parse(dateString);
    } catch (e) {
      return null;
    }
  }
}