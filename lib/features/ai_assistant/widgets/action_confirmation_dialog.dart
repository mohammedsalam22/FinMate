import 'package:flutter/material.dart';
import 'package:pocketsage/features/ai_assistant/models/ai_action.dart';

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
    return AlertDialog(
      title: Text(_getTitle()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_getDescription()),
          const SizedBox(height: 16),
          _buildDetails(),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          child: const Text('Confirm'),
        ),
      ],
    );
  }

  String _getTitle() {
    switch (action.type) {
      case ActionType.addTransaction:
        return 'Add Transaction';
      case ActionType.addDebt:
        return 'Add Debt';
      case ActionType.addPayment:
        return 'Record Payment';
      case ActionType.query:
      case ActionType.summary:
        return 'Query Information';
      case ActionType.unknown:
        return 'Unknown Action';
    }
  }

  String _getDescription() {
    switch (action.type) {
      case ActionType.addTransaction:
        return 'I will add this transaction to your records:';
      case ActionType.addDebt:
        return 'I will add this debt to your records:';
      case ActionType.addPayment:
        return 'I will record this payment:';
      case ActionType.query:
      case ActionType.summary:
        return 'I will provide information about:';
      case ActionType.unknown:
        return 'I cannot understand this action.';
    }
  }

  Widget _buildDetails() {
    switch (action.type) {
      case ActionType.addTransaction:
        return _buildTransactionDetails();
      case ActionType.addDebt:
        return _buildDebtDetails();
      case ActionType.addPayment:
        return _buildPaymentDetails();
      case ActionType.query:
      case ActionType.summary:
        return _buildQueryDetails();
      case ActionType.unknown:
        return const Text('Please try rephrasing your request.');
    }
  }

  Widget _buildTransactionDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(
            'Amount', '€${action.amount?.toStringAsFixed(2) ?? 'N/A'}'),
        _buildDetailRow('Category', action.category ?? 'N/A'),
        _buildDetailRow('Type', action.transactionType ?? 'N/A'),
        if (action.notes != null) _buildDetailRow('Notes', action.notes!),
      ],
    );
  }

  Widget _buildDebtDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Debtor', action.debtorName ?? 'N/A'),
        _buildDetailRow(
            'Amount', '€${action.amount?.toStringAsFixed(2) ?? 'N/A'}'),
        _buildDetailRow('Category', action.debtCategory ?? 'N/A'),
        if (action.dueDate != null)
          _buildDetailRow(
              'Due Date', action.dueDate!.toLocal().toString().split(' ')[0]),
      ],
    );
  }

  Widget _buildPaymentDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Amount', '€${action.paymentAmount ?? 'N/A'}'),
        _buildDetailRow('Debt ID', action.debtId ?? 'N/A'),
      ],
    );
  }

  Widget _buildQueryDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Query Type', action.queryType ?? 'N/A'),
        if (action.timeRange != null)
          _buildDetailRow('Time Range', action.timeRange!),
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

