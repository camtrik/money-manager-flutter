// lib/utils/date_formatter.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context);
    
    if (locale.languageCode == 'zh') {
      return DateFormat('yyyy年M月d日', 'zh').format(date);
    } else if (locale.languageCode == 'ja' || locale.languageCode == 'ja') {
      return DateFormat('yyyy年M月d日', 'ja').format(date);
    }
    return DateFormat('MMM d, yyyy', 'en').format(date);
  }

  static String formatMonthYear(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context);
    if (locale.languageCode == 'zh') {
      return DateFormat('yyyy年M月', 'zh').format(date);
    } else if (locale.languageCode == 'ja') {
      return DateFormat('yyyy年M月', 'ja').format(date);
    }
    return DateFormat('MMMM yyyy', 'en').format(date);
  }


  // Helper methods for date formatting
  static String formatDateKey(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static DateTime parseDateKey(String dateKey) {
    return DateFormat('yyyy-MM-dd').parse(dateKey);
  }

  static String getDayOfWeek(BuildContext context, String dateKey) {
    final date = parseDateKey(dateKey);
    final locale = Localizations.localeOf(context).languageCode;
    
    if (locale == 'zh') {
      return _getChineseDayOfWeek(date.weekday);
    } else if (locale == 'ja') {
      return _getJapaneseDayOfWeek(date.weekday);
    } else {
      return DateFormat('EEEE').format(date);
    }
  }

  static String _getJapaneseDayOfWeek(int weekday) {
    const days = ['月曜日', '火曜日', '水曜日', '木曜日', '金曜日', '土曜日', '日曜日'];
    return days[weekday - 1];
  }

  static String _getChineseDayOfWeek(int weekday) {
    const days = ['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日'];
    return days[weekday - 1];
  }
}