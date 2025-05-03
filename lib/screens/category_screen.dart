import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/models/category.dart';
import 'package:money_manager/models/transaction.dart';
import 'package:money_manager/view_models/tx_list_model.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Transaction> txs = context.watch<TxListModel>().all;

    final Map<String, double> sums = {};
    final Map<String, Category> cats = {};

    for (var tx in txs) {
      final id = tx.category.id;
      cats[id] = tx.category;
      sums[id] = (sums[id] ?? 0) + tx.amount;
    }

    final List<PieChartSectionData> sections = [];
    int i = 0;
    sums.forEach((id, total) {
      final c = cats[id]!;
      // 不同分类用不同颜色
      final color = Colors.primaries[i % Colors.primaries.length];
      sections.add(PieChartSectionData(
        value: total,
        color: color,
        title: '¥${total.toStringAsFixed(0)}',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
      ));
      i++;
    });

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          // 总支出
          Text(
            '本月支出：¥${sums.values.fold(0.0, (a, b) => a + b).toStringAsFixed(0)}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // 分类图标网格
          Wrap(
            spacing: 24,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: cats.values.map((c) {
              final total = sums[c.id] ?? 0;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey.shade200,
                    child: Text(
                      c.icon, // 如果是 Emoji
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(c.name),
                  Text(
                    '¥${total.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: total > 0 ? Colors.red : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // 环形饼图
          Expanded(
            child: PieChart(
              PieChartData(
                sections: sections,
                centerSpaceRadius: 40,
                sectionsSpace: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}