import 'package:flutter/material.dart';
import 'package:money_manager/view_models/category_list_model.dart';
import 'package:provider/provider.dart';
import 'package:money_manager/models/category.dart';
import 'package:money_manager/models/transaction.dart';
import 'package:money_manager/view_models/tx_list_model.dart';

class AddTxScreen extends StatefulWidget {
  final Category? initialCategory;
  const AddTxScreen({Key? key, this.initialCategory}) : super(key: key);

  @override
  State<AddTxScreen> createState() => _AddTxScreenState();
}

class _AddTxScreenState extends State<AddTxScreen> {
  final _amtCtrl = TextEditingController();
  String _currency = 'CNY';
  Category? _category;

  DateTime _date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<CategoryListModel>().all;

    // If categories not loaded yet, show a loader
    if (categories.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    _category ??= widget.initialCategory ?? categories.first;
    return Scaffold(
      appBar: AppBar(title: const Text('新增流水')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Input money
            TextField(
              controller: _amtCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '金额'),
            ),

            // select currency
            DropdownButton<String>(
              value: _currency,
              items:
                  ['CNY', 'JPY']
                      .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                      .toList(),
              onChanged: (v) => setState(() => _currency = v!),
            ),
   
            DropdownButton<Category>(
              value: _category,
              items:
                  categories
                      .map(
                        (c) => DropdownMenuItem(
                          value: c,
                          child: Text('${c.icon} ${c.name}'),
                        ),
                      )
                      .toList(),
              onChanged: (v) => setState(() => _category = v!),
            ),

            // 日期选择
            ElevatedButton(
              child: Text('${_date.year}/${_date.month}/${_date.day}'),
              onPressed: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (d != null) setState(() => _date = d);
              },
            ),

            const Spacer(),

            // 保存按钮
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(_amtCtrl.text) ?? 0.0;
                final tx = Transaction(
                  amount: amount,
                  currency: _currency,
                  category: _category!,
                  occurredAt: _date,
                );
                context.read<TxListModel>().add(tx);
                Navigator.pop(context);
              },
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }
}
