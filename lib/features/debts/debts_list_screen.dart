import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketsage/providers/providers.dart';
import 'package:pocketsage/core/theme/theme.dart';
import 'package:pocketsage/features/debts/debt_category_card.dart';
import 'package:pocketsage/features/debts/widgets/quick_add_category_dialog.dart';

class DebtsListScreen extends ConsumerWidget {
  const DebtsListScreen({super.key});

  void _showCreateCategoryDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => QuickAddCategoryDialog(
        onCategoryCreated: (categoryId) {
          ref.invalidate(debtCategoriesProvider);
          ref.invalidate(debtsGroupedByCategoryProvider);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(debtsSummaryProvider);
    final categories = ref.watch(debtCategoriesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Debts'),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [
                        AppColors.primaryLight.withValues(alpha: 0.2),
                        AppColors.primaryLight.withValues(alpha: 0.1)
                      ]
                    : [
                        AppColors.primaryIndigo,
                        AppColors.primaryIndigo.withValues(alpha: 0.8)
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _MetricTile(
                    label: 'Owed',
                    amount: summary['owed'] ?? 0,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MetricTile(
                    label: 'Paid',
                    amount: summary['paid'] ?? 0,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MetricTile(
                    label: 'Remaining',
                    amount: summary['remaining'] ?? 0,
                    isDark: isDark,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: categories.isEmpty
                ? _EmptyState(isDark: isDark)
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return DebtCategoryCard(category: category);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: PopupMenuButton<String>(
        icon: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: isDark ? AppColors.primaryLight : AppColors.primaryIndigo,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.add,
            color: isDark ? AppColors.darkBackground : Colors.white,
          ),
        ),
        onSelected: (value) {
          if (value == 'category') {
            _showCreateCategoryDialog(context, ref);
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'category',
            child: Row(
              children: [
                Icon(Icons.folder_open),
                SizedBox(width: 12),
                Text('Add Category'),
              ],
            ),
          ),
        ],
        offset: const Offset(0, -60),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final double amount;
  final bool isDark;
  const _MetricTile(
      {required this.label, required this.amount, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurface.withValues(alpha: 0.5)
            : Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : Colors.white.withValues(alpha: 0.8),
                ),
          ),
          const SizedBox(height: 6),
          Text(
            '€${amount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: isDark ? AppColors.darkText : Colors.white,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isDark;
  const _EmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 80,
            color: (isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary)
                .withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No debts yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
          ),
          const SizedBox(height: 8),
          Text('Tap + to add your first debt',
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
