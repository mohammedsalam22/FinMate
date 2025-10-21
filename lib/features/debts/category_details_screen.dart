import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketsage/providers/providers.dart';
import 'package:pocketsage/data/models/debt.dart';
import 'package:pocketsage/data/models/debt_category.dart';
import 'package:pocketsage/core/theme/theme.dart';
import 'package:pocketsage/l10n/app_localizations.dart';

class CategoryDetailsScreen extends ConsumerWidget {
  final String categoryId;

  const CategoryDetailsScreen({super.key, required this.categoryId});

  Future<void> _showDeleteCategoryDialog(
      BuildContext context, WidgetRef ref, DebtCategory category) async {
    final l10n = AppLocalizations.of(context)!;
    final debtsRepo = ref.read(debtsRepositoryProvider);
    final categoryRepo = ref.read(debtCategoryRepositoryProvider);
    final debtsCount = debtsRepo.getByCategory(categoryId).length;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteCategoryTitle(category.name)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.deleteCategoryMessage),
            const SizedBox(height: 8),
            Text(l10n.deleteCategoryItem(category.name)),
            Text(l10n.deleteDebtsCount(debtsCount)),
            Text(l10n.deletePaymentHistory),
            const SizedBox(height: 12),
            Text(
              l10n.actionCannotBeUndone,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child:
                Text(l10n.delete, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
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
            SnackBar(content: Text(l10n.categoryDeletedSuccess(category.name))),
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

  Future<bool> _showDeletePersonConfirmation(
      BuildContext context, String personName) async {
    final l10n = AppLocalizations.of(context)!;
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.deletePersonTitle(personName)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.deletePersonMessage),
                const SizedBox(height: 8),
                Text(l10n.deletePersonDebts),
                Text(l10n.deletePersonPayments),
                const SizedBox(height: 12),
                Text(
                  l10n.actionCannotBeUndone,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.red),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text(l10n.delete,
                    style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                  _showDeleteCategoryDialog(context, ref, category);
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
          // Category Stats Header
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(category.color).withValues(alpha: 0.1),
                  Color(category.color).withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Color(category.color).withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(category.color).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    categoryRepo.getIconData(category.icon),
                    color: Color(category.color),
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.totalDebts(stats['totalDebts'] as int),
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '€${stats['totalOwed']?.toStringAsFixed(2) ?? '0.00'} ${l10n.totalAmountLabel}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Color(category.color),
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '€${stats['totalRemaining']?.toStringAsFixed(2) ?? '0.00'}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.errorRose,
                          ),
                    ),
                    Text(
                      l10n.remaining,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // People List
          Expanded(
            child: debtsByPerson.isEmpty
                ? _EmptyPeopleState(isDark: isDark, category: category)
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: debtsByPerson.length,
                    itemBuilder: (context, index) {
                      final personEntry =
                          debtsByPerson.entries.elementAt(index);
                      final personName = personEntry.key;
                      final personDebts = personEntry.value;
                      final totalRemaining = personDebts.fold(
                          0.0, (sum, debt) => sum + debt.remainingAmount);
                      final totalAmount = personDebts.fold(
                          0.0, (sum, debt) => sum + debt.totalAmount);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Dismissible(
                          key: ValueKey(personName),
                          background: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            alignment: Alignment.centerLeft,
                            child:
                                const Icon(Icons.delete, color: Colors.white),
                          ),
                          secondaryBackground: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            alignment: Alignment.centerRight,
                            child:
                                const Icon(Icons.delete, color: Colors.white),
                          ),
                          confirmDismiss: (direction) async {
                            // Show confirmation dialog and wait for the result
                            return await _showDeletePersonConfirmation(
                                context, personName);
                          },
                          onDismissed: (_) async {
                            // Perform the actual deletion
                            try {
                              await ref
                                  .read(debtsRepositoryProvider)
                                  .deleteDebtsByPerson(personName, categoryId);
                              ref.invalidate(debtsProvider);
                              ref.invalidate(debtsSummaryProvider);
                              ref.invalidate(debtsGroupedByCategoryProvider);

                              if (context.mounted) {
                                final l10n = AppLocalizations.of(context)!;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(l10n
                                          .personDeletedSuccess(personName))),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                final l10n = AppLocalizations.of(context)!;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(l10n
                                          .errorDeletingPerson(e.toString()))),
                                );
                              }
                            }
                          },
                          child: Card(
                            child: InkWell(
                              onTap: () {
                                // Navigate to person timeline for this person in this category
                                context.push(
                                    '/person-timeline/${categoryId}/${Uri.encodeComponent(personName)}');
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Color(category.color)
                                          .withValues(alpha: 0.1),
                                      child: Icon(
                                        Icons.person,
                                        color: Color(category.color),
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            personName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${personDebts.length == 1 ? l10n.debtCount(personDebts.length) : l10n.debtsCount(personDebts.length)} • €${totalAmount.toStringAsFixed(0)} ${l10n.total}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: isDark
                                                      ? AppColors
                                                          .darkTextSecondary
                                                      : AppColors
                                                          .lightTextSecondary,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '€${totalRemaining.toStringAsFixed(2)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                                color: totalRemaining > 0
                                                    ? AppColors.errorRose
                                                    : AppColors.successGreen,
                                              ),
                                        ),
                                        Text(
                                          totalRemaining > 0
                                              ? l10n.remaining
                                              : l10n.settled,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: isDark
                                                    ? AppColors
                                                        .darkTextSecondary
                                                    : AppColors
                                                        .lightTextSecondary,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: isDark
                                          ? AppColors.darkTextSecondary
                                          : AppColors.lightTextSecondary,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
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

class _EmptyPeopleState extends ConsumerWidget {
  final bool isDark;
  final DebtCategory category;

  const _EmptyPeopleState({required this.isDark, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: Color(category.color).withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noPeopleInCategory,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.addFirstDebtToStart,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () =>
                context.push('/add-debt', extra: {'categoryId': category.id}),
            icon: const Icon(Icons.add),
            label: Text(l10n.addFirstDebtButton),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(category.color),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
