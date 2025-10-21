import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketsage/providers/providers.dart';
import 'package:pocketsage/data/models/debt.dart';
import 'package:pocketsage/core/theme/theme.dart';
import 'package:pocketsage/features/debts/shared/timeline_item.dart';
import 'package:pocketsage/features/debts/debt_timeline/widgets/debt_summary_card.dart';
import 'package:pocketsage/features/debts/debt_timeline/widgets/history_table_view.dart';
import 'package:pocketsage/features/debts/debt_timeline/widgets/empty_history_state.dart';
import 'package:pocketsage/features/debts/debt_timeline/widgets/add_payment_bottom_sheet.dart';
import 'package:pocketsage/l10n/app_localizations.dart';

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
  bool _isTableView = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final debtsRepo = ref.watch(debtsRepositoryProvider);

    // Handle loading debt by ID if needed
    final debt = widget.debt ??
        (widget.debtId != null ? debtsRepo.getById(widget.debtId!) : null);

    if (debt == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.debtTimeline)),
        body: Center(
          child: Text(l10n.debtNotFound),
        ),
      );
    }

    final historyTimeline = debtsRepo.getHistoryTimeline(debt.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(debt.debtorName),
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
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/edit-debt', extra: debt),
          ),
        ],
      ),
      body: Column(
        children: [
          DebtSummaryCard(debt: debt),
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
                if (debt.remainingAmount > 0.01)
                  TextButton.icon(
                    onPressed: _showAddPaymentDialog,
                    icon: const Icon(Icons.add),
                    label: Text(l10n.addPaymentButton),
                  ),
              ],
            ),
          ),
          // Timeline or Table View
          Expanded(
            child: historyTimeline.isEmpty
                ? const EmptyHistoryState()
                : _isTableView
                    ? HistoryTableView(historyTimeline: historyTimeline)
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
              label: Text(l10n.addPaymentButton),
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

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddPaymentBottomSheet(
        debt: debt,
        onPaymentAdded: () {
          if (mounted) {
            setState(() {}); // Refresh timeline
          }
        },
      ),
    );
  }
}
