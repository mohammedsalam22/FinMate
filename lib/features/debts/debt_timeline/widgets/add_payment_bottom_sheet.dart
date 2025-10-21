import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pocketsage/data/models/debt.dart';
import 'package:pocketsage/providers/providers.dart';
import 'package:pocketsage/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

class AddPaymentBottomSheet extends ConsumerStatefulWidget {
  final Debt debt;
  final VoidCallback onPaymentAdded;

  const AddPaymentBottomSheet({
    super.key,
    required this.debt,
    required this.onPaymentAdded,
  });

  @override
  ConsumerState<AddPaymentBottomSheet> createState() =>
      _AddPaymentBottomSheetState();
}

class _AddPaymentBottomSheetState
    extends ConsumerState<AddPaymentBottomSheet> {
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _paymentDate = DateTime.now();

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _paymentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _paymentDate = date);
    }
  }

  Future<void> _addPayment() async {
    final l10n = AppLocalizations.of(context)!;
    final amount = double.tryParse(_amountController.text.trim());

    if (amount == null || amount <= 0) {
      if (mounted && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.enterValidAmount)),
        );
      }
      return;
    }

    final payment = DebtPayment(
      id: const Uuid().v4(),
      amount: amount,
      date: _paymentDate,
      notes: _notesController.text.isEmpty
          ? null
          : _notesController.text.trim(),
    );

    await ref.read(debtsRepositoryProvider).addPayment(widget.debt.id, payment);
    ref.invalidate(debtsProvider);
    ref.invalidate(debtsSummaryProvider);
    ref.invalidate(debtsGroupedByCategoryProvider);

    if (mounted && context.mounted) {
      Navigator.pop(context);
      widget.onPaymentAdded();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.addPaymentButton,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: l10n.amount,
              prefixText: '€ ',
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: _pickDate,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: 12),
                  Text(DateFormat('MMM d, yyyy').format(_paymentDate)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notesController,
            decoration: InputDecoration(labelText: l10n.notesOptional),
            maxLines: 2,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _addPayment,
              child: Text(l10n.addPaymentButton),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

