import 'package:pocketsage/data/repositories/transaction_repository.dart';
import 'package:pocketsage/data/repositories/debts_repository.dart';
import 'package:pocketsage/data/repositories/category_repository.dart';
import 'package:pocketsage/data/models/transaction.dart';
import 'package:pocketsage/data/models/debt.dart';
import 'package:pocketsage/data/models/category.dart';
import 'package:intl/intl.dart';

class ContextBuilder {
  final TransactionRepository _transactionRepository;
  final DebtsRepository _debtsRepository;
  final CategoryRepository _categoryRepository;

  ContextBuilder(
    this._transactionRepository,
    this._debtsRepository,
    this._categoryRepository,
    String userId,
  );

  String buildFinancialContext() {
    final balance = _transactionRepository.getBalance();
    final totalIncome = _transactionRepository.getTotalIncome();
    final totalExpense = _transactionRepository.getTotalExpense();

    final recentTransactions = _getRecentTransactionsSummary();
    final topCategories = _getTopSpendingCategories();
    final debtSummary = _getDebtSummary();

    return '''
Current Financial Status:
- Balance: €${balance.toStringAsFixed(2)}
- Total Income: €${totalIncome.toStringAsFixed(2)}
- Total Expenses: €${totalExpense.toStringAsFixed(2)}

Recent Activity (Last 7 days):
$recentTransactions

Top Spending Categories:
$topCategories

Debt Summary:
$debtSummary
''';
  }

  String _getRecentTransactionsSummary() {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));

    final recentTransactions =
        _transactionRepository.getByDateRange(weekAgo, now);

    if (recentTransactions.isEmpty) {
      return '- No transactions in the last 7 days';
    }

    final income = recentTransactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);

    final expenses = recentTransactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);

    return '''
- ${recentTransactions.length} transactions
- Income: €${income.toStringAsFixed(2)}
- Expenses: €${expenses.toStringAsFixed(2)}
- Net: €${(income - expenses).toStringAsFixed(2)}''';
  }

  String _getTopSpendingCategories() {
    final expensesByCategory = _transactionRepository.getExpensesByCategory();

    if (expensesByCategory.isEmpty) {
      return '- No expense categories found';
    }

    // Sort by amount descending and take top 5
    final sortedCategories = expensesByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final top5 = sortedCategories.take(5);

    return top5.map((entry) {
      final category = _categoryRepository.getById(entry.key);
      final categoryName = category?.name ?? 'Unknown';
      return '- $categoryName: €${entry.value.toStringAsFixed(2)}';
    }).join('\n');
  }

  String _getDebtSummary() {
    final allDebts = _debtsRepository.getAll();

    if (allDebts.isEmpty) {
      return '- No outstanding debts';
    }

    final totalOwed = _debtsRepository.getTotalOwed();
    final totalPaid = _debtsRepository.getTotalPaid();
    final totalRemaining = _debtsRepository.getTotalRemaining();

    final overdueDebts = allDebts.where((d) => d.isOverdue).length;

    return '''
- Total Debts: ${allDebts.length}
- Total Owed: €${totalOwed.toStringAsFixed(2)}
- Total Paid: €${totalPaid.toStringAsFixed(2)}
- Remaining: €${totalRemaining.toStringAsFixed(2)}
- Overdue: $overdueDebts debts''';
  }

  String buildTransactionContext(List<FinTransaction> transactions) {
    if (transactions.isEmpty) {
      return 'No transactions found for the specified criteria.';
    }

    final income = transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);

    final expenses = transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);

    final dateRange = _getDateRange(transactions);

    return '''
Found ${transactions.length} transactions ($dateRange):
- Income: €${income.toStringAsFixed(2)}
- Expenses: €${expenses.toStringAsFixed(2)}
- Net: €${(income - expenses).toStringAsFixed(2)}

Recent transactions:
${transactions.take(5).map((t) => _formatTransaction(t)).join('\n')}
''';
  }

  String buildDebtContext(List<Debt> debts) {
    if (debts.isEmpty) {
      return 'No debts found for the specified criteria.';
    }

    final totalOwed = debts.fold(0.0, (sum, d) => sum + d.totalAmount);
    final totalRemaining = debts.fold(0.0, (sum, d) => sum + d.remainingAmount);

    return '''
Found ${debts.length} debts:
- Total Owed: €${totalOwed.toStringAsFixed(2)}
- Total Remaining: €${totalRemaining.toStringAsFixed(2)}

Debts by person:
${debts.map((d) => _formatDebt(d)).join('\n')}
''';
  }

  String _getDateRange(List<FinTransaction> transactions) {
    if (transactions.isEmpty) return '';

    final dates = transactions.map((t) => t.date).toList()..sort();
    final start = dates.first;
    final end = dates.last;

    final formatter = DateFormat('MMM dd');
    return '${formatter.format(start)} - ${formatter.format(end)}';
  }

  String _formatTransaction(FinTransaction transaction) {
    final category = _categoryRepository.getById(transaction.categoryId);
    final categoryName = category?.name ?? 'Unknown';
    final type = transaction.type == TransactionType.income ? '+' : '-';
    final date = DateFormat('MMM dd').format(transaction.date);

    return '- $date: $type€${transaction.amount.toStringAsFixed(2)} ($categoryName)';
  }

  String _formatDebt(Debt debt) {
    final category = _categoryRepository.getById(debt.categoryId);
    final categoryName = category?.name ?? 'Unknown';
    final status = debt.isSettled ? 'Settled' : 'Outstanding';

    return '- ${debt.debtorName}: €${debt.remainingAmount.toStringAsFixed(2)} ($categoryName) - $status';
  }

  List<String> getAvailableCategories() {
    return _categoryRepository.getAll().map((c) => c.name).toList();
  }

  List<String> getAvailableDebtCategories() {
    return _categoryRepository
        .getAll()
        .where((c) => c.type == CategoryType.expense)
        .map((c) => c.name)
        .toList();
  }
}
