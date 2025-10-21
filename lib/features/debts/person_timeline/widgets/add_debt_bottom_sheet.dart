import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pocketsage/data/models/debt.dart';
import 'package:pocketsage/providers/providers.dart';
import 'package:pocketsage/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

class AddDebtBottomSheet extends ConsumerStatefulWidget {
  final String personName;
  final String categoryId;
  final VoidCallback onDebtAdded;

  const AddDebtBottomSheet({
    super.key,
    required this.personName,
    required this.categoryId,
    required this.onDebtAdded,
  });

  @override
  ConsumerState<AddDebtBottomSheet> createState() => _AddDebtBottomSheetState();
}

class _AddDebtBottomSheetState extends ConsumerState<AddDebtBottomSheet> {
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime? _selectedDueDate;

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (date != null) {
      setState(() => _selectedDueDate = date);
    }
  }

  Future<void> _addDebt() async {
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

    final user = ref.read(currentUserProvider);
    final debt = Debt(
      id: const Uuid().v4(),
      userId: user.id,
      debtorName: widget.personName,
      totalAmount: amount,
      categoryId: widget.categoryId,
      dueDate: _selectedDueDate,
      notes:
          _notesController.text.isEmpty ? null : _notesController.text.trim(),
      payments: const [],
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );

    await ref.read(debtsRepositoryProvider).add(debt);
    ref.invalidate(debtsProvider);
    ref.invalidate(debtsSummaryProvider);
    ref.invalidate(debtsGroupedByCategoryProvider);

    if (mounted && context.mounted) {
      Navigator.pop(context);
      widget.onDebtAdded();
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
          Text(l10n.addDebtButton,
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
          Text(
            l10n.personLabel(widget.personName),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: _pickDueDate,
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
                  Text(_selectedDueDate == null
                      ? l10n.dueDateOptionalLabel
                      : DateFormat('MMM d, yyyy').format(_selectedDueDate!)),
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
              onPressed: _addDebt,
              child: Text(l10n.addDebtButton),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
