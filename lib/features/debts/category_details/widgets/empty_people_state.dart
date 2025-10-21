import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketsage/core/theme/theme.dart';
import 'package:pocketsage/data/models/debt_category.dart';
import 'package:pocketsage/l10n/app_localizations.dart';

class EmptyPeopleState extends ConsumerWidget {
  final DebtCategory category;

  const EmptyPeopleState({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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

