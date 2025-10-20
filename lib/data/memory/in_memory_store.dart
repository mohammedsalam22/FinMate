import 'package:flutter/material.dart';
import 'package:pocketsage/data/models/category.dart';
import 'package:pocketsage/data/models/transaction.dart';
import 'package:pocketsage/data/models/user.dart';
import 'package:uuid/uuid.dart';

/// Simple in-memory storage used only for web as a fallback when Hive fails.
/// Not persisted across reloads.
class InMemoryStore {
  InMemoryStore._internal();
  static final InMemoryStore instance = InMemoryStore._internal();

  final List<Category> _categories = [];
  final List<FinTransaction> _transactions = [];
  User? _user;

  User ensureUser() {
    _user ??= User(
      id: const Uuid().v4(),
      createdAt: DateTime.now().toUtc(),
    );
    return _user!;
  }

  void ensureDefaultCategories(String userId) {
    if (_categories.isNotEmpty) return;
    final uuid = Uuid();
    _categories.addAll([
      Category(
          id: uuid.v4(),
          userId: userId,
          name: 'Salary',
          icon: 'payments',
          color: 0xFF10B981,
          type: CategoryType.income),
      Category(
          id: uuid.v4(),
          userId: userId,
          name: 'Freelance',
          icon: 'work',
          color: 0xFF8B5CF6,
          type: CategoryType.income),
      Category(
          id: uuid.v4(),
          userId: userId,
          name: 'Groceries',
          icon: 'shopping_cart',
          color: 0xFFF59E0B,
          type: CategoryType.expense),
      Category(
          id: uuid.v4(),
          userId: userId,
          name: 'Transport',
          icon: 'directions_car',
          color: 0xFF3B82F6,
          type: CategoryType.expense),
      Category(
          id: uuid.v4(),
          userId: userId,
          name: 'Entertainment',
          icon: 'movie',
          color: 0xFFEC4899,
          type: CategoryType.expense),
      Category(
          id: uuid.v4(),
          userId: userId,
          name: 'Bills',
          icon: 'receipt_long',
          color: 0xFFEF4444,
          type: CategoryType.expense),
      Category(
          id: uuid.v4(),
          userId: userId,
          name: 'Healthcare',
          icon: 'local_hospital',
          color: 0xFF06B6D4,
          type: CategoryType.expense),
      Category(
          id: uuid.v4(),
          userId: userId,
          name: 'Dining',
          icon: 'restaurant',
          color: 0xFFF97316,
          type: CategoryType.expense),
    ]);
  }

  // Categories API
  List<Category> getAllCategories() => List.unmodifiable(_categories);
  Category? categoryById(String id) {
    try {
      return _categories.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  // Transactions API
  List<FinTransaction> allUserTransactions(String userId) {
    final items = _transactions.where((t) => t.userId == userId).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return items;
  }

  void putTransaction(FinTransaction tx) {
    final idx = _transactions.indexWhere((t) => t.id == tx.id);
    if (idx >= 0) {
      _transactions[idx] = tx;
    } else {
      _transactions.add(tx);
    }
  }

  void deleteTransaction(String id) {
    _transactions.removeWhere((t) => t.id == id);
  }
}

/// Memory implementation of repositories to match existing APIs
class CategoryRepositoryMemory {
  final String userId;
  CategoryRepositoryMemory(this.userId) {
    InMemoryStore.instance.ensureDefaultCategories(userId);
  }

  List<Category> getAll() => InMemoryStore.instance.getAllCategories();

  List<Category> getByType(CategoryType type) => InMemoryStore.instance
      .getAllCategories()
      .where((c) => c.type == type)
      .toList();

  Category? getById(String id) => InMemoryStore.instance.categoryById(id);

  // Keep same icon map behavior as Hive repository
  IconData getIconData(String iconName) => _iconMap[iconName] ?? Icons.category;
}

const Map<String, IconData> _iconMap = {
  'payments': Icons.payments,
  'work': Icons.work,
  'shopping_cart': Icons.shopping_cart,
  'directions_car': Icons.directions_car,
  'movie': Icons.movie,
  'receipt_long': Icons.receipt_long,
  'local_hospital': Icons.local_hospital,
  'restaurant': Icons.restaurant,
};

class TransactionRepositoryMemory {
  final String userId;
  TransactionRepositoryMemory(this.userId);

  List<FinTransaction> getAll() =>
      InMemoryStore.instance.allUserTransactions(userId);

  List<FinTransaction> getByDateRange(DateTime start, DateTime end) =>
      InMemoryStore.instance
          .allUserTransactions(userId)
          .where((t) => t.date.isAfter(start) && t.date.isBefore(end))
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));

  List<FinTransaction> getByType(TransactionType type) => InMemoryStore.instance
      .allUserTransactions(userId)
      .where((t) => t.type == type)
      .toList()
    ..sort((a, b) => b.date.compareTo(a.date));

  FinTransaction? getById(String id) {
    try {
      return InMemoryStore.instance
          .allUserTransactions(userId)
          .firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> add(FinTransaction transaction) async {
    InMemoryStore.instance.putTransaction(transaction);
  }

  Future<void> update(FinTransaction transaction) async {
    InMemoryStore.instance.putTransaction(transaction);
  }

  Future<void> delete(String id) async {
    InMemoryStore.instance.deleteTransaction(id);
  }

  double getTotalIncome() => InMemoryStore.instance
      .allUserTransactions(userId)
      .where((t) => t.type == TransactionType.income)
      .fold(0.0, (sum, t) => sum + t.amount);

  double getTotalExpense() => InMemoryStore.instance
      .allUserTransactions(userId)
      .where((t) => t.type == TransactionType.expense)
      .fold(0.0, (sum, t) => sum + t.amount);

  double getBalance() => getTotalIncome() - getTotalExpense();
}
