// lib/utils/date_formatter.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime date, BuildContext context) {
    final locale = Localizations.localeOf(context);
    
    if (locale.languageCode == 'zh') {
      return DateFormat('yyyy年M月d日', 'zh').format(date);
    } else if (locale.languageCode == 'ja' || locale.languageCode == 'ja') {
      return DateFormat('yyyy年M月d日', 'ja').format(date);
    }
    return DateFormat('MMM d, yyyy', 'en').format(date);
  }
}