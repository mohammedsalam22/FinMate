import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocketsage/data/models/category.dart';
import 'package:uuid/uuid.dart';

class CategoryRepository {
  final Box<Category> _box;
  final String userId;

  CategoryRepository(this._box, this.userId) {
    _initializeDefaultCategories();
  }

  void _initializeDefaultCategories() {
    if (_box.isEmpty) {
      final defaults = _getDefaultCategories();
      for (var category in defaults) {
        _box.put(category.id, category);
      }
    }
  }

  List<Category> _getDefaultCategories() {
    final uuid = Uuid();
    return [
      Category(
        id: uuid.v4(),
        userId: userId,
        name: 'Salary',
        icon: 'payments',
        color: 0xFF10B981,
        type: CategoryType.income,
      ),
      Category(
        id: uuid.v4(),
        userId: userId,
        name: 'Freelance',
        icon: 'work',
        color: 0xFF8B5CF6,
        type: CategoryType.income,
      ),
      Category(
        id: uuid.v4(),
        userId: userId,
        name: 'Groceries',
        icon: 'shopping_cart',
        color: 0xFFF59E0B,
        type: CategoryType.expense,
      ),
      Category(
        id: uuid.v4(),
        userId: userId,
        name: 'Transport',
        icon: 'directions_car',
        color: 0xFF3B82F6,
        type: CategoryType.expense,
      ),
      Category(
        id: uuid.v4(),
        userId: userId,
        name: 'Entertainment',
        icon: 'movie',
        color: 0xFFEC4899,
        type: CategoryType.expense,
      ),
      Category(
        id: uuid.v4(),
        userId: userId,
        name: 'Bills',
        icon: 'receipt_long',
        color: 0xFFEF4444,
        type: CategoryType.expense,
      ),
      Category(
        id: uuid.v4(),
        userId: userId,
        name: 'Healthcare',
        icon: 'local_hospital',
        color: 0xFF06B6D4,
        type: CategoryType.expense,
      ),
      Category(
        id: uuid.v4(),
        userId: userId,
        name: 'Dining',
        icon: 'restaurant',
        color: 0xFFF97316,
        type: CategoryType.expense,
      ),
    ];
  }

  List<Category> getAll() => _box.values.toList();

  List<Category> getByType(CategoryType type) =>
      _box.values.where((c) => c.type == type).toList();

  Category? getById(String id) => _box.get(id);

  Future<void> add(Category category) async =>
      await _box.put(category.id, category);

  Future<void> update(Category category) async =>
      await _box.put(category.id, category);

  Future<void> delete(String id) async => await _box.delete(id);

  IconData getIconData(String iconName) {
    final iconMap = {
      'payments': Icons.payments,
      'work': Icons.work,
      'shopping_cart': Icons.shopping_cart,
      'directions_car': Icons.directions_car,
      'movie': Icons.movie,
      'receipt_long': Icons.receipt_long,
      'local_hospital': Icons.local_hospital,
      'restaurant': Icons.restaurant,
    };
    return iconMap[iconName] ?? Icons.category;
  }
}
