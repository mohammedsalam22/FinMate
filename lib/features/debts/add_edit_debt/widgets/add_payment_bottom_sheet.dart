import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pocketsage/data/models/debt.dart';
import 'package:pocketsage/providers/providers.dart';
import 'package:pocketsage/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

class AddPaymentBottomSheet extends ConsumerStatefulWidget {
  final Debt debt;

  const AddPaymentBottomSheet({
    super.key,
    required this.debt,
  });

  @override
  ConsumerState<AddPaymentBottomSheet> createState() =>
      _AddPaymentBottomSheetState();
}

class _AddPaymentBottomSheetState extends ConsumerState<AddPaymentBottomSheet> {
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  Future<void> _addPayment() async {
    final l10n = AppLocalizations.of(context)!;
    final amount = double.tryParse(_amountController.text.trim());
    
    if (amount == null || amount <= 0) {
      if (mounted && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.enterValidAmount)));
      }
      return;
    }

    final payment = DebtPayment(
      id: const Uuid().v4(),
      amount: amount,
      date: _date,
      notes: _notesController.text.isEmpty
          ? null
          : _notesController.text.trim(),
    );

    await ref.read(debtsRepositoryProvider).addPayment(widget.debt.id, payment);
    ref.invalidate(debtsProvider);
    ref.invalidate(debtsSummaryProvider);

    if (mounted && context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.addPayment, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
              ],
              decoration:
                  const InputDecoration(prefixText: '€ ', hintText: '0.00'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _pickDate,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today),
                          const SizedBox(width: 8),
                          Text(DateFormat('MMM d, yyyy').format(_date)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(hintText: l10n.notesOptional),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addPayment,
                child: Text(l10n.addPayment),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

