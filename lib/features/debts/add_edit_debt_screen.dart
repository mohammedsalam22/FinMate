import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pocketsage/providers/providers.dart';
import 'package:pocketsage/data/models/debt.dart';
import 'package:pocketsage/core/theme/theme.dart';
import 'package:pocketsage/features/debts/widgets/category_selector.dart';
import 'package:pocketsage/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

class AddEditDebtScreen extends ConsumerStatefulWidget {
  final Debt? debt;
  final String? categoryId;
  const AddEditDebtScreen({super.key, this.debt, this.categoryId});

  @override
  ConsumerState<AddEditDebtScreen> createState() => _AddEditDebtScreenState();
}

class _AddEditDebtScreenState extends ConsumerState<AddEditDebtScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _dueDate;
  String _selectedCategoryId = 'uncategorized';

  @override
  void initState() {
    super.initState();
    final debt = widget.debt;
    if (debt != null) {
      _nameController.text = debt.debtorName;
      _amountController.text = debt.totalAmount.toStringAsFixed(2);
      _notesController.text = debt.notes ?? '';
      _dueDate = debt.dueDate;
      _selectedCategoryId = debt.categoryId;
    } else if (widget.categoryId != null) {
      _selectedCategoryId = widget.categoryId!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (date != null) setState(() => _dueDate = date);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final repo = ref.read(debtsRepositoryProvider);
    final user = ref.read(currentUserProvider);

    if (widget.debt == null) {
      final debt = Debt(
        id: const Uuid().v4(),
        userId: user.id,
        debtorName: _nameController.text.trim(),
        totalAmount: double.parse(_amountController.text),
        categoryId: _selectedCategoryId,
        dueDate: _dueDate,
        notes:
            _notesController.text.isEmpty ? null : _notesController.text.trim(),
        payments: const [],
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );
      await repo.add(debt);
    } else {
      final updated = widget.debt!.copyWith(
        debtorName: _nameController.text.trim(),
        totalAmount: double.parse(_amountController.text),
        categoryId: _selectedCategoryId,
        dueDate: _dueDate,
        notes:
            _notesController.text.isEmpty ? null : _notesController.text.trim(),
        updatedAt: DateTime.now().toUtc(),
      );
      await repo.update(updated);
    }

    ref.invalidate(debtsProvider);
    ref.invalidate(debtsSummaryProvider);
    ref.invalidate(debtsGroupedByCategoryProvider);

    if (mounted) {
      context.pop();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Saved successfully')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.debt == null ? l10n.addDebt : l10n.editDebt),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.debtorName,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(hintText: l10n.nameExample),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? l10n.enterName : null,
                ),
                const SizedBox(height: 20),
                Text(l10n.totalAmount,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                  ],
                  decoration:
                      const InputDecoration(hintText: '0.00', prefixText: '€ '),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter an amount';
                    final parsed = double.tryParse(v);
                    if (parsed == null || parsed <= 0)
                      return 'Enter a valid amount';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CategorySelector(
                  selectedCategoryId: _selectedCategoryId,
                  onCategorySelected: (categoryId) {
                    setState(() {
                      _selectedCategoryId = categoryId;
                    });
                  },
                ),
                const SizedBox(height: 20),
                Text('Due date (optional)',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _pickDueDate,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurface
                          : AppColors.lightSurface,
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
                            color: isDark
                                ? AppColors.primaryLight
                                : AppColors.primaryIndigo),
                        const SizedBox(width: 12),
                        Text(_dueDate == null
                            ? 'No due date'
                            : DateFormat('MMM d, yyyy').format(_dueDate!)),
                        const Spacer(),
                        if (_dueDate != null)
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => setState(() => _dueDate = null),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text('Notes (optional)',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: const InputDecoration(hintText: 'Add a note...'),
                ),
                const SizedBox(height: 24),
                if (widget.debt != null) ...[
                  Text('Payments',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  _PaymentsList(debt: widget.debt!),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _showAddPayment,
                      icon: const Icon(Icons.add),
                      label: const Text('Add payment'),
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _save,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                          widget.debt == null ? 'Create Debt' : 'Save Changes'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showAddPayment() async {
    final amountController = TextEditingController();
    DateTime date = DateTime.now();
    final notesController = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final bottomInset = MediaQuery.of(context).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: StatefulBuilder(builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Add payment',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: amountController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'))
                    ],
                    decoration: const InputDecoration(
                        prefixText: '€ ', hintText: '0.00'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: date,
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now()
                                  .add(const Duration(days: 3650)),
                            );
                            if (picked != null)
                              setModalState(() => date = picked);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey.withValues(alpha: 0.2)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today),
                                const SizedBox(width: 8),
                                Text(DateFormat('MMM d, yyyy').format(date)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: notesController,
                    decoration:
                        const InputDecoration(hintText: 'Notes (optional)'),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final amount =
                            double.tryParse(amountController.text.trim());
                        if (amount == null || amount <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Enter a valid amount')));
                          return;
                        }
                        final payment = DebtPayment(
                          id: const Uuid().v4(),
                          amount: amount,
                          date: date,
                          notes: notesController.text.isEmpty
                              ? null
                              : notesController.text.trim(),
                        );
                        await ref
                            .read(debtsRepositoryProvider)
                            .addPayment(widget.debt!.id, payment);
                        ref.invalidate(debtsProvider);
                        ref.invalidate(debtsSummaryProvider);
                        if (mounted) Navigator.pop(context);
                      },
                      child: const Text('Add payment'),
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}

class _PaymentsList extends ConsumerWidget {
  final Debt debt;
  const _PaymentsList({required this.debt});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(debtsRepositoryProvider);
    final payments = debt.payments.toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    return Column(
      children: payments
          .map((p) => Card(
                child: ListTile(
                  leading: const Icon(Icons.payments),
                  title: Text('€${p.amount.toStringAsFixed(2)}'),
                  subtitle: Text(DateFormat('MMM d, yyyy').format(p.date)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      await repo.removePayment(debt.id, p.id);
                      ref.invalidate(debtsProvider);
                      ref.invalidate(debtsSummaryProvider);
                    },
                  ),
                ),
              ))
          .toList(),
    );
  }
}
