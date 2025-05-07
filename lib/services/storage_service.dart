import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager/models/category.dart';
import 'package:money_manager/models/transaction.dart';

class StorageService {
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TransactionAdapter());
    Hive.registerAdapter(CategoryAdapter());

    await Hive.openBox<Transaction>('transactions');
    await Hive.openBox<Category>('categories');
  }

  // Transaction CRUD
  Box<Transaction> get txBox => Hive.box<Transaction>('transactions');

  Future<void> addTx(Transaction tx) => txBox.add(tx);

  List<Transaction> getAllTx() => txBox.values.toList();

  Future<void> deleteTx(int idx) => txBox.deleteAt(idx);

  // Category CRUD 
  Box<Category> get categoryBox => Hive.box<Category>('categories');

  Future<void> addCategory(Category c) => categoryBox.add(c);

  List<Category> getAllCategories() => categoryBox.values.toList();

  Future<void> deleteCategory(int idx) => categoryBox.deleteAt(idx);
}
