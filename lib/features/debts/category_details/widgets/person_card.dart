import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketsage/core/theme/theme.dart';
import 'package:pocketsage/data/models/debt.dart';
import 'package:pocketsage/data/models/debt_category.dart';
import 'package:pocketsage/l10n/app_localizations.dart';
import 'package:pocketsage/providers/providers.dart';

class PersonCard extends ConsumerWidget {
  final String personName;
  final List<Debt> personDebts;
  final DebtCategory category;
  final String categoryId;
  final Future<bool> Function(String personName) onConfirmDelete;

  const PersonCard({
    super.key,
    required this.personName,
    required this.personDebts,
    required this.category,
    required this.categoryId,
    required this.onConfirmDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    
    final totalRemaining =
        personDebts.fold(0.0, (sum, debt) => sum + debt.remainingAmount);
    final totalAmount =
        personDebts.fold(0.0, (sum, debt) => sum + debt.totalAmount);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: ValueKey(personName),
        background: _buildDismissBackground(Alignment.centerLeft),
        secondaryBackground: _buildDismissBackground(Alignment.centerRight),
        confirmDismiss: (direction) => onConfirmDelete(personName),
        onDismissed: (_) async {
          try {
            await ref
                .read(debtsRepositoryProvider)
                .deleteDebtsByPerson(personName, categoryId);
            ref.invalidate(debtsProvider);
            ref.invalidate(debtsSummaryProvider);
            ref.invalidate(debtsGroupedByCategoryProvider);

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.personDeletedSuccess(personName))),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.errorDeletingPerson(e.toString()))),
              );
            }
          }
        },
        child: Card(
          child: InkWell(
            onTap: () {
              context.push(
                  '/person-timeline/$categoryId/${Uri.encodeComponent(personName)}');
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(category.color).withValues(alpha: 0.1),
                    child: Icon(
                      Icons.person,
                      color: Color(category.color),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          personName,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${personDebts.length == 1 ? l10n.debtCount(personDebts.length) : l10n.debtsCount(personDebts.length)} • €${totalAmount.toStringAsFixed(0)} ${l10n.total}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '€${totalRemaining.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: totalRemaining > 0
                                  ? AppColors.errorRose
                                  : AppColors.successGreen,
                            ),
                      ),
                      Text(
                        totalRemaining > 0 ? l10n.remaining : l10n.settled,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
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
  }

  Widget _buildDismissBackground(Alignment alignment) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: alignment,
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }
}

