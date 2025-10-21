import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pocketsage/core/theme/theme.dart';
import 'package:pocketsage/data/models/debt.dart';
import 'package:pocketsage/l10n/app_localizations.dart';

class DebtSummaryCard extends StatelessWidget {
  final Debt debt;

  const DebtSummaryCard({
    super.key,
    required this.debt,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Container(
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _SummaryMetric(
                label: l10n.totalAmountValue,
                value: debt.totalAmount,
                isDark: isDark,
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withValues(alpha: 0.3),
              ),
              _SummaryMetric(
                label: l10n.paid,
                value: debt.paidAmount,
                isDark: isDark,
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withValues(alpha: 0.3),
              ),
              _SummaryMetric(
                label: l10n.remaining,
                value: debt.remainingAmount,
                isDark: isDark,
              ),
            ],
          ),
          if (debt.dueDate != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.schedule,
                    size: 16,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${l10n.due} ${DateFormat('MMM d, yyyy').format(debt.dueDate!)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  final String label;
  final double value;
  final bool isDark;

  const _SummaryMetric({
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
        ),
        const SizedBox(height: 4),
        Text(
          '€${value.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}

