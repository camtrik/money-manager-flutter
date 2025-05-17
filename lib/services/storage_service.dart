import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager/models/category.dart';
import 'package:money_manager/models/icon_data_adapter.dart';
import 'package:money_manager/models/settings.dart';
import 'package:money_manager/models/transaction.dart';

class StorageService {
  Future<void> init() async {
    await Hive.initFlutter();

    // await Hive.deleteBoxFromDisk('categories');
    // await Hive.deleteBoxFromDisk('transactions');
    // await Hive.deleteBoxFromDisk('settings');

    Hive.registerAdapter(TransactionAdapter());
    Hive.registerAdapter(CategoryAdapter());
    Hive.registerAdapter(SettingsAdapter());
    Hive.registerAdapter(IconDataAdapter());

    await Hive.openBox<Transaction>('transactions');
    await Hive.openBox<Category>('categories');
    await Hive.openBox<Settings>('settings');

    await initDefaultCategories();
    // initialize settings
    final settingsBox = Hive.box<Settings>('settings');
    if (settingsBox.isEmpty) {
      settingsBox.add(Settings());
    }
  }

  // Transaction CRUD
  Box<Transaction> get txBox => Hive.box<Transaction>('transactions');

  Future<void> addTx(Transaction tx) => txBox.add(tx);

  List<Transaction> getAllTx() => txBox.values.toList();

  Future<void> deleteTx(int idx) => txBox.deleteAt(idx);

  Future<void> updateTx(int idx, Transaction tx) => txBox.putAt(idx, tx);

  Future<void> deleteTxByCategory(String categoryId) async {
    List<int> indicesToDelete = [];

    for (int i = 0; i < txBox.length; i++) {
      final tx = txBox.getAt(i);
      if (tx != null && tx.category.id == categoryId) {
        indicesToDelete.add(i);
      }
    }

    // delete from back to front, avoid index change 
    for (int i = indicesToDelete.length - 1; i >= 0; i--) {
      await txBox.deleteAt(indicesToDelete[i]);
    }
  }

  // Category CRUD 
  Box<Category> get categoryBox => Hive.box<Category>('categories');

  Future<void> addCategory(Category c) => categoryBox.add(c);

  List<Category> getAllCategories() => categoryBox.values.toList();

  Future<void> deleteCategory(int idx) => categoryBox.deleteAt(idx);

  Future<void> updateCategory(int idx, Category c) => categoryBox.putAt(idx, c);

  Future<void> initDefaultCategories() async {
    final categoryBox = Hive.box<Category>('categories');
    if (categoryBox.isEmpty) {
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

      for (var c in defaults) {
        await addCategory(c);
      }
    }
  }

  // Settings 
  Box<Settings> get settingsBox => Hive.box<Settings>('settings');

  Settings getSettings() => settingsBox.getAt(0) ?? Settings();

  Future<void> updateSettings(Settings s) => settingsBox.putAt(0, s);

}
