import 'package:flutter/foundation.dart' as foundation;
import 'package:pocketsage/features/ai_assistant/models/ai_action.dart';
import 'package:pocketsage/data/repositories/transaction_repository.dart';
import 'package:pocketsage/data/repositories/debts_repository.dart';
import 'package:pocketsage/data/repositories/category_repository.dart';
import 'package:pocketsage/data/models/transaction.dart';
import 'package:pocketsage/data/models/debt.dart';
import 'package:pocketsage/data/models/category.dart';
import 'package:uuid/uuid.dart';

class ActionExecutor {
  final TransactionRepository _transactionRepository;
  final DebtsRepository _debtsRepository;
  final CategoryRepository _categoryRepository;
  final String _userId;

  ActionExecutor(
    this._transactionRepository,
    this._debtsRepository,
    this._categoryRepository,
    this._userId,
  );

  Future<ActionExecutionResult> executeAction(AiAction action) async {
    foundation.debugPrint(
        'Executing action: ${action.type} with parameters: ${action.parameters}');

    if (action.hasError) {
      foundation.debugPrint('Action has error: ${action.errorMessage}');
      return ActionExecutionResult(
        success: false,
        message: action.errorMessage!,
        error: action.errorMessage!,
      );
    }

    try {
      switch (action.type) {
        case ActionType.addTransaction:
          return await _executeAddTransaction(action);
        case ActionType.addDebt:
          return await _executeAddDebt(action);
        case ActionType.addPayment:
          return await _executeAddPayment(action);
        case ActionType.query:
          return await _executeQuery(action);
        case ActionType.summary:
          return await _executeSummary(action);
        case ActionType.unknown:
          return ActionExecutionResult(
            success: false,
            message: 'Unknown action type',
            error: 'Unknown action type',
          );
      }
    } catch (e) {
      return ActionExecutionResult(
        success: false,
        message: 'Error executing action: $e',
        error: e.toString(),
      );
    }
  }

  Future<ActionExecutionResult> _executeAddTransaction(AiAction action) async {
    try {
      foundation.debugPrint(
          'Adding transaction: amount=${action.amount}, category=${action.category}, type=${action.transactionType}');

      // Find category by name
      final category = _findCategoryByName(action.category!);
      foundation.debugPrint('Found category: $category');

      if (category == null) {
        foundation.debugPrint('Category not found: ${action.category}');
        return ActionExecutionResult(
          success: false,
          message: 'Category "${action.category}" not found',
          error: 'Category not found',
        );
      }

      // Create transaction
      final transaction = FinTransaction(
        id: const Uuid().v4(),
        userId: _userId,
        amount: action.amount!,
        currency: 'EUR',
        type: action.transactionType == 'income'
            ? TransactionType.income
            : TransactionType.expense,
        categoryId: category.id,
        date: DateTime.now(),
        notes: action.notes,
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );

      foundation.debugPrint('Created transaction: $transaction');
      foundation.debugPrint('Saving transaction to repository...');
      await _transactionRepository.add(transaction);
      foundation.debugPrint('Transaction saved successfully!');

      return ActionExecutionResult(
        success: true,
        message:
            'Transaction added successfully: €${action.amount!.toStringAsFixed(2)} ${action.transactionType} for ${action.category}',
      );
    } catch (e) {
      return ActionExecutionResult(
        success: false,
        message: 'Failed to add transaction: $e',
        error: e.toString(),
      );
    }
  }

  Future<ActionExecutionResult> _executeAddDebt(AiAction action) async {
    try {
      // Find debt category by name
      final category = _findDebtCategoryByName(action.debtCategory!);
      if (category == null) {
        return ActionExecutionResult(
          success: false,
          message: 'Debt category "${action.debtCategory}" not found',
          error: 'Debt category not found',
        );
      }

      // Create debt
      final debt = Debt(
        id: const Uuid().v4(),
        userId: _userId,
        debtorName: action.debtorName!,
        totalAmount: action.amount!,
        currency: 'EUR',
        categoryId: category.id,
        dueDate: action.dueDate,
        notes: action.notes,
        payments: const [],
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );

      await _debtsRepository.add(debt);

      return ActionExecutionResult(
        success: true,
        message:
            'Debt added successfully: €${action.amount!.toStringAsFixed(2)} from ${action.debtorName} in ${action.debtCategory}',
      );
    } catch (e) {
      return ActionExecutionResult(
        success: false,
        message: 'Failed to add debt: $e',
        error: e.toString(),
      );
    }
  }

  Future<ActionExecutionResult> _executeAddPayment(AiAction action) async {
    try {
      final debtId = action.debtId!;
      final amount = double.parse(action.paymentAmount!);

      // Check if debt exists
      final debt = _debtsRepository.getById(debtId);
      if (debt == null) {
        return ActionExecutionResult(
          success: false,
          message: 'Debt with ID "$debtId" not found',
          error: 'Debt not found',
        );
      }

      // Create payment
      final payment = DebtPayment(
        id: const Uuid().v4(),
        amount: amount,
        date: DateTime.now(),
        notes: action.notes,
      );

      await _debtsRepository.addPayment(debtId, payment);

      return ActionExecutionResult(
        success: true,
        message:
            'Payment recorded successfully: €${amount.toStringAsFixed(2)} for debt from ${debt.debtorName}',
      );
    } catch (e) {
      return ActionExecutionResult(
        success: false,
        message: 'Failed to record payment: $e',
        error: e.toString(),
      );
    }
  }

  Future<ActionExecutionResult> _executeQuery(AiAction action) async {
    try {
      final queryType = action.queryType!;
      final timeRange = action.timeRange;

      // This would typically return data for the AI to process
      // For now, we'll return a success message
      return ActionExecutionResult(
        success: true,
        message:
            'Query executed: $queryType${timeRange != null ? ' for $timeRange' : ''}',
      );
    } catch (e) {
      return ActionExecutionResult(
        success: false,
        message: 'Failed to execute query: $e',
        error: e.toString(),
      );
    }
  }

  Future<ActionExecutionResult> _executeSummary(AiAction action) async {
    try {
      final summaryType = action.queryType!;
      final timeRange = action.timeRange;

      // This would typically generate a summary for the AI to process
      // For now, we'll return a success message
      return ActionExecutionResult(
        success: true,
        message:
            'Summary generated: $summaryType${timeRange != null ? ' for $timeRange' : ''}',
      );
    } catch (e) {
      return ActionExecutionResult(
        success: false,
        message: 'Failed to generate summary: $e',
        error: e.toString(),
      );
    }
  }

  Category? _findCategoryByName(String name) {
    return _categoryRepository
        .getAll()
        .where((c) => c.name.toLowerCase() == name.toLowerCase())
        .firstOrNull;
  }

  Category? _findDebtCategoryByName(String name) {
    return _categoryRepository
        .getAll()
        .where((c) =>
            c.type == CategoryType.expense &&
            c.name.toLowerCase() == name.toLowerCase())
        .firstOrNull;
  }

  List<Category> getAvailableCategories() {
    return _categoryRepository.getByType(CategoryType.expense);
  }

  List<Category> getAvailableDebtCategories() {
    return _categoryRepository.getByType(CategoryType.expense);
  }
}

class ActionExecutionResult {
  final bool success;
  final String message;
  final String? error;

  const ActionExecutionResult({
    required this.success,
    required this.message,
    this.error,
  });
}
