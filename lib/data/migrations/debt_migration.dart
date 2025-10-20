import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocketsage/core/constants/constants.dart';
import 'package:pocketsage/data/models/debt.dart';
import 'package:pocketsage/data/models/debt_category.dart';

class DebtMigration {
  static const String _migrationKey = 'debt_categories_migration_completed';

  static Future<void> migrateExistingDebts() async {
    final prefs = await SharedPreferences.getInstance();
    final migrationCompleted = prefs.getBool(_migrationKey) ?? false;

    if (migrationCompleted) return;

    try {
      // Ensure debt categories box is open
      final categoryBox = Hive.box<DebtCategory>(HiveBoxes.debtCategories);
      final debtBox = Hive.box<Debt>(HiveBoxes.debts);

      // First, ensure default uncategorized category exists
      if (!categoryBox.containsKey(DebtCategoryDefaults.uncategorizedId)) {
        final defaultCategory = DebtCategory(
          id: DebtCategoryDefaults.uncategorizedId,
          userId: '', // Will be updated per user when they access the app
          name: DebtCategoryDefaults.uncategorizedName,
          color: DebtCategoryDefaults.uncategorizedColor,
          icon: DebtCategoryDefaults.uncategorizedIcon,
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
        );
        await categoryBox.put(defaultCategory.id, defaultCategory);
      }

      // Update all existing debts without categoryId
      final debtsToUpdate = <Debt>[];

      for (final debt in debtBox.values) {
        // Check if debt needs to be updated (using reflection would be cleaner but this works)
        try {
          // Try to read with old adapter format
          final debtFields = debtBox.get(debt.id);
          if (debtFields != null) {
            // If we can get the debt but it doesn't have proper categoryId handling,
            // update it to include the default category
            if (!debtBox.containsKey(debt.id)) continue;

            final updatedDebt = debt.copyWith(
              categoryId: 'uncategorized',
            );

            // Only update if this is actually a missing categoryId case
            if (debt.categoryId.isEmpty || debt.categoryId == '') {
              debtsToUpdate.add(updatedDebt);
            }
          }
        } catch (e) {
          // If there's an error reading, skip this debt
          continue;
        }
      }

      // Apply updates
      for (final debt in debtsToUpdate) {
        await debtBox.put(debt.id, debt);
      }

      // Mark migration as completed
      await prefs.setBool(_migrationKey, true);

      print('Debt categories migration completed successfully');
    } catch (e) {
      print('Error during debt categories migration: $e');
      // Don't mark as completed if there was an error
    }
  }

  static Future<void> resetMigration() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_migrationKey);
  }
}
