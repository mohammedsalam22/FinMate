import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocketsage/data/models/debt.dart';

class DebtsRepository {
  final Box<Debt> _box;
  final String userId;

  DebtsRepository(this._box, this.userId);

  List<Debt> getAll() => _box.values.where((d) => d.userId == userId).toList()
    ..sort((a, b) =>
        (a.dueDate ?? DateTime(2100)).compareTo(b.dueDate ?? DateTime(2100)));

  List<Debt> getByCategory(String categoryId) => _box.values
      .where((d) => d.userId == userId && d.categoryId == categoryId)
      .toList()
    ..sort((a, b) => a.debtorName.compareTo(b.debtorName));

  List<Debt> getDebtsByPerson(String debtorName, String categoryId) =>
      _box.values
          .where((d) =>
              d.userId == userId &&
              d.debtorName == debtorName &&
              d.categoryId == categoryId)
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  Debt? getById(String id) => _box.get(id);

  List<DebtHistoryItem> getHistoryTimeline(String debtId) {
    final debt = getById(debtId);
    if (debt == null) return [];

    final historyItems = <DebtHistoryItem>[];

    // Add debt creation event
    historyItems.add(DebtHistoryItem(
      id: '${debt.id}_created',
      type: DebtHistoryType.debtCreated,
      amount: debt.totalAmount,
      date: debt.createdAt,
      notes: debt.notes,
      runningBalance: debt.totalAmount,
    ));

    // Add payment events
    double runningBalance = debt.totalAmount;
    for (final payment in debt.payments) {
      runningBalance -= payment.amount;
      historyItems.add(DebtHistoryItem(
        id: payment.id,
        type: DebtHistoryType.payment,
        amount: payment.amount,
        date: payment.date,
        notes: payment.notes,
        runningBalance: runningBalance,
      ));
    }

    // Sort by date (newest first for timeline)
    historyItems.sort((a, b) => b.date.compareTo(a.date));
    return historyItems;
  }

  Future<void> add(Debt debt) async {
    await _box.put(debt.id, debt);
  }

  Future<void> update(Debt debt) async {
    final updated = debt.copyWith(updatedAt: DateTime.now().toUtc());
    await _box.put(updated.id, updated);
  }

  Future<void> delete(String id) async => await _box.delete(id);

  Future<void> deleteDebtsByPerson(String debtorName, String categoryId) async {
    final debtsToDelete = _box.values
        .where((d) =>
            d.userId == userId &&
            d.debtorName == debtorName &&
            d.categoryId == categoryId)
        .toList();

    for (final debt in debtsToDelete) {
      await _box.delete(debt.id);
    }
  }

  // Payments
  Future<void> addPayment(String debtId, DebtPayment payment) async {
    final debt = _box.get(debtId);
    if (debt == null) return;
    final updatedPayments = List<DebtPayment>.from(debt.payments)..add(payment);
    final updated = debt.copyWith(
        payments: updatedPayments, updatedAt: DateTime.now().toUtc());
    await _box.put(debt.id, updated);
  }

  Future<void> removePayment(String debtId, String paymentId) async {
    final debt = _box.get(debtId);
    if (debt == null) return;
    final updatedPayments = List<DebtPayment>.from(debt.payments)
      ..removeWhere((p) => p.id == paymentId);
    final updated = debt.copyWith(
        payments: updatedPayments, updatedAt: DateTime.now().toUtc());
    await _box.put(debt.id, updated);
  }

  double getTotalOwed() => _box.values
      .where((d) => d.userId == userId)
      .fold(0.0, (sum, d) => sum + d.totalAmount);

  double getTotalPaid() => _box.values
      .where((d) => d.userId == userId)
      .fold(0.0, (sum, d) => sum + d.paidAmount);

  double getTotalRemaining() => _box.values
      .where((d) => d.userId == userId)
      .fold(0.0, (sum, d) => sum + d.remainingAmount);
}
