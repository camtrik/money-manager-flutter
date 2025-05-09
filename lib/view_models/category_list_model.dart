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
      Category(id: 'dining',          name: 'Dining',        icon: '🍽️'),
      Category(id: 'transport',       name: 'Transport',     icon: '🚌'),
      Category(id: 'shopping',        name: 'Shopping',      icon: '🛍️'),
      Category(id: 'entertainment',   name: 'Entertainment', icon: '🎬'),
      Category(id: 'medical',         name: 'Medical',       icon: '💊'),
      Category(id: 'housing',         name: 'Housing',       icon: '🏠'),
      Category(id: 'communication',   name: 'Communication', icon: '📱'),
      Category(id: 'daily_necessities', name: 'Daily',        icon: '🧹'),
      Category(id: 'other',           name: 'Other',         icon: '🔖'),
    ];
  
    final existingIds = _all.map((c) => c.id).toSet();

    for (var c in defaults) {
      if (!existingIds.contains(c.id)) {
        await _storage.addCategory(c);
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