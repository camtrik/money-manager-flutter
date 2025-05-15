import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager/models/category.dart';
import 'package:money_manager/models/icon_data_adapter.dart';
import 'package:money_manager/models/settings.dart';
import 'package:money_manager/models/transaction.dart';

class StorageService {
  static Future<void> init() async {
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

  // Settings 
  Box<Settings> get settingsBox => Hive.box<Settings>('settings');

  Settings getSettings() => settingsBox.getAt(0) ?? Settings();

  Future<void> updateSettings(Settings s) => settingsBox.putAt(0, s);

}
