import 'package:flutter/material.dart';
import 'package:money_manager/models/transaction.dart';
import 'package:money_manager/services/storage_service.dart';

class TxListModel extends ChangeNotifier {
  final _storage = StorageService();
  // current list of transactions
  List<Transaction> _all = [];

  List<Transaction> get all => _all;

  TxListModel() {
    _all = _storage.getAllTx();
  }

  // add a new tx and send notification
  void add(Transaction tx) {
    _storage.addTx(tx).then((_) {
      _all = _storage.getAllTx();
      notifyListeners();
    });
  }

  void remove(int idx) {
    _storage.deleteTx(idx).then((_) {
      _all = _storage.getAllTx();
      notifyListeners();
    });
  }
}
