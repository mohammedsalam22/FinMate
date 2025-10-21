import 'package:flutter/material.dart';
import 'package:pocketsage/l10n/app_localizations.dart';

/// Utility class for showing common confirmation dialogs
class ConfirmationDialogs {
  ConfirmationDialogs._();

  /// Shows a delete confirmation dialog
  static Future<bool> showDeleteConfirmation({
    required BuildContext context,
    required String title,
    required List<String> warningMessages,
    String? additionalWarning,
  }) async {
    final l10n = AppLocalizations.of(context)!;

    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...warningMessages.map((msg) => Text(msg)),
                if (additionalWarning != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    additionalWarning,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text(l10n.delete,
                    style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ) ??
        false;
  }

  /// Shows a delete category confirmation dialog
  static Future<bool> showDeleteCategoryConfirmation({
    required BuildContext context,
    required String categoryName,
    required int debtsCount,
  }) async {
    final l10n = AppLocalizations.of(context)!;

    return showDeleteConfirmation(
      context: context,
      title: l10n.deleteCategoryTitle(categoryName),
      warningMessages: [
        l10n.deleteCategoryMessage,
        '',
        l10n.deleteCategoryItem(categoryName),
        l10n.deleteDebtsCount(debtsCount),
        l10n.deletePaymentHistory,
      ],
      additionalWarning: l10n.actionCannotBeUndone,
    );
  }

  /// Shows a delete person confirmation dialog
  static Future<bool> showDeletePersonConfirmation({
    required BuildContext context,
    required String personName,
  }) async {
    final l10n = AppLocalizations.of(context)!;

    return showDeleteConfirmation(
      context: context,
      title: l10n.deletePersonTitle(personName),
      warningMessages: [
        l10n.deletePersonMessage,
        '',
        l10n.deletePersonDebts,
        l10n.deletePersonPayments,
      ],
      additionalWarning: l10n.actionCannotBeUndone,
    );
  }
}

