class DebtPayment {
  final String id;
  final double amount;
  final DateTime date;
  final String? notes;

  const DebtPayment({
    required this.id,
    required this.amount,
    required this.date,
    this.notes,
  });
}

enum DebtHistoryType {
  debtCreated,
  payment,
}

class DebtHistoryItem {
  final String id;
  final DebtHistoryType type;
  final double amount;
  final DateTime date;
  final String? notes;
  final double runningBalance;

  const DebtHistoryItem({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    this.notes,
    required this.runningBalance,
  });
}

class Debt {
  final String id;
  final String userId;
  final String debtorName;
  final double totalAmount;
  final String currency;
  final String categoryId;
  final DateTime? dueDate;
  final String? notes;
  final List<DebtPayment> payments;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Debt({
    required this.id,
    required this.userId,
    required this.debtorName,
    required this.totalAmount,
    this.currency = 'EUR',
    this.categoryId = 'uncategorized',
    this.dueDate,
    this.notes,
    this.payments = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  double get paidAmount => payments.fold(0.0, (sum, p) => sum + p.amount);
  double get remainingAmount =>
      (totalAmount - paidAmount).clamp(0.0, double.infinity);
  bool get isSettled => remainingAmount <= 0.00001;
  bool get isOverdue =>
      !isSettled && dueDate != null && DateTime.now().isAfter(dueDate!);

  Debt copyWith({
    String? id,
    String? userId,
    String? debtorName,
    double? totalAmount,
    String? currency,
    String? categoryId,
    DateTime? dueDate,
    String? notes,
    List<DebtPayment>? payments,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Debt(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      debtorName: debtorName ?? this.debtorName,
      totalAmount: totalAmount ?? this.totalAmount,
      currency: currency ?? this.currency,
      categoryId: categoryId ?? this.categoryId,
      dueDate: dueDate ?? this.dueDate,
      notes: notes ?? this.notes,
      payments: payments ?? this.payments,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
