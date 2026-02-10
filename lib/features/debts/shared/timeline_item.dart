import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pocketsage/data/models/debt.dart';
import 'package:pocketsage/core/theme/theme.dart';
import 'package:pocketsage/l10n/app_localizations.dart';

class TimelineItem extends StatelessWidget {
  final DebtHistoryItem historyItem;
  final bool isFirst;
  final bool isLast;
  final VoidCallback? onDelete;

  const TimelineItem({
    super.key,
    required this.historyItem,
    this.isFirst = false,
    this.isLast = false,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDebtCreated = historyItem.type == DebtHistoryType.debtCreated;

    Widget content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        Column(
          children: [
            if (!isFirst)
              Container(
                width: 2,
                height: 20,
                color: (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary)
                    .withValues(alpha: 0.3),
              ),
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isDebtCreated
                    ? AppColors.errorRose
                    : AppColors.successGreen,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark
                      ? AppColors.darkBackground
                      : AppColors.lightBackground,
                  width: 2,
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary)
                    .withValues(alpha: 0.3),
              ),
          ],
        ),
        const SizedBox(width: 16),
        // Content
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary)
                    .withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isDebtCreated ? Icons.add_circle_outline : Icons.payment,
                      color: isDebtCreated
                          ? AppColors.errorRose
                          : AppColors.successGreen,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isDebtCreated ? 'Debt Created' : 'Payment Made',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${isDebtCreated ? '+' : '-'}€${historyItem.amount.toStringAsFixed(2)}',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: isDebtCreated
                                        ? AppColors.errorRose
                                        : AppColors.successGreen,
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                        Text(
                          'Balance: €${historyItem.runningBalance.toStringAsFixed(2)}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 14,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('MMM d, yyyy • HH:mm')
                          .format(historyItem.date),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                    ),
                  ],
                ),
                if (historyItem.notes != null &&
                    historyItem.notes!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    historyItem.notes!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );

    // If onDelete is provided, wrap with Dismissible
    if (onDelete != null) {
      return Dismissible(
        key: ValueKey(historyItem.id),
        background: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.centerLeft,
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        secondaryBackground: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.centerRight,
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        confirmDismiss: (direction) async {
          // Show confirmation dialog
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                isDebtCreated
                    ? AppLocalizations.of(context)!.deleteDebtTitle
                    : AppLocalizations.of(context)!.deletePaymentTitle,
              ),
              content: Text(
                isDebtCreated
                    ? AppLocalizations.of(context)!.deleteDebtMessage
                    : AppLocalizations.of(context)!.deletePaymentMessage,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(AppLocalizations.of(context)!.cancel),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text(
                    AppLocalizations.of(context)!.delete,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
          return confirmed ?? false;
        },
        onDismissed: (_) => onDelete!(),
        child: content,
      );
    }

    return content;
  }
}
