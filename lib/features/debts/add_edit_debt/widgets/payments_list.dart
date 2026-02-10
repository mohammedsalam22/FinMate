import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pocketsage/data/models/debt.dart';
import 'package:pocketsage/providers/providers.dart';

class PaymentsList extends ConsumerWidget {
  final Debt debt;
  
  const PaymentsList({
    super.key,
    required this.debt,
  });

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
                  subtitle: Text(
                    DateFormat.yMMMd(
                            Localizations.localeOf(context).languageCode)
                        .format(p.date),
                  ),
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
