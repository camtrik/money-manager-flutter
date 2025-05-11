// lib/utils/category_utils.dart

import 'package:flutter/material.dart';
import 'package:money_manager/l10n/gen/app_localizations.dart';

class CategoryUtils {
  // get the localized name for defailt categories
  static String getLocalizedName(BuildContext context, String categoryId, String categoryName) {
    final l10n = AppLocalizations.of(context)!;

    switch (categoryId) {
      case 'dining':
        return l10n.categoryDining;
      case 'transport':
        return l10n.categoryTransport;
      case 'shopping':
        return l10n.categoryShopping;
      case 'entertainment':
        return l10n.categoryEntertainment;
      case 'medical':
        return l10n.categoryMedical;
      case 'housing':
        return l10n.categoryHousing;
      case 'communication':
        return l10n.categoryCommunication;
      case 'daily_necessities':
        return l10n.categoryDaily;
      case 'other':
        return l10n.categoryOther;
      default:
        return categoryName; // Fallback to ID if no translation found
    }
  }
}