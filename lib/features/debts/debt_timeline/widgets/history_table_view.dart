import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pocketsage/core/theme/theme.dart';
import 'package:pocketsage/data/models/debt.dart';
import 'package:pocketsage/l10n/app_localizations.dart';

class HistoryTableView extends StatelessWidget {
  final List<DebtHistoryItem> historyTimeline;

  const HistoryTableView({
    super.key,
    required this.historyTimeline,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(
              isDark
                  ? AppColors.darkSurface
                  : AppColors.primaryIndigo.withValues(alpha: 0.1),
            ),
            columns: [
              DataColumn(
                label: Text(
                  l10n.date,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.primaryLight
                        : AppColors.primaryIndigo,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  l10n.type,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.primaryLight
                        : AppColors.primaryIndigo,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  l10n.amount,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.primaryLight
                        : AppColors.primaryIndigo,
                  ),
                ),
                numeric: true,
              ),
              DataColumn(
                label: Text(
                  l10n.balance,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.primaryLight
                        : AppColors.primaryIndigo,
                  ),
                ),
                numeric: true,
              ),
              DataColumn(
                label: Text(
                  l10n.notes,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.primaryLight
                        : AppColors.primaryIndigo,
                  ),
                ),
              ),
            ],
            rows: historyTimeline.map((item) {
              final isDebtCreated = item.type == DebtHistoryType.debtCreated;
              return DataRow(
                cells: [
                  DataCell(
                    Text(
                      DateFormat('MMM d, yyyy\nHH:mm').format(item.date),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isDebtCreated ? Icons.receipt_long : Icons.payment,
                          size: 16,
                          color: isDebtCreated
                              ? AppColors.errorRose
                              : AppColors.successGreen,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isDebtCreated ? l10n.debtCreated : l10n.payment,
                          style: TextStyle(
                            color: isDebtCreated
                                ? AppColors.errorRose
                                : AppColors.successGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  DataCell(
                    Text(
                      '€${item.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isDebtCreated
                            ? AppColors.errorRose
                            : AppColors.successGreen,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      '€${item.runningBalance.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: item.runningBalance > 0
                            ? AppColors.errorRose
                            : AppColors.successGreen,
                      ),
                    ),
                  ),
                  DataCell(
                    Container(
                      constraints: const BoxConstraints(maxWidth: 200),
                      child: Text(
                        item.notes ?? '-',
                        style: Theme.of(context).textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

