import 'package:flutter/material.dart';
import 'package:money_manager/models/category.dart';
import 'package:money_manager/services/storage_service.dart';

class CategoryListModel extends ChangeNotifier {
  final _storage = StorageService();

  List<Category> _all = [];

  List<Category> get all => _all;

  CategoryListModel() {
    print('🚀 CategoryListModel constructor called');

    _init();
  }

  Future<void> _init() async {
    _all = _storage.getAllCategories();

    final defaults = <Category>[
      Category(id: 'dining',          name: 'Dining',        icon: Icons.restaurant, colorValue: Colors.orange.toARGB32()),
      Category(id: 'transport',       name: 'Transport',     icon: Icons.directions_bus, colorValue: Colors.blue.toARGB32()),
      Category(id: 'shopping',        name: 'Shopping',      icon: Icons.shopping_cart, colorValue: Colors.lime.toARGB32()),
      Category(id: 'entertainment',   name: 'Entertainment', icon: Icons.movie, colorValue: Colors.purple.toARGB32()),
      Category(id: 'clothing',        name: 'Clothing',      icon: Icons.shopping_bag, colorValue: Colors.blueGrey.toARGB32()),
      Category(id: 'medical',         name: 'Medical',       icon: Icons.local_hospital, colorValue: Colors.red.toARGB32()),
      Category(id: 'housing',         name: 'Housing',       icon: Icons.house, colorValue: Colors.brown.toARGB32()),
      Category(id: 'communication',   name: 'Communication', icon: Icons.phone, colorValue: Colors.teal.toARGB32()),
      Category(id: 'daily_necessities', name: 'Daily',        icon: Icons.cleaning_services, colorValue: Colors.green.toARGB32()),
      Category(id: 'gift',            name: 'Gift',          icon: Icons.card_giftcard, colorValue: Colors.pink.toARGB32()),
      Category(id: 'other',           name: 'Other',         icon: Icons.extension, colorValue: Colors.grey.toARGB32()),
    ];
  
    final existingIds = _all.map((c) => c.id).toSet();

    for (var c in defaults) {
      if (!existingIds.contains(c.id)) {
        await _storage.addCategory(c);
        print('🚀 Category added: ${c.name}');
      } else {
        print('🚀 Category already exists: ${c.name}');
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

  Category? getById(String id) {
    try {
      return _all.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
}