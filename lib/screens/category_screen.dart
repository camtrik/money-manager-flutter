import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/l10n/gen/app_localizations.dart';
import 'package:money_manager/models/category.dart';
import 'package:money_manager/models/transaction.dart';
import 'package:money_manager/screens/add_tx_sheet.dart';
import 'package:money_manager/screens/settings_screen.dart';
import 'package:money_manager/utils/category_utils.dart';
import 'package:money_manager/view_models/category_list_model.dart';
import 'package:money_manager/view_models/tx_list_model.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final l10n = AppLocalizations.of(context)!;
    final List<Transaction> txs = context.watch<TxListModel>().all;

    final Map<String, double> sums = {};
    final List<Category> categories = context.watch<CategoryListModel>().all;

    for (var c in categories) {
      sums[c.id] = 0.0;
    }

    for (var tx in txs) {
      final id = tx.category.id;
      sums[id] = (sums[id] ?? 0) + tx.amount;
    }

    final List<PieChartSectionData> sections = [];

    for (var c in categories) {
      final total = sums[c.id] ?? 0;

      sections.add(PieChartSectionData(
        color: Color(c.colorValue),
        value: total,
        radius: 20,
        showTitle: false, 
      ));
    }

    final totalExpense = sums.values.fold(0.0, (a, b) => a + b);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),

          Wrap(
            spacing: 24,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: categories.map((c) {
              final total = sums[c.id] ?? 0;
              return GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context, 
                    isScrollControlled: true, 
                    backgroundColor: Colors.transparent, 
                    builder: (context) => AddTransactionSheet(category: c),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Color(c.colorValue).withValues(alpha: 0.5),
                      child: Icon(
                        c.icon,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(CategoryUtils.getLocalizedName(context, c.id, c.name)),
                    Text(
                      '¥${total.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: Color(c.colorValue),
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                    ],
                  ),
                );
              }).toList(),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: 
            sections.isEmpty
                ? Center(
                    child: Text(
                      l10n.noTransactions,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        sections: sections,
                        centerSpaceRadius: 100,
                        sectionsSpace: 2,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.totalExpense,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          '¥${totalExpense.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
          ),
        ],
      ),
    );
  }
}