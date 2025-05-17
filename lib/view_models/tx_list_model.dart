import 'package:flutter/material.dart';
import 'package:money_manager/models/transaction.dart';
import 'package:money_manager/services/storage_service.dart';

class TxListModel extends ChangeNotifier {
  final StorageService _storage; 
  // current list of transactions
  List<Transaction> _all = [];

  List<Transaction> get all => _all;

  TxListModel(this._storage) {
    _all = _storage.getAllTx();
  }

  // add a new tx and send notification
  void add(Transaction tx) {
    _storage.addTx(tx).then((_) {
      _all = _storage.getAllTx();
      notifyListeners();
    });
  }

  Future<void> remove(int idx) async {
    await _storage.deleteTx(idx);
    _all = _storage.getAllTx();
    notifyListeners();
  }

  Future<void> removeByCategory(String categoryId) async {
    await _storage.deleteTxByCategory(categoryId);
    _all = _storage.getAllTx();
    notifyListeners();
  }

  Future<void> update(Transaction updatedTx) async {
    int idx = _all.indexWhere((tx) => tx.id == updatedTx.id);
    if (idx != -1) {
      await _storage.updateTx(idx, updatedTx);
      _all[idx] = updatedTx;
      notifyListeners();
    }
  }
}
