import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketsage/core/theme/theme.dart';
import 'package:pocketsage/data/models/debt_category.dart';
import 'package:pocketsage/l10n/app_localizations.dart';
import 'package:pocketsage/providers/providers.dart';

class CategoryStatsHeader extends ConsumerWidget {
  final DebtCategory category;
  final Map<String, dynamic> stats;

  const CategoryStatsHeader({
    super.key,
    required this.category,
    required this.stats,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final categoryRepo = ref.watch(debtCategoryRepositoryProvider);

    return Container(
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
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
    );
  }
}

