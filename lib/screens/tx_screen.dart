import 'package:flutter/material.dart';
import 'package:money_manager/l10n/gen/app_localizations.dart';
import 'package:money_manager/screens/edit_tx_sheet.dart';
import 'package:money_manager/screens/manage_tx_sheet.dart';
import 'package:money_manager/utils/category_utils.dart';
import 'package:money_manager/utils/currency_formatter.dart';
import 'package:money_manager/utils/date_formatter.dart';
import 'package:money_manager/view_models/category_list_model.dart';
import 'package:money_manager/view_models/date_range_model.dart';
import 'package:money_manager/widgets/date_range_selector.dart';
import 'package:provider/provider.dart';
import 'package:money_manager/view_models/tx_list_model.dart';
import 'package:money_manager/models/transaction.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final txListModel = context.watch<TxListModel>();
    final dateRange = context.watch<DateRangeModel>(); // 获取日期范围
    
    // 使用日期范围过滤交易记录
    final List<Transaction> filteredTransactions = txListModel.getFilteredByDateRange(dateRange);
    final defaultCategory = context.read<CategoryListModel>().getById("other")!;

    // Group transactions by date
    final Map<String, List<Transaction>> groupedTransactions = {};
    final Map<String, double> dailyTotals = {};

    for (var tx in filteredTransactions) {
      final dateKey = DateFormatter.formatDateKey(tx.occurredAt);
      if (!groupedTransactions.containsKey(dateKey)) {
        groupedTransactions[dateKey] = [];
        dailyTotals[dateKey] = 0;
      }
      groupedTransactions[dateKey]!.add(tx);
      dailyTotals[dateKey] = (dailyTotals[dateKey] ?? 0) + tx.amount;
    }

    // Sort dates in descending order (newest first)
    final sortedDates = groupedTransactions.keys.toList()
      ..sort((a, b) => DateFormatter.parseDateKey(b).compareTo(DateFormatter.parseDateKey(a)));

    return Scaffold(
      body: Column(
        children: [
          // data range selector 
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Center(
              child: DateRangeSelector(),
            ),
          ),
          
          // transaction list 
          Expanded(
            child: filteredTransactions.isEmpty
                ? Center(child: Text(l10n.noTransactions))
                : ListView.builder(
                    itemCount: sortedDates.length,
                    itemBuilder: (context, index) {
                      final dateKey = sortedDates[index];
                      final transactions = groupedTransactions[dateKey]!;
                      final total = dailyTotals[dateKey] ?? 0.0;
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date header with total
                          _buildDateHeader(context, dateKey, total),
                          // Transactions for this date
                          ...transactions.map((tx) => _buildTransactionItem(context, tx, txListModel)),
                          // Add a divider between date groups
                          const Divider(height: 1, thickness: 1, indent: 0, endIndent: 0),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => EditTransactionSheet(
              category: defaultCategory,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDateHeader(BuildContext context, String dateKey, double total) {
    final date = DateFormatter.parseDateKey(dateKey);
    // final locale = Localizations.localeOf(context).languageCode;
    final dayOfWeek = DateFormatter.getDayOfWeek(context, dateKey);
    final monthYear = DateFormatter.formatMonthYear(context, date);    
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${date.day}",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dayOfWeek,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    monthYear,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          // Total amount for this date
          Text(
            CurrencyFormatter.format(total, currency: 'CNY'),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.pink[300],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, Transaction tx, TxListModel txListModel) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => ManageTransactionSheet(tx: tx),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        
        child: Row(
          children: [
            // Category icon
            CircleAvatar(
              radius: 24,
              backgroundColor: Color(tx.category.colorValue),
              child: Icon(
                tx.category.icon,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            // Category name and notes
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    CategoryUtils.getLocalizedName(context, tx.category.id, tx.category.name),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (tx.notes.isNotEmpty)
                    Text(
                      tx.notes,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            // Amount
            Text(
              CurrencyFormatter.format(tx.amount, currency: tx.currency),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.pink[300],
              ),
            ),
          ],
        ),
      ),
    );
  }
}