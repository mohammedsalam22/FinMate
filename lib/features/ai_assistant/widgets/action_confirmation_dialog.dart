import 'package:flutter/material.dart';
import 'package:pocketsage/features/ai_assistant/models/ai_action.dart';
import 'package:pocketsage/l10n/app_localizations.dart';

class ActionConfirmationDialog extends StatelessWidget {
  final AiAction action;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ActionConfirmationDialog({
    super.key,
    required this.action,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(_getTitle(l10n)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_getDescription(l10n)),
          const SizedBox(height: 16),
          _buildDetails(l10n),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          child: Text(l10n.confirm),
        ),
      ],
    );
  }

  String _getTitle(AppLocalizations l10n) {
    switch (action.type) {
      case ActionType.addTransaction:
        return l10n.addTransactionAction;
      case ActionType.addDebt:
        return l10n.addDebtAction;
      case ActionType.addPayment:
        return l10n.recordPaymentAction;
      case ActionType.query:
      case ActionType.summary:
        return l10n.queryInformationAction;
      case ActionType.unknown:
        return l10n.unknownAction;
    }
  }

  String _getDescription(AppLocalizations l10n) {
    switch (action.type) {
      case ActionType.addTransaction:
        return l10n.willAddTransaction;
      case ActionType.addDebt:
        return l10n.willAddDebt;
      case ActionType.addPayment:
        return l10n.willRecordPayment;
      case ActionType.query:
      case ActionType.summary:
        return l10n.willProvideInformation;
      case ActionType.unknown:
        return l10n.cannotUnderstandAction;
    }
  }

  Widget _buildDetails(AppLocalizations l10n) {
    switch (action.type) {
      case ActionType.addTransaction:
        return _buildTransactionDetails(l10n);
      case ActionType.addDebt:
        return _buildDebtDetails(l10n);
      case ActionType.addPayment:
        return _buildPaymentDetails(l10n);
      case ActionType.query:
      case ActionType.summary:
        return _buildQueryDetails(l10n);
      case ActionType.unknown:
        return Text(l10n.tryRephrasing);
    }
  }

  Widget _buildTransactionDetails(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(
          l10n.amountLabel,
          '€${action.amount?.toStringAsFixed(2) ?? 'N/A'}',
        ),
        _buildDetailRow(
          l10n.categoryLabel,
          action.category ?? l10n.unknown,
        ),
        _buildDetailRow(
          l10n.typeLabel,
          action.transactionType ?? l10n.unknown,
        ),
        if (action.notes != null)
          _buildDetailRow(
            l10n.notesLabel,
            action.notes!,
          ),
      ],
    );
  }

  Widget _buildDebtDetails(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(
          l10n.debtorLabel,
          action.debtorName ?? l10n.unknown,
        ),
        _buildDetailRow(
          l10n.amountLabel,
          '€${action.amount?.toStringAsFixed(2) ?? 'N/A'}',
        ),
        _buildDetailRow(
          l10n.categoryLabel,
          action.debtCategory ?? l10n.unknown,
        ),
        if (action.dueDate != null)
          _buildDetailRow(
            l10n.dueDateLabel,
            action.dueDate!.toLocal().toString().split(' ')[0],
          ),
      ],
    );
  }

  Widget _buildPaymentDetails(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(
          l10n.amountLabel,
          '€${action.paymentAmount ?? 'N/A'}',
        ),
        _buildDetailRow(
          l10n.debtIdLabel,
          action.debtId ?? l10n.unknown,
        ),
      ],
    );
  }

  Widget _buildQueryDetails(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(
          l10n.queryTypeLabel,
          action.queryType ?? l10n.unknown,
        ),
        if (action.timeRange != null)
          _buildDetailRow(
            l10n.timeRangeLabel,
            action.timeRange!,
          ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

