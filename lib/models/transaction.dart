import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'category.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction {
  @HiveField(0)
  final String id; // 唯一标识

  @HiveField(1)
  final double amount; // 金额

  @HiveField(2)
  final String currency; // 币种："CNY" 或 "JPY"

  @HiveField(3)
  final Category category; // 关联分类对象

  @HiveField(4)
  final DateTime occurredAt; // 发生时间

  Transaction({
    String? id,
    required this.amount,
    required this.currency,
    required this.category,
    required this.occurredAt,
  }) : id = id ?? const Uuid().v4();
}
