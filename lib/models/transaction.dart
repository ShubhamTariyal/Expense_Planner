import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction {
  @HiveField(0)
  final double amount;
  @HiveField(1)
  final String id;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final DateTime date;

  Transaction({
    @required this.amount,
    @required this.id,
    @required this.title,
    @required this.date,
  });
}
