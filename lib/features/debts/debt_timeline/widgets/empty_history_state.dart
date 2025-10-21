import 'package:flutter/material.dart';
import 'package:pocketsage/core/theme/theme.dart';
import 'package:pocketsage/l10n/app_localizations.dart';

class EmptyHistoryState extends StatelessWidget {
  const EmptyHistoryState({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: (isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary)
                .withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noHistoryYet,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.paymentHistoryWillAppear,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

