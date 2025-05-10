import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/models/category.dart';
import 'package:money_manager/models/transaction.dart';
import 'package:money_manager/view_models/category_list_model.dart';
import 'package:money_manager/view_models/tx_list_model.dart';
import 'package:provider/provider.dart';
import 'package:money_manager/l10n/gen/app_localizations.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final List<Transaction> txs = context.watch<TxListModel>().all;
    final List<Category> categories = context.watch<CategoryListModel>().all;

    // Calculate sums for each category
    final Map<String, double> sums = {};
    for (var category in categories) {
      sums[category.id] = 0;
    }
    
    for (var tx in txs) {
      final id = tx.category.id;
      sums[id] = (sums[id] ?? 0) + tx.amount;
    }

    // Calculate total expense
    final double totalExpense = sums.values.fold(0.0, (a, b) => a + b);

    // Create pie chart sections only for categories with expenses
    final List<PieChartSectionData> sections = [];
    final categoryModel = context.watch<CategoryListModel>();
    
    for (var category in categories) {
      final total = sums[category.id] ?? 0;
      if (total > 0) {
        sections.add(PieChartSectionData(
          value: total,
          color: Color(category.colorValue),  // 从 category 直接获取颜色值
          title: '¥${total.toStringAsFixed(0)}',
          radius: 50,
          titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
        ));
      }
    }

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Text(
            l10n.totalExpense(totalExpense.toStringAsFixed(0)),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Category grid
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
                    builder: (context) => QuickAddTransactionBottomSheet(category: c),
                  );
                },
                // onLongPress: () {
                //   // 长按编辑分类
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => EditCategoryScreen(category: c),
                //     ),
                //   );
                // },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Color(c.colorValue).withOpacity(0.2),  // 使用分类颜色的浅色版本
                      child: Text(
                        c.icon,
                        style: TextStyle(fontSize: 24, color: Color(c.colorValue)),  // 使用分类颜色
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(c.name, style: const TextStyle(fontSize: 12)),
                    Text(
                      '¥${total.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: total > 0 ? Colors.red : Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Pie chart (show placeholder if no data)
          Expanded(
            child: sections.isEmpty
                ? const Center(
                    child: Text(
                      '暂无支出数据',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : PieChart(
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

// Bottom sheet for quick transaction entry with calculator
class QuickAddTransactionBottomSheet extends StatefulWidget {
  final Category category;

  const QuickAddTransactionBottomSheet({Key? key, required this.category}) : super(key: key);

  @override
  State<QuickAddTransactionBottomSheet> createState() => _QuickAddTransactionBottomSheetState();
}

class _QuickAddTransactionBottomSheetState extends State<QuickAddTransactionBottomSheet> {
  String _amount = '0';
  String _currency = 'CNY';
  DateTime _date = DateTime.now();
  
  void _onNumberPressed(String value) {
    setState(() {
      if (_amount == '0') {
        _amount = value;
      } else {
        _amount += value;
      }
    });
  }

  void _onDecimalPressed() {
    setState(() {
      if (!_amount.contains('.')) {
        _amount += '.';
      }
    });
  }

  void _onClearPressed() {
    setState(() {
      _amount = '0';
    });
  }

  void _onDeletePressed() {
    setState(() {
      if (_amount.length > 1) {
        _amount = _amount.substring(0, _amount.length - 1);
      } else {
        _amount = '0';
      }
    });
  }

  void _saveTransaction() {
    final amount = double.tryParse(_amount) ?? 0.0;
    if (amount > 0) {
      final transaction = Transaction(
        amount: amount,
        currency: _currency,
        category: widget.category,
        occurredAt: _date,
      );
      context.read<TxListModel>().add(transaction);
      Navigator.pop(context);
    }
  }

  void _showDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _date = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header with category type and from account
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Color(widget.category.colorValue),  // 使用分类的颜色
                        child: Text(
                          widget.category.icon,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.category.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Text(l10n.category),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Amount display
          Text(
            '支出',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            '¥ $_amount',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 16),

          // Remark field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: '备注...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Calculator buttons
          Expanded(
            child: Column(
              children: [
                // First row: operators
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildOperatorButton('÷'),
                    _buildCalculatorButton('7', onPressed: () => _onNumberPressed('7')),
                    _buildCalculatorButton('8', onPressed: () => _onNumberPressed('8')),
                    _buildCalculatorButton('9', onPressed: () => _onNumberPressed('9')),
                    _buildBackspaceButton(),
                  ],
                ),
                // Second row: operators
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildOperatorButton('×'),
                    _buildCalculatorButton('4', onPressed: () => _onNumberPressed('4')),
                    _buildCalculatorButton('5', onPressed: () => _onNumberPressed('5')),
                    _buildCalculatorButton('6', onPressed: () => _onNumberPressed('6')),
                    _buildDateButton(),
                  ],
                ),
                // Third row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildOperatorButton('-'),
                    _buildCalculatorButton('1', onPressed: () => _onNumberPressed('1')),
                    _buildCalculatorButton('2', onPressed: () => _onNumberPressed('2')),
                    _buildCalculatorButton('3', onPressed: () => _onNumberPressed('3')),
                    Container(
                      width: 60,
                      height: 60,
                      margin: const EdgeInsets.all(4),
                      child: ElevatedButton(
                        onPressed: _saveTransaction,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: const Icon(Icons.check, color: Colors.white, size: 28),
                      ),
                    ),
                  ],
                ),
                // Fourth row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildOperatorButton('+'),
                    _buildCalculatorButton('0', onPressed: () => _onNumberPressed('0')),
                    _buildCalculatorButton('.', onPressed: _onDecimalPressed),
                    _buildCalculatorButton('¥', onPressed: () {}),
                    SizedBox(width: 68),
                  ],
                ),
              ],
            ),
          ),

          // Date display at bottom
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '今天，${_date.year}年${_date.month}月${_date.day}日',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculatorButton(String label, {required VoidCallback onPressed}) {
    return Container(
      width: 60,
      height: 60,
      margin: const EdgeInsets.all(4),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade100,
          foregroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
          padding: EdgeInsets.zero,
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  Widget _buildOperatorButton(String operator) {
    return Container(
      width: 60,
      height: 60,
      margin: const EdgeInsets.all(4),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade200,
          foregroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
          padding: EdgeInsets.zero,
        ),
        child: Text(
          operator,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  Widget _buildDateButton() {
    return Container(
      width: 60,
      height: 60,
      margin: const EdgeInsets.all(4),
      child: ElevatedButton(
        onPressed: _showDatePicker,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade100,
          foregroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
          padding: EdgeInsets.zero,
        ),
        child: const Icon(Icons.calendar_today, size: 24),
      ),
    );
  }

  Widget _buildBackspaceButton() {
    return Container(
      width: 60,
      height: 60,
      margin: const EdgeInsets.all(4),
      child: ElevatedButton(
        onPressed: _onDeletePressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade100,
          foregroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
          padding: EdgeInsets.zero,
        ),
        child: const Icon(Icons.backspace_outlined, size: 24),
      ),
    );
  }
}