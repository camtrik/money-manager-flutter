import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:money_manager/view_models/tx_list_model.dart';
import 'package:money_manager/models/transaction.dart';
import 'package:money_manager/screens/add_tx_screen.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  // 把 DateTime 转成 "YYYY/MM/DD"
  String _formatDate(DateTime date) {
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '${date.year}/$m/$d';
  }

  @override
  Widget build(BuildContext context) {
    // 订阅 TxListModel，数据变化时自动重建
    final txListModel = context.watch<TxListModel>();
    final List<Transaction> txs = txListModel.all;

    return Scaffold(
      appBar: AppBar(title: const Text('记账应用')),
      body:
          txs.isEmpty
              ? const Center(child: Text('暂无交易记录'))
              : ListView.builder(
                itemCount: txs.length,
                itemBuilder: (ctx, index) {
                  final tx = txs[index];
                  return ListTile(
                    leading: Text(tx.category.icon),
                    title: Text(
                      '${tx.amount.toStringAsFixed(2)} ${tx.currency}',
                    ),
                    subtitle: Text(
                      '${tx.category.name} · ${_formatDate(tx.occurredAt)}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        // 按索引删除
                        txListModel.remove(index);
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text('已删除交易')));
                      },
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const AddTxScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
