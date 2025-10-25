import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketsage/providers/app_providers.dart';
import 'package:pocketsage/providers/transaction_providers.dart';
import 'package:pocketsage/providers/debt_providers.dart';
import 'package:pocketsage/providers/category_providers.dart';
import 'package:pocketsage/features/ai_assistant/ai_service.dart';
import 'package:pocketsage/features/ai_assistant/context_builder.dart';
import 'package:pocketsage/features/ai_assistant/action_executor.dart';

// AI Service Provider
final aiServiceProvider = Provider<AiService>((ref) {
  final contextBuilder = ref.watch(contextBuilderProvider);
  return AiService(contextBuilder);
});

// Context Builder Provider
final contextBuilderProvider = Provider<ContextBuilder>((ref) {
  final transactionRepository = ref.watch(transactionRepositoryProvider);
  final debtsRepository = ref.watch(debtsRepositoryProvider);
  final categoryRepository = ref.watch(categoryRepositoryProvider);
  final userId = ref.watch(currentUserProvider).id;

  return ContextBuilder(
    transactionRepository as dynamic,
    debtsRepository,
    categoryRepository as dynamic,
    userId,
  );
});

// Action Executor Provider
final actionExecutorProvider = Provider<ActionExecutor>((ref) {
  final transactionRepository = ref.watch(transactionRepositoryProvider);
  final debtsRepository = ref.watch(debtsRepositoryProvider);
  final categoryRepository = ref.watch(categoryRepositoryProvider);
  final userId = ref.watch(currentUserProvider).id;

  return ActionExecutor(
    transactionRepository as dynamic,
    debtsRepository,
    categoryRepository as dynamic,
    userId,
  );
});
