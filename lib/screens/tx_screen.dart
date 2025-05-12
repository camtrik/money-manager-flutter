import 'package:flutter/material.dart';
import 'package:money_manager/l10n/gen/app_localizations.dart';
import 'package:money_manager/screens/add_tx_sheet.dart';
import 'package:money_manager/utils/category_utils.dart';
import 'package:money_manager/view_models/category_list_model.dart';
import 'package:provider/provider.dart';
import 'package:money_manager/view_models/tx_list_model.dart';
import 'package:money_manager/models/transaction.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final txListModel = context.watch<TxListModel>();
    final List<Transaction> txs = txListModel.all;
    final defaultCategory = context.read<CategoryListModel>().getById("other")!;

    return Scaffold(
      body:
        txs.isEmpty
            ? Center(child: Text(l10n.noTransactions))
            : ListView.builder(
              itemCount: txs.length,
              itemBuilder: (ctx, index) {
                final tx = txs[index];
                return ListTile(
                  leading: Icon(tx.category.icon),
                  title: Text(
                    '${tx.amount.toStringAsFixed(2)} ${tx.currency}',
                  ),
                  subtitle: Text(
                    '${CategoryUtils.getLocalizedName(context, tx.category.id, tx.category.name)} · ${_formatDate(tx.occurredAt)}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      txListModel.remove(index);
                      ScaffoldMessenger.of(
                        context,
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,

            builder: (context) => AddTransactionSheet(
              category: defaultCategory,
            )
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
