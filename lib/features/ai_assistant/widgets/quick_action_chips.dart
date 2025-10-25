import 'package:flutter/material.dart';
import 'package:pocketsage/core/theme/theme.dart';
import 'package:pocketsage/l10n/app_localizations.dart';

class QuickActionChips extends StatelessWidget {
  final Function(String) onActionSelected;

  const QuickActionChips({
    super.key,
    required this.onActionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final actions = [
      QuickAction(
        label: l10n.summarizeThisWeek,
        icon: Icons.calendar_today,
        prompt: l10n.summarizeThisWeekPrompt,
      ),
      QuickAction(
        label: l10n.showSpendingBreakdown,
        icon: Icons.pie_chart,
        prompt: l10n.showSpendingBreakdownPrompt,
      ),
      QuickAction(
        label: l10n.addExpense,
        icon: Icons.add_circle,
        prompt: l10n.addExpensePrompt,
      ),
      QuickAction(
        label: l10n.checkDebts,
        icon: Icons.account_balance_wallet,
        prompt: l10n.checkDebtsPrompt,
      ),
      QuickAction(
        label: l10n.currentBalance,
        icon: Icons.account_balance,
        prompt: l10n.currentBalancePrompt,
      ),
      QuickAction(
        label: l10n.topCategories,
        icon: Icons.category,
        prompt: l10n.topCategoriesPrompt,
      ),
    ];

    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: actions.length,
        itemBuilder: (context, index) {
          final action = actions[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              avatar: Icon(
                action.icon,
                size: 18,
                color: AppColors.primaryIndigo,
              ),
              label: Text(
                action.label,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
              backgroundColor:
                  isDark ? AppColors.darkSurface : AppColors.lightSurface,
              side: BorderSide(
                color: AppColors.primaryIndigo.withValues(alpha: 0.3),
                width: 1,
              ),
              onPressed: () => onActionSelected(action.prompt),
            ),
          );
        },
      ),
    );
  }
}

class QuickAction {
  final String label;
  final IconData icon;
  final String prompt;

  const QuickAction({
    required this.label,
    required this.icon,
    required this.prompt,
  });
}
