import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:money_manager/models/category.dart';
import 'package:money_manager/services/storage_service.dart';

class CategoryListModel extends ChangeNotifier {
  final _storage = StorageService();

  List<Category> _all = [];

  List<Category> get all => _all;

  CategoryListModel() {
    _init();
  }

  Future<void> _init() async {
    _all = _storage.getAllCategories();

    final defaults = <Category>[
      Category(id: 'dining',          name: 'Dining',        icon: '🍽️', colorValue: Colors.orange.toARGB32()),
      Category(id: 'transport',       name: 'Transport',     icon: '🚌', colorValue: Colors.pinkAccent.toARGB32()),
      Category(id: 'shopping',        name: 'Shopping',      icon: '🛍️', colorValue: Colors.lime.toARGB32()),
      Category(id: 'entertainment',   name: 'Entertainment', icon: '🎬', colorValue: Colors.purple.toARGB32()),
      Category(id: 'medical',         name: 'Medical',       icon: '💊', colorValue: Colors.red.toARGB32()),
      Category(id: 'housing',         name: 'Housing',       icon: '🏠', colorValue: Colors.brown.toARGB32()),
      Category(id: 'communication',   name: 'Communication', icon: '📱', colorValue: Colors.teal.toARGB32()),
      Category(id: 'daily_necessities', name: 'Daily',        icon: '🧹', colorValue: Colors.green.toARGB32()),
      Category(id: 'other',           name: 'Other',         icon: '🔖', colorValue: Colors.grey.toARGB32()),
    ];
  
    final existingIds = _all.map((c) => c.id).toSet();

    for (var c in defaults) {
      if (!existingIds.contains(c.id)) {
        await _storage.addCategory(c);
        log('added category name: ${c.name}');
        log('added category color: ${c.colorValue}');
      }
    }

    _all = _storage.getAllCategories();
    notifyListeners();
  }


  void add(Category c) {
    _storage.addCategory(c).then((_) {
      _all = _storage.getAllCategories();
      notifyListeners();
    });
  }

  void remove(int idx) {
    _storage.deleteCategory(idx).then((_) {
      _all = _storage.getAllCategories();
      notifyListeners();
    });
  }
}