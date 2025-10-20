import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocketsage/core/constants/constants.dart';
import 'package:pocketsage/data/models/transaction.dart';
import 'package:pocketsage/data/repositories/transaction_repository.dart';
import 'package:pocketsage/data/memory/in_memory_store.dart';
import 'package:pocketsage/providers/app_providers.dart';

final transactionBoxEventsProvider = StreamProvider<BoxEvent>((ref) {
  return Hive.box<FinTransaction>(HiveBoxes.transactions).watch();
});

final transactionRepositoryProvider = Provider<dynamic>((ref) {
  final user = ref.watch(currentUserProvider);
  if (kIsWeb) {
    return TransactionRepositoryMemory(user.id);
  } else {
    final box = Hive.box<FinTransaction>(HiveBoxes.transactions);
    return TransactionRepository(box, user.id);
  }
});

final transactionsProvider = Provider<List<FinTransaction>>((ref) {
  if (kIsWeb) {
    final repository =
        ref.watch(transactionRepositoryProvider) as TransactionRepositoryMemory;
    return repository.getAll();
  } else {
    // Watch Hive box events to refresh on changes
    ref.watch(transactionBoxEventsProvider);
    final repository =
        ref.watch(transactionRepositoryProvider) as TransactionRepository;
    return repository.getAll();
  }
});
