// lib/utils/category_utils.dart

import 'package:flutter/material.dart';

class CategoryUtils {
  static final Map<String, Color> _categoryColors = {
    'Dining': Colors.purple[100]!,
    'Transport': Colors.pink[100]!,
    'Shopping': Colors.orange[100]!,
    'Entertainment': Colors.blue[100]!,
    'Medical': Colors.red[100]!,
    'Housing': Colors.green[100]!,
    'Communication': Colors.cyan[100]!,
    'Daily': Colors.teal[100]!,
    'Other': Colors.grey[100]!,
    // Add more categories as needed
  };

  static final Map<String, IconData> _categoryIcons = {
    'Dining': Icons.restaurant,
    'Transport': Icons.directions_bus,
    'Shopping': Icons.shopping_bag,
    'Entertainment': Icons.movie,
    'Medical': Icons.local_hospital,
    'Housing': Icons.home,
    'Communication': Icons.phone,
    'Daily': Icons.cleaning_services,
    'Other': Icons.more_horiz,
  };

  static Color getColorForCategory(String categoryName) {
    return _categoryColors[categoryName] ?? Colors.grey[100]!;
  }

  static IconData getIconForCategory(String categoryName) {
    return _categoryIcons[categoryName] ?? Icons.category;
  }

  // Get color by category ID (if you use IDs instead of names)
  static Color getColorByCategoryId(String categoryId) {
    final colorMap = {
      'dining': Colors.purple[100]!,
      'transport': Colors.pink[100]!,
      'shopping': Colors.orange[100]!,
      'entertainment': Colors.blue[100]!,
      'medical': Colors.red[100]!,
      'housing': Colors.green[100]!,
      'communication': Colors.cyan[100]!,
      'daily_necessities': Colors.teal[100]!,
      'other': Colors.grey[100]!,
    };
    
    return colorMap[categoryId] ?? Colors.grey[100]!;
  }

  // Generate a consistent color based on category name (for dynamic categories)
  static Color generateColorForCategory(String categoryName) {
    final hash = categoryName.hashCode;
    final hue = (hash % 360).toDouble();
    return HSLColor.fromAHSL(1.0, hue, 0.5, 0.8).toColor();
  }
}