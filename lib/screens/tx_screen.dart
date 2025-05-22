// lib/screens/tx_screen.dart
import 'package:flutter/material.dart';
import 'package:money_manager/l10n/gen/app_localizations.dart';
import 'package:money_manager/widgets/edit_tx_sheet.dart';
import 'package:money_manager/widgets/manage_tx_sheet.dart';
import 'package:money_manager/utils/category_utils.dart';
import 'package:money_manager/utils/currency_formatter.dart';
import 'package:money_manager/utils/date_formatter.dart';
import 'package:money_manager/view_models/category_list_model.dart';
import 'package:money_manager/view_models/date_range_model.dart';
import 'package:money_manager/widgets/date_range_selector.dart';
import 'package:money_manager/widgets/smooth_swipeable_content_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:money_manager/view_models/tx_list_model.dart';
import 'package:money_manager/models/transaction.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
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
          
          // 使用SmoothSwipeableContent替代SwipeableContentWrapper
          Expanded(
            child: SmoothSwipeableContent(
              contentBuilder: (context, dateRange) {
                final txListModel = context.watch<TxListModel>();
                
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

                return filteredTransactions.isEmpty
                  ? Center(child: Text(l10n.noTransactions))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                            // Transactions for this date with improved styling
                            ...transactions.asMap().entries.map((entry) {
                              final txIndex = entry.key;
                              final tx = entry.value;
                              final isLast = txIndex == transactions.length - 1;
                              return _buildTransactionItem(context, tx, txListModel, isLast);
                            }),
                            // Add spacing between date groups
                            const SizedBox(height: 16),
                          ],
                        );
                      },
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
              category: context.read<CategoryListModel>().getById("other")!,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDateHeader(BuildContext context, String dateKey, double total) {
    final date = DateFormatter.parseDateKey(dateKey);
    final dayOfWeek = DateFormatter.getDayOfWeek(context, dateKey);
    final monthYear = DateFormatter.formatMonthYear(context, date);    
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 12),
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

  Widget _buildTransactionItem(BuildContext context, Transaction tx, TxListModel txListModel, bool isLast) {
    final categoryColor = Color(tx.category.colorValue);
    
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
      decoration: BoxDecoration(
        // 使用分类颜色的深浅变化，从深到浅的自然渐变
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            categoryColor.withOpacity(0.8), // 左侧较深
            categoryColor.withOpacity(0.7), // 左中过渡
            categoryColor.withOpacity(0.6), // 右中过渡
            categoryColor.withOpacity(0.5), // 右侧最浅
          ],
          stops: const [0.0, 0.3, 0.6, 1.0],
        ),
        borderRadius: BorderRadius.circular(16),
        // 使用分类颜色的阴影
        boxShadow: [
          BoxShadow(
            color: categoryColor.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
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
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // 白色图标，在深色背景上清晰显示
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    tx.category.icon,
                    color: Colors.white, // 白色图标在深色背景上
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                // 白色文字，在渐变背景上清晰可读
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        CategoryUtils.getLocalizedName(context, tx.category.id, tx.category.name),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      if (tx.notes.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          tx.notes,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9), // 稍微透明的白色
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                // 金额直接显示，无额外背景框
                Text(
                  CurrencyFormatter.format(tx.amount, currency: tx.currency),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white, // 白色金额文字
                    letterSpacing: 0.5, // 增加字符间距让数字更清晰
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}