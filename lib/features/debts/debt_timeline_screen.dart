import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pocketsage/providers/providers.dart';
import 'package:pocketsage/data/models/debt.dart';
import 'package:pocketsage/core/theme/theme.dart';
import 'package:pocketsage/features/debts/widgets/timeline_item.dart';
import 'package:uuid/uuid.dart';

class DebtTimelineScreen extends ConsumerStatefulWidget {
  final Debt? debt;
  final String? debtId;

  const DebtTimelineScreen({super.key, required this.debt}) : debtId = null;

  const DebtTimelineScreen.fromId({super.key, required this.debtId})
      : debt = null;

  @override
  ConsumerState<DebtTimelineScreen> createState() => _DebtTimelineScreenState();
}

class _DebtTimelineScreenState extends ConsumerState<DebtTimelineScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final debtsRepo = ref.watch(debtsRepositoryProvider);

    // Handle loading debt by ID if needed
    final debt = widget.debt ??
        (widget.debtId != null ? debtsRepo.getById(widget.debtId!) : null);

    if (debt == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Debt Timeline')),
        body: const Center(
          child: Text('Debt not found'),
        ),
      );
    }

    final historyTimeline = debtsRepo.getHistoryTimeline(debt.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(debt.debtorName),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/edit-debt', extra: debt),
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Card
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [
                        AppColors.primaryLight.withValues(alpha: 0.2),
                        AppColors.primaryLight.withValues(alpha: 0.1)
                      ]
                    : [
                        AppColors.primaryIndigo,
                        AppColors.primaryIndigo.withValues(alpha: 0.8)
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _SummaryMetric(
                      label: 'Total Amount',
                      value: debt.totalAmount,
                      isDark: isDark,
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                    _SummaryMetric(
                      label: 'Paid',
                      value: debt.paidAmount,
                      isDark: isDark,
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                    _SummaryMetric(
                      label: 'Remaining',
                      value: debt.remainingAmount,
                      isDark: isDark,
                    ),
                  ],
                ),
                if (debt.dueDate != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 16,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Due: ${DateFormat('MMM d, yyyy').format(debt.dueDate!)}',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
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
                  'History',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (debt.remainingAmount > 0.01)
                  TextButton.icon(
                    onPressed: _showAddPaymentDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Payment'),
                  ),
              ],
            ),
          ),
          // Timeline
          Expanded(
            child: historyTimeline.isEmpty
                ? Center(
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
                          'No history yet',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Payment history will appear here',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: historyTimeline.length,
                    itemBuilder: (context, index) {
                      final item = historyTimeline[index];
                      return TimelineItem(
                        historyItem: item,
                        isFirst: index == 0,
                        isLast: index == historyTimeline.length - 1,
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: debt.remainingAmount > 0.01
          ? FloatingActionButton.extended(
              onPressed: _showAddPaymentDialog,
              icon: const Icon(Icons.payment),
              label: const Text('Add Payment'),
              backgroundColor:
                  isDark ? AppColors.primaryLight : AppColors.primaryIndigo,
              foregroundColor: isDark ? AppColors.darkBackground : Colors.white,
            )
          : null,
    );
  }

  Future<void> _showAddPaymentDialog() async {
    final debt = widget.debt ??
        (widget.debtId != null
            ? ref.read(debtsRepositoryProvider).getById(widget.debtId!)
            : null);
    if (debt == null) return;
    final amountController = TextEditingController();
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
                Text('Add Payment',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    prefixText: '€ ',
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
                  decoration:
                      const InputDecoration(labelText: 'Notes (Optional)'),
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
                          const SnackBar(content: Text('Enter a valid amount')),
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
                          .addPayment(debt.id, payment);
                      ref.invalidate(debtsProvider);
                      ref.invalidate(debtsSummaryProvider);
                      ref.invalidate(debtsGroupedByCategoryProvider);

                      if (context.mounted) {
                        Navigator.pop(context);
                        setState(() {}); // Refresh timeline
                      }
                    },
                    child: const Text('Add Payment'),
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

  const _SummaryMetric({
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
        ),
        const SizedBox(height: 4),
        Text(
          '€${value.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}
