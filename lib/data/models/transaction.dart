import 'package:hive/hive.dart';

part 'transaction.g.dart';

enum TransactionType {
  income,
  expense,
}

@HiveType(typeId: 2)
class FinTransaction {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final String currency;

  @HiveField(4)
  final TransactionType type;

  @HiveField(5)
  final String categoryId;

  @HiveField(6)
  final DateTime date;

  @HiveField(7)
  final String? notes;

  @HiveField(8)
  final DateTime createdAt;

  @HiveField(9)
  final DateTime updatedAt;

  FinTransaction({
    required this.id,
    required this.userId,
    required this.amount,
    this.currency = 'EUR',
    required this.type,
    required this.categoryId,
    required this.date,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  FinTransaction copyWith({
    String? id,
    String? userId,
    double? amount,
    String? currency,
    TransactionType? type,
    String? categoryId,
    DateTime? date,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      FinTransaction(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        amount: amount ?? this.amount,
        currency: currency ?? this.currency,
        type: type ?? this.type,
        categoryId: categoryId ?? this.categoryId,
        date: date ?? this.date,
        notes: notes ?? this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}
