import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pocketsage/providers/providers.dart';
import 'package:pocketsage/data/models/debt.dart';
import 'package:pocketsage/data/models/debt_category.dart';
import 'package:pocketsage/core/theme/theme.dart';
import 'package:pocketsage/features/debts/widgets/timeline_item.dart';
import 'package:pocketsage/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

class PersonTimelineScreen extends ConsumerStatefulWidget {
  final String categoryId;
  final String personName;

  const PersonTimelineScreen({
    super.key,
    required this.categoryId,
    required this.personName,
  });

  @override
  ConsumerState<PersonTimelineScreen> createState() =>
      _PersonTimelineScreenState();
}

class _PersonTimelineScreenState extends ConsumerState<PersonTimelineScreen> {
  Future<void> _deleteDebt(String debtId) async {
    try {
      await ref.read(debtsRepositoryProvider).delete(debtId);
      ref.invalidate(debtsProvider);
      ref.invalidate(debtsSummaryProvider);
      ref.invalidate(debtsGroupedByCategoryProvider);

      if (mounted) {
        setState(() {}); // Refresh the timeline
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorDeletingDebt(e.toString()))),
        );
      }
    }
  }

  Future<void> _deletePayment(String debtId, String paymentId) async {
    try {
      await ref.read(debtsRepositoryProvider).removePayment(debtId, paymentId);
      ref.invalidate(debtsProvider);
      ref.invalidate(debtsSummaryProvider);
      ref.invalidate(debtsGroupedByCategoryProvider);

      if (mounted) {
        setState(() {}); // Refresh the timeline
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorDeletingPayment(e.toString()))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final categoryRepo = ref.watch(debtCategoryRepositoryProvider);
    final debtsRepo = ref.watch(debtsRepositoryProvider);

    final category = categoryRepo.getById(widget.categoryId);
    if (category == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.categoryNotFound)),
        body: Center(child: Text(l10n.categoryNotFoundText)),
      );
    }

    final personDebts =
        debtsRepo.getDebtsByPerson(widget.personName, widget.categoryId);

    // Create a combined timeline of all debts and payments for this person
    final allHistoryItems = <DebtHistoryItem>[];
    final itemToDebtIdMap =
        <String, String>{}; // Maps timeline item ID to debt ID
    double totalOwed = 0;
    double totalPaid = 0;
    double totalRemaining = 0;

    for (final debt in personDebts) {
      totalOwed += debt.totalAmount;
      totalPaid += debt.paidAmount;
      totalRemaining += debt.remainingAmount;

      // Add debt creation event
      final debtCreatedId = '${debt.id}_created';
      allHistoryItems.add(DebtHistoryItem(
        id: debtCreatedId,
        type: DebtHistoryType.debtCreated,
        amount: debt.totalAmount,
        date: debt.createdAt,
        notes: debt.notes,
        runningBalance: debt.totalAmount,
      ));
      itemToDebtIdMap[debtCreatedId] = debt.id;

      // Add payment events
      double runningBalance = debt.totalAmount;
      for (final payment in debt.payments) {
        runningBalance -= payment.amount;
        allHistoryItems.add(DebtHistoryItem(
          id: payment.id,
          type: DebtHistoryType.payment,
          amount: payment.amount,
          date: payment.date,
          notes: payment.notes,
          runningBalance: runningBalance,
        ));
        itemToDebtIdMap[payment.id] = debt.id; // Map payment to its debt
      }
    }

    // Sort by date (newest first)
    allHistoryItems.sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.personName),
        backgroundColor: Color(category.color).withValues(alpha: 0.1),
        foregroundColor: Color(category.color),
      ),
      body: Column(
        children: [
          // Summary Card
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(category.color).withValues(alpha: 0.1),
                  Color(category.color).withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Color(category.color).withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _SummaryMetric(
                      label: l10n.totalOwed,
                      value: totalOwed,
                      isDark: isDark,
                      color: Color(category.color),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Color(category.color).withValues(alpha: 0.3),
                    ),
                    _SummaryMetric(
                      label: l10n.paid,
                      value: totalPaid,
                      isDark: isDark,
                      color: AppColors.successGreen,
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Color(category.color).withValues(alpha: 0.3),
                    ),
                    _SummaryMetric(
                      label: l10n.remaining,
                      value: totalRemaining,
                      isDark: isDark,
                      color: totalRemaining > 0
                          ? AppColors.errorRose
                          : AppColors.successGreen,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.inCategory(category.name),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Color(category.color),
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
          // Timeline Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.history,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () => _showAddDebtDialog(),
                      icon: const Icon(Icons.receipt_long),
                      label: Text(l10n.addDebtButton),
                    ),
                    if (totalRemaining > 0.01)
                      TextButton.icon(
                        onPressed: () => _showAddPaymentDialog(),
                        icon: const Icon(Icons.payment),
                        label: Text(l10n.addPaymentButton),
                      ),
                  ],
                ),
              ],
            ),
          ),
          // Timeline
          Expanded(
            child: allHistoryItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 80,
                          color: Color(category.color).withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noHistoryYet,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.addFirstDebtOrPayment,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: _showAddDebtDialog,
                              icon: const Icon(Icons.receipt_long),
                              label: Text(l10n.addDebtButton),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(category.color),
                                foregroundColor: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 16),
                            if (totalRemaining > 0.01)
                              ElevatedButton.icon(
                                onPressed: _showAddPaymentDialog,
                                icon: const Icon(Icons.payment),
                                label: Text(l10n.addPaymentButton),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.successGreen,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: allHistoryItems.length,
                    itemBuilder: (context, index) {
                      final item = allHistoryItems[index];
                      final debtId = itemToDebtIdMap[item.id];

                      return TimelineItem(
                        historyItem: item,
                        isFirst: index == 0,
                        isLast: index == allHistoryItems.length - 1,
                        onDelete: debtId != null
                            ? () {
                                if (item.type == DebtHistoryType.debtCreated) {
                                  _deleteDebt(debtId);
                                } else {
                                  _deletePayment(debtId, item.id);
                                }
                              }
                            : null,
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (totalRemaining > 0.01)
            FloatingActionButton(
              onPressed: _showAddPaymentDialog,
              heroTag: "payment",
              backgroundColor: AppColors.successGreen,
              child: const Icon(Icons.payment, color: Colors.white),
            ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: _showAddDebtDialog,
            heroTag: "debt",
            backgroundColor: Color(category.color),
            child: const Icon(Icons.receipt_long, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddDebtDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final amountController = TextEditingController();
    final notesController = TextEditingController();
    DateTime dueDate = DateTime.now();
    DateTime? selectedDueDate;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
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
                  controller: amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
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
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDueDate ?? dueDate,
                      firstDate: DateTime.now(),
                      lastDate:
                          DateTime.now().add(const Duration(days: 365 * 5)),
                    );
                    if (date != null)
                      setModalState(() => selectedDueDate = date);
                  },
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
                        Text(selectedDueDate == null
                            ? l10n.dueDateOptionalLabel
                            : DateFormat('MMM d, yyyy')
                                .format(selectedDueDate!)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: notesController,
                  decoration: InputDecoration(labelText: l10n.notesOptional),
                  maxLines: 2,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final amount =
                          double.tryParse(amountController.text.trim());
                      if (amount == null || amount <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.enterValidAmount)),
                        );
                        return;
                      }

                      final user = ref.read(currentUserProvider);
                      final debt = Debt(
                        id: const Uuid().v4(),
                        userId: user.id,
                        debtorName: widget.personName,
                        totalAmount: amount,
                        categoryId: widget.categoryId,
                        dueDate: selectedDueDate,
                        notes: notesController.text.isEmpty
                            ? null
                            : notesController.text.trim(),
                        payments: const [],
                        createdAt: DateTime.now().toUtc(),
                        updatedAt: DateTime.now().toUtc(),
                      );

                      await ref.read(debtsRepositoryProvider).add(debt);
                      ref.invalidate(debtsProvider);
                      ref.invalidate(debtsSummaryProvider);
                      ref.invalidate(debtsGroupedByCategoryProvider);

                      if (context.mounted) {
                        Navigator.pop(context);
                        setState(() {}); // Refresh timeline
                      }
                    },
                    child: Text(l10n.addDebtButton),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        });
      },
    );
  }

  Future<void> _showAddPaymentDialog() async {
    final l10n = AppLocalizations.of(context)!;
    // Get the first debt with remaining amount to make a payment
    final personDebts = ref
        .read(debtsRepositoryProvider)
        .getDebtsByPerson(widget.personName, widget.categoryId);
    final debtWithRemaining =
        personDebts.where((debt) => debt.remainingAmount > 0.01).firstOrNull;

    if (debtWithRemaining == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.noRemainingDebt)),
      );
      return;
    }

    final amountController = TextEditingController(
        text: debtWithRemaining.remainingAmount.toStringAsFixed(2));
    DateTime paymentDate = DateTime.now();
    final notesController = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
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
                  controller: amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: l10n.amount,
                    prefixText: '€ ',
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.forPerson(widget.personName),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: paymentDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) setModalState(() => paymentDate = date);
                  },
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
                        Text(DateFormat('MMM d, yyyy').format(paymentDate)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: notesController,
                  decoration: InputDecoration(labelText: l10n.notesOptional),
                  maxLines: 2,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final amount =
                          double.tryParse(amountController.text.trim());
                      if (amount == null || amount <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.enterValidAmount)),
                        );
                        return;
                      }

                      final payment = DebtPayment(
                        id: const Uuid().v4(),
                        amount: amount,
                        date: paymentDate,
                        notes: notesController.text.isEmpty
                            ? null
                            : notesController.text.trim(),
                      );

                      await ref
                          .read(debtsRepositoryProvider)
                          .addPayment(debtWithRemaining.id, payment);
                      ref.invalidate(debtsProvider);
                      ref.invalidate(debtsSummaryProvider);
                      ref.invalidate(debtsGroupedByCategoryProvider);

                      if (context.mounted) {
                        Navigator.pop(context);
                        setState(() {}); // Refresh timeline
                      }
                    },
                    child: Text(l10n.addPaymentButton),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        });
      },
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  final String label;
  final double value;
  final bool isDark;
  final Color color;

  const _SummaryMetric({
    required this.label,
    required this.value,
    required this.isDark,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color.withValues(alpha: 0.8),
              ),
        ),
        const SizedBox(height: 4),
        Text(
          '€${value.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}
