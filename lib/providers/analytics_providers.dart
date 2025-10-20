import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketsage/data/repositories/transaction_repository.dart';
import 'package:pocketsage/data/memory/in_memory_store.dart';
import 'package:pocketsage/providers/debt_providers.dart';
import 'package:pocketsage/providers/transaction_providers.dart';

final debtsSummaryProvider = Provider<Map<String, double>>((ref) {
  final repo = ref.watch(debtsRepositoryProvider);
  return {
    'owed': repo.getTotalOwed(),
    'paid': repo.getTotalPaid(),
    'remaining': repo.getTotalRemaining(),
  };
});

final balanceSummaryProvider = Provider<Map<String, double>>((ref) {
  if (kIsWeb) {
    final repo =
        ref.watch(transactionRepositoryProvider) as TransactionRepositoryMemory;
    return {
      'income': repo.getTotalIncome(),
      'expense': repo.getTotalExpense(),
      'balance': repo.getBalance(),
    };
  } else {
    final repo =
        ref.watch(transactionRepositoryProvider) as TransactionRepository;
    return {
      'income': repo.getTotalIncome(),
      'expense': repo.getTotalExpense(),
      'balance': repo.getBalance(),
    };
  }
});
