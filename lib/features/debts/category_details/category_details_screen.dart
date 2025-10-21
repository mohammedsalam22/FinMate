import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketsage/providers/providers.dart';
import 'package:pocketsage/data/models/debt.dart';
import 'package:pocketsage/core/widgets/confirmation_dialogs.dart';
import 'package:pocketsage/features/debts/category_details/widgets/category_stats_header.dart';
import 'package:pocketsage/features/debts/category_details/widgets/person_card.dart';
import 'package:pocketsage/features/debts/category_details/widgets/empty_people_state.dart';
import 'package:pocketsage/l10n/app_localizations.dart';

class CategoryDetailsScreen extends ConsumerWidget {
  final String categoryId;

  const CategoryDetailsScreen({super.key, required this.categoryId});

  Future<void> _showDeleteCategoryDialog(
      BuildContext context, WidgetRef ref, String categoryName) async {
    final categoryRepo = ref.read(debtCategoryRepositoryProvider);
    final debtsRepo = ref.read(debtsRepositoryProvider);
    final debtsCount = debtsRepo.getByCategory(categoryId).length;

    final confirm = await ConfirmationDialogs.showDeleteCategoryConfirmation(
      context: context,
      categoryName: categoryName,
      debtsCount: debtsCount,
    );

    if (confirm == true) {
      try {
        await categoryRepo.deleteCategoryWithDebts(categoryId);
        ref.invalidate(debtsProvider);
        ref.invalidate(debtsSummaryProvider);
        ref.invalidate(debtsGroupedByCategoryProvider);
        ref.invalidate(debtCategoriesProvider);

        if (context.mounted) {
          final l10n = AppLocalizations.of(context)!;
          context.pop(); // Go back to debts list
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.categoryDeletedSuccess(categoryName))),
          );
        }
      } catch (e) {
        if (context.mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.errorDeletingCategory(e.toString()))),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final categoryRepo = ref.watch(debtCategoryRepositoryProvider);
    final debtsRepo = ref.watch(debtsRepositoryProvider);

    final category = categoryRepo.getById(categoryId);
    if (category == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.categoryNotFound)),
        body: Center(child: Text(l10n.categoryNotFoundText)),
      );
    }

    final categoryDebts = debtsRepo.getByCategory(categoryId);
    final stats = categoryRepo.getCategoryStats(categoryId);

    // Group debts by person (debtorName)
    final debtsByPerson = <String, List<Debt>>{};
    for (final debt in categoryDebts) {
      debtsByPerson.putIfAbsent(debt.debtorName, () => []).add(debt);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        backgroundColor: Color(category.color).withValues(alpha: 0.1),
        foregroundColor: Color(category.color),
        actions: [
          if (categoryId != 'uncategorized')
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') {
                  _showDeleteCategoryDialog(context, ref, category.name);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      const Icon(Icons.delete, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(l10n.deleteCategory,
                          style: const TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: Column(
        children: [
          CategoryStatsHeader(
            category: category,
            stats: stats,
          ),
          // People List
          Expanded(
            child: debtsByPerson.isEmpty
                ? EmptyPeopleState(category: category)
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: debtsByPerson.length,
                    itemBuilder: (context, index) {
                      final personEntry = debtsByPerson.entries.elementAt(index);
                      final personName = personEntry.key;
                      final personDebts = personEntry.value;

                      return PersonCard(
                        personName: personName,
                        personDebts: personDebts,
                        category: category,
                        categoryId: categoryId,
                        onConfirmDelete: (name) =>
                            ConfirmationDialogs.showDeletePersonConfirmation(
                          context: context,
                          personName: name,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            context.push('/add-debt', extra: {'categoryId': categoryId}),
        icon: const Icon(Icons.add),
        label: Text(l10n.addDebtButton),
        backgroundColor: Color(category.color),
        foregroundColor: Colors.white,
      ),
    );
  }
}
