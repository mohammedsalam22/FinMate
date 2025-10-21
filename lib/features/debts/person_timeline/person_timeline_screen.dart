import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketsage/providers/providers.dart';
import 'package:pocketsage/data/models/debt.dart';
import 'package:pocketsage/core/theme/theme.dart';
import 'package:pocketsage/features/debts/shared/timeline_item.dart';
import 'package:pocketsage/features/debts/person_timeline/widgets/person_summary_card.dart';
import 'package:pocketsage/features/debts/person_timeline/widgets/add_debt_bottom_sheet.dart';
import 'package:pocketsage/features/debts/person_timeline/widgets/add_payment_bottom_sheet.dart';
import 'package:pocketsage/features/debts/debt_timeline/widgets/history_table_view.dart';
import 'package:pocketsage/features/debts/debt_timeline/widgets/empty_history_state.dart';
import 'package:pocketsage/l10n/app_localizations.dart';

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
  bool _isTableView = false;

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
        actions: [
          IconButton(
            icon: Icon(_isTableView ? Icons.view_list : Icons.table_chart),
            onPressed: () {
              setState(() {
                _isTableView = !_isTableView;
              });
            },
            tooltip: _isTableView ? l10n.timelineView : l10n.tableView,
          ),
        ],
      ),
      body: Column(
        children: [
          PersonSummaryCard(
            category: category,
            totalOwed: totalOwed,
            totalPaid: totalPaid,
            totalRemaining: totalRemaining,
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
          // Timeline or Table View
          Expanded(
            child: allHistoryItems.isEmpty
                ? const EmptyHistoryState()
                : _isTableView
                    ? HistoryTableView(historyTimeline: allHistoryItems)
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
                                    if (item.type ==
                                        DebtHistoryType.debtCreated) {
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
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddDebtBottomSheet(
        personName: widget.personName,
        categoryId: widget.categoryId,
        onDebtAdded: () {
          if (mounted) {
            setState(() {}); // Refresh timeline
          }
        },
      ),
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
      if (mounted && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.noRemainingDebt)),
        );
      }
      return;
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddPaymentBottomSheet(
        debtWithRemaining: debtWithRemaining,
        personName: widget.personName,
        onPaymentAdded: () {
          if (mounted) {
            setState(() {}); // Refresh timeline
          }
        },
      ),
    );
  }
}
