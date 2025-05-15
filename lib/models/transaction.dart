import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'category.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction {
  @HiveField(0)
  final String id; 

  @HiveField(1)
  final double amount; 

  @HiveField(2)
  final String currency;

  @HiveField(3)
  final Category category;

  @HiveField(4)
  final DateTime occurredAt;

  @HiveField(5)
  final String notes; 

  Transaction({
    String? id,
    required this.amount,
    required this.currency,
    required this.category,
    required this.occurredAt,
    this.notes = '',
  }) : id = id ?? const Uuid().v4();
}
