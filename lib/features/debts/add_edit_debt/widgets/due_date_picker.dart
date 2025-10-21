import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pocketsage/core/theme/theme.dart';
import 'package:pocketsage/l10n/app_localizations.dart';

class DueDatePicker extends StatelessWidget {
  final DateTime? dueDate;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const DueDatePicker({
    super.key,
    required this.dueDate,
    required this.onTap,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.dueDateOptional,
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary)
                    .withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today,
                    color:
                        isDark ? AppColors.primaryLight : AppColors.primaryIndigo),
                const SizedBox(width: 12),
                Text(dueDate == null
                    ? l10n.noDueDate
                    : DateFormat('MMM d, yyyy').format(dueDate!)),
                const Spacer(),
                if (dueDate != null && onClear != null)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: onClear,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

