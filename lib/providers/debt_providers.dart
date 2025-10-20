import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocketsage/core/constants/constants.dart';
import 'package:pocketsage/data/models/debt.dart';
import 'package:pocketsage/data/models/debt_category.dart';
import 'package:pocketsage/data/repositories/debts_repository.dart';
import 'package:pocketsage/data/repositories/debt_category_repository.dart';
import 'package:pocketsage/providers/app_providers.dart';

final debtsBoxEventsProvider = StreamProvider<BoxEvent>((ref) {
  return Hive.box<Debt>(HiveBoxes.debts).watch();
});

final debtCategoryBoxEventsProvider = StreamProvider<BoxEvent>((ref) {
  return Hive.box<DebtCategory>(HiveBoxes.debtCategories).watch();
});

final debtsRepositoryProvider = Provider<DebtsRepository>((ref) {
  final user = ref.watch(currentUserProvider);
  // For web, we didn't build a memory repo; Debts is mobile-only persistence.
  final box = Hive.box<Debt>(HiveBoxes.debts);
  return DebtsRepository(box, user.id);
});

final debtCategoryRepositoryProvider = Provider<DebtCategoryRepository>((ref) {
  final user = ref.watch(currentUserProvider);
  final categoryBox = Hive.box<DebtCategory>(HiveBoxes.debtCategories);
  final debtBox = Hive.box<Debt>(HiveBoxes.debts);
  return DebtCategoryRepository(categoryBox, debtBox, user.id);
});

final debtsProvider = Provider<List<Debt>>((ref) {
  // Watch Hive box events to refresh on changes
  ref.watch(debtsBoxEventsProvider);
  final repo = ref.watch(debtsRepositoryProvider);
  return repo.getAll();
});

final debtCategoriesProvider = Provider<List<DebtCategory>>((ref) {
  // Watch Hive box events to refresh on changes
  ref.watch(debtCategoryBoxEventsProvider);
  final repo = ref.watch(debtCategoryRepositoryProvider);
  return repo.getAllSorted();
});

final debtsGroupedByCategoryProvider =
    Provider<Map<DebtCategory, List<Debt>>>((ref) {
  final categories = ref.watch(debtCategoriesProvider);
  final repo = ref.watch(debtsRepositoryProvider);

  final groupedDebts = <DebtCategory, List<Debt>>{};

  for (final category in categories) {
    final categoryDebts = repo.getByCategory(category.id);
    if (categoryDebts.isNotEmpty) {
      groupedDebts[category] = categoryDebts;
    }
  }

  return groupedDebts;
});
