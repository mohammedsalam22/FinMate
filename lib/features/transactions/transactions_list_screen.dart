import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pocketsage/providers/providers.dart';
import 'package:pocketsage/data/models/transaction.dart';
import 'package:pocketsage/data/models/category.dart';
import 'package:pocketsage/core/theme/theme.dart';
import 'package:pocketsage/l10n/app_localizations.dart';

class TransactionsListScreen extends ConsumerWidget {
  const TransactionsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionsProvider);
    final balance = ref.watch(balanceSummaryProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final groupedTransactions = _groupTransactionsByDate(transactions);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.totalBalance,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? AppColors.darkText
                            : Colors.white.withValues(alpha: 0.9),
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  '€${(balance['balance'] ?? 0.0).toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: isDark ? AppColors.darkText : Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _BalanceCard(
                        label: l10n.income,
                        amount: balance['income'] ?? 0.0,
                        icon: Icons.arrow_downward,
                        color: AppColors.successGreen,
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _BalanceCard(
                        label: l10n.expense,
                        amount: balance['expense'] ?? 0.0,
                        icon: Icons.arrow_upward,
                        color: AppColors.errorRose,
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.recentTransactions,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
          Expanded(
            child: transactions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 80,
                          color: (isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary)
                              .withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noTransactionsYet,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.tapToAddFirstTransaction,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: groupedTransactions.length,
                    itemBuilder: (context, index) {
                      final date = groupedTransactions.keys.elementAt(index);
                      final dayTransactions = groupedTransactions[date]!;
                      return _TransactionGroup(
                        date: date,
                        transactions: dayTransactions,
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'transactionsFab',
        onPressed: () => context.push('/add-transaction'),
        icon: const Icon(Icons.add),
        label: Text(l10n.add),
        backgroundColor:
            isDark ? AppColors.primaryLight : AppColors.primaryIndigo,
        foregroundColor: isDark ? AppColors.darkBackground : Colors.white,
      ),
    );
  }

  Map<String, List<FinTransaction>> _groupTransactionsByDate(
      List<FinTransaction> transactions) {
    final Map<String, List<FinTransaction>> grouped = {};
    for (var transaction in transactions) {
      final dateKey = DateFormat('yyyy-MM-dd').format(transaction.date);
      grouped.putIfAbsent(dateKey, () => []).add(transaction);
    }
    return grouped;
  }
}

class _BalanceCard extends StatelessWidget {
  final String label;
  final double amount;
  final IconData icon;
  final Color color;
  final bool isDark;

  const _BalanceCard({
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
    required this.isDark,
  });

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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
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
                const SizedBox(height: 4),
                Text(
                  '€${amount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isDark ? AppColors.darkText : Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionGroup extends ConsumerWidget {
  final String date;
  final List<FinTransaction> transactions;

  const _TransactionGroup({
    required this.date,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parsedDate = DateTime.parse(date);
    final isToday = DateFormat('yyyy-MM-dd').format(DateTime.now()) == date;
    final isYesterday = DateFormat('yyyy-MM-dd')
            .format(DateTime.now().subtract(const Duration(days: 1))) ==
        date;

    final l10n = AppLocalizations.of(context)!;

    String dateLabel;
    if (isToday) {
      dateLabel = l10n.today;
    } else if (isYesterday) {
      dateLabel = l10n.yesterday;
    } else {
      dateLabel = DateFormat('EEEE, MMM d').format(parsedDate);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            dateLabel,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
          ),
        ),
        ...transactions
            .map((transaction) => _TransactionCard(transaction: transaction)),
      ],
    );
  }
}

class _TransactionCard extends ConsumerWidget {
  final FinTransaction transaction;

  const _TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final categories = ref.watch(categoriesProvider);
    final categoryRepo = ref.watch(categoryRepositoryProvider);
    final category = categories.firstWhere(
      (c) => c.id == transaction.categoryId,
      orElse: () => Category(
        id: '',
        userId: '',
        name: l10n.unknown,
        icon: 'category',
        color: 0xFF666666,
        type: CategoryType.expense,
      ),
    );
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(category.color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  categoryRepo.getIconData(category.icon),
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
                      category.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (transaction.notes != null &&
                        transaction.notes!.isNotEmpty)
                      Text(
                        transaction.notes!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    Text(
                      DateFormat('HH:mm').format(transaction.date),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              Text(
                '${transaction.type == TransactionType.income ? '+' : '-'}€${transaction.amount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: transaction.type == TransactionType.income
                          ? AppColors.successGreen
                          : AppColors.errorRose,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
