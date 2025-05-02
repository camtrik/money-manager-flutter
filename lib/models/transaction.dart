import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction {
  @HiveField(0)
  final String id;

  @HiveField(1)
  double amount;

  @HiveField(2)
  bool isExpense;

  @HiveField(3)
  String category;

  @HiveField(4)
  DateTime date;

  @HiveField(5)
  String? note;

  Transaction({
    String? id,
    required this.amount,
    required this.isExpense,
    required this.category,
    required this.date,
    this.note,
  }) : this.id = id ?? const Uuid().v4();

  // + or - depending on expense or income
  String get sign => isExpense ? '-' : '+';
}
