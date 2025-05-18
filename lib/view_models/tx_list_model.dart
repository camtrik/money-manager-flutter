import 'package:flutter/material.dart';
import 'package:money_manager/models/transaction.dart';
import 'package:money_manager/services/storage_service.dart';
import 'package:money_manager/view_models/date_range_model.dart';

class TxListModel extends ChangeNotifier {
  final StorageService _storage; 
  // current list of transactions
  List<Transaction> _all = [];

  // 获取所有交易记录
  List<Transaction> get all => _all;
  
  // 根据日期范围过滤交易记录
  List<Transaction> getFilteredByDateRange(DateRangeModel dateRange) {
    return _all.where((tx) => 
      tx.occurredAt.isAtSameMomentAs(dateRange.startDate) || 
      tx.occurredAt.isAtSameMomentAs(dateRange.endDate) || 
      (tx.occurredAt.isAfter(dateRange.startDate) && 
       tx.occurredAt.isBefore(dateRange.endDate))
    ).toList();
  }

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

  Future<void> remove(String txId) async {
    int idx = _all.indexWhere((tx) => tx.id == txId);
    if (idx != -1) {
      await _storage.deleteTx(idx);
      _all = _storage.getAllTx();
      notifyListeners();
    }
  }

  Future<void> removeByIdx(int idx) async {
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
