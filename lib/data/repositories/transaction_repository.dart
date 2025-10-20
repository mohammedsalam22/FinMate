import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocketsage/data/models/transaction.dart';

class TransactionRepository {
  final Box<FinTransaction> _box;
  final String userId;

  TransactionRepository(this._box, this.userId);

  List<FinTransaction> getAll() =>
      _box.values.where((t) => t.userId == userId).toList()
        ..sort((a, b) => b.date.compareTo(a.date));

  List<FinTransaction> getByDateRange(DateTime start, DateTime end) => _box
      .values
      .where((t) =>
          t.userId == userId && t.date.isAfter(start) && t.date.isBefore(end))
      .toList()
    ..sort((a, b) => b.date.compareTo(a.date));

  List<FinTransaction> getByType(TransactionType type) =>
      _box.values.where((t) => t.userId == userId && t.type == type).toList()
        ..sort((a, b) => b.date.compareTo(a.date));

  FinTransaction? getById(String id) => _box.get(id);

  Future<void> add(FinTransaction transaction) async {
    await _box.put(transaction.id, transaction);
  }

  Future<void> update(FinTransaction transaction) async {
    final updated = transaction.copyWith(updatedAt: DateTime.now().toUtc());
    await _box.put(updated.id, updated);
  }

  Future<void> delete(String id) async => await _box.delete(id);

  double getTotalIncome() => _box.values
      .where((t) => t.userId == userId && t.type == TransactionType.income)
      .fold(0.0, (sum, t) => sum + t.amount);

  double getTotalExpense() => _box.values
      .where((t) => t.userId == userId && t.type == TransactionType.expense)
      .fold(0.0, (sum, t) => sum + t.amount);

  double getBalance() => getTotalIncome() - getTotalExpense();

  Map<String, double> getExpensesByCategory() {
    final expenses = _box.values
        .where((t) => t.userId == userId && t.type == TransactionType.expense);
    final Map<String, double> categoryTotals = {};

    for (var transaction in expenses) {
      categoryTotals[transaction.categoryId] =
          (categoryTotals[transaction.categoryId] ?? 0) + transaction.amount;
    }

    return categoryTotals;
  }
}
