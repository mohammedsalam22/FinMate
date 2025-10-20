import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocketsage/data/models/debt_category.dart';
import 'package:pocketsage/data/models/debt.dart';
import 'package:uuid/uuid.dart';

class DebtCategoryRepository {
  final Box<DebtCategory> _categoryBox;
  final Box<Debt> _debtBox;
  final String userId;

  DebtCategoryRepository(this._categoryBox, this._debtBox, this.userId) {
    _ensureDefaultCategory();
  }

  void _ensureDefaultCategory() {
    if (_categoryBox.get(DebtCategoryDefaults.uncategorizedId) == null) {
      final defaultCategory = DebtCategory(
        id: DebtCategoryDefaults.uncategorizedId,
        userId: userId,
        name: DebtCategoryDefaults.uncategorizedName,
        color: DebtCategoryDefaults.uncategorizedColor,
        icon: DebtCategoryDefaults.uncategorizedIcon,
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );
      _categoryBox.put(defaultCategory.id, defaultCategory);
    }
  }

  List<DebtCategory> getAll() =>
      _categoryBox.values.where((c) => c.userId == userId).toList()
        ..sort((a, b) => a.name.compareTo(b.name));

  List<DebtCategory> getAllSorted() {
    final categories = getAll();
    // Put uncategorized at the end
    final uncategorized = categories
        .where((c) => c.id == DebtCategoryDefaults.uncategorizedId)
        .toList();
    final others = categories
        .where((c) => c.id != DebtCategoryDefaults.uncategorizedId)
        .toList();
    return [...others, ...uncategorized];
  }

  DebtCategory? getById(String id) => _categoryBox.get(id);

  DebtCategory getUncategorizedCategory() {
    return _categoryBox.get(DebtCategoryDefaults.uncategorizedId) ??
        _categoryBox.values
            .firstWhere((c) => c.id == DebtCategoryDefaults.uncategorizedId);
  }

  Future<void> add(DebtCategory category) async {
    await _categoryBox.put(category.id, category);
  }

  Future<void> update(DebtCategory category) async {
    final updated = category.copyWith(updatedAt: DateTime.now().toUtc());
    await _categoryBox.put(updated.id, updated);
  }

  Future<void> delete(String id) async {
    // Prevent deletion of uncategorized category
    if (id == DebtCategoryDefaults.uncategorizedId) {
      throw Exception('Cannot delete the uncategorized category');
    }
    await _categoryBox.delete(id);
  }

  Future<void> deleteCategoryWithDebts(String categoryId) async {
    // Prevent deletion of uncategorized category
    if (categoryId == DebtCategoryDefaults.uncategorizedId) {
      throw Exception('Cannot delete the uncategorized category');
    }

    // Get all debts in this category and delete them
    final debtsToDelete = _debtBox.values
        .where((d) => d.userId == userId && d.categoryId == categoryId)
        .toList();

    // Delete all debts first
    for (final debt in debtsToDelete) {
      await _debtBox.delete(debt.id);
    }

    // Then delete the category
    await _categoryBox.delete(categoryId);
  }

  bool canDelete(String categoryId) {
    if (categoryId == DebtCategoryDefaults.uncategorizedId) return false;
    final debtsWithCategory = _debtBox.values
        .where((d) => d.userId == userId && d.categoryId == categoryId);
    return debtsWithCategory.isEmpty;
  }

  IconData getIconData(String iconName) {
    final iconMap = {
      'folder_open': Icons.folder_open,
      'business': Icons.business,
      'home': Icons.home,
      'work': Icons.work,
      'school': Icons.school,
      'restaurant': Icons.restaurant,
      'local_hospital': Icons.local_hospital,
      'directions_car': Icons.directions_car,
      'shopping_cart': Icons.shopping_cart,
      'sports_esports': Icons.sports_esports,
      'family_restroom': Icons.family_restroom,
      'pets': Icons.pets,
      'gavel': Icons.gavel,
      'account_balance': Icons.account_balance,
      'build': Icons.build,
    };
    return iconMap[iconName] ?? Icons.folder_open;
  }

  Map<String, dynamic> getCategoryStats(String categoryId) {
    final debts = _debtBox.values
        .where((d) => d.userId == userId && d.categoryId == categoryId);
    final totalDebts = debts.length;
    final totalOwed = debts.fold(0.0, (sum, d) => sum + d.totalAmount);
    final totalPaid = debts.fold(0.0, (sum, d) => sum + d.paidAmount);
    final totalRemaining = debts.fold(0.0, (sum, d) => sum + d.remainingAmount);

    return {
      'totalDebts': totalDebts,
      'totalOwed': totalOwed,
      'totalPaid': totalPaid,
      'totalRemaining': totalRemaining,
    };
  }

  Future<DebtCategory> createCategory({
    required String name,
    required int color,
    required String icon,
    String? description,
  }) async {
    final category = DebtCategory(
      id: Uuid().v4(),
      userId: userId,
      name: name.trim(),
      color: color,
      icon: icon,
      description: description?.trim(),
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );
    await add(category);
    return category;
  }
}
