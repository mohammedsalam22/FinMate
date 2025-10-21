import 'package:flutter/material.dart';
import 'package:pocketsage/core/theme/theme.dart';
import 'package:pocketsage/data/models/debt_category.dart';
import 'package:pocketsage/l10n/app_localizations.dart';

class PersonSummaryCard extends StatelessWidget {
  final DebtCategory category;
  final double totalOwed;
  final double totalPaid;
  final double totalRemaining;

  const PersonSummaryCard({
    super.key,
    required this.category,
    required this.totalOwed,
    required this.totalPaid,
    required this.totalRemaining,
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
          colors: [
            Color(category.color).withValues(alpha: 0.1),
            Color(category.color).withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(category.color).withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _SummaryMetric(
                label: l10n.totalOwed,
                value: totalOwed,
                isDark: isDark,
                color: Color(category.color),
              ),
              Container(
                width: 1,
                height: 40,
                color: Color(category.color).withValues(alpha: 0.3),
              ),
              _SummaryMetric(
                label: l10n.paid,
                value: totalPaid,
                isDark: isDark,
                color: AppColors.successGreen,
              ),
              Container(
                width: 1,
                height: 40,
                color: Color(category.color).withValues(alpha: 0.3),
              ),
              _SummaryMetric(
                label: l10n.remaining,
                value: totalRemaining,
                isDark: isDark,
                color: totalRemaining > 0
                    ? AppColors.errorRose
                    : AppColors.successGreen,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.inCategory(category.name),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Color(category.color),
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  final String label;
  final double value;
  final bool isDark;
  final Color color;

  const _SummaryMetric({
    required this.label,
    required this.value,
    required this.isDark,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color.withValues(alpha: 0.8),
              ),
        ),
        const SizedBox(height: 4),
        Text(
          '€${value.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}
