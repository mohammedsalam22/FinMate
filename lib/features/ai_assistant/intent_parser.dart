import 'package:pocketsage/features/ai_assistant/models/ai_action.dart';

class IntentParser {
  static AiAction parseAction(String actionString) {
    try {
      // Parse ACTION:ACTION_TYPE|param1|param2|param3 format
      final parts = actionString.split('|');
      if (parts.isEmpty) {
        return _createErrorAction('Invalid action format');
      }

      final actionPart = parts[0];
      if (!actionPart.startsWith('ACTION:')) {
        return _createErrorAction('Action must start with ACTION:');
      }

      final actionType = actionPart.substring(7); // Remove 'ACTION:' prefix

      // Parse parameters based on action type
      switch (actionType.toUpperCase()) {
        case 'ADD_TRANSACTION':
          return _parseAddTransactionAction(parts);
        case 'ADD_DEBT':
          return _parseAddDebtAction(parts);
        case 'ADD_PAYMENT':
          return _parseAddPaymentAction(parts);
        case 'QUERY':
          return _parseQueryAction(parts);
        case 'SUMMARY':
          return _parseSummaryAction(parts);
        default:
          return _createErrorAction('Unknown action type: $actionType');
      }
    } catch (e) {
      return _createErrorAction('Error parsing action: $e');
    }
  }

  static AiAction _parseAddTransactionAction(List<String> parts) {
    if (parts.length < 4) {
      return _createErrorAction(
          'ADD_TRANSACTION requires at least 4 parameters: amount|category|type|notes');
    }

    try {
      final amount = double.parse(parts[1]);
      final category = parts[2];
      final type = parts[3].toLowerCase();
      final notes = parts.length > 4 ? parts[4] : null;

      // Validate transaction type
      if (type != 'income' && type != 'expense') {
        return _createErrorAction(
            'Transaction type must be "income" or "expense"');
      }

      // Validate amount
      if (amount <= 0) {
        return _createErrorAction('Amount must be greater than 0');
      }

      return AiAction(
        type: ActionType.addTransaction,
        parameters: {
          'amount': amount,
          'category': category,
          'transactionType': type,
          'notes': notes,
        },
        confirmationMessage:
            'Add ${type == 'income' ? 'income' : 'expense'} of €${amount.toStringAsFixed(2)} for $category?',
      );
    } catch (e) {
      return _createErrorAction('Invalid amount format: ${parts[1]}');
    }
  }

  static AiAction _parseAddDebtAction(List<String> parts) {
    if (parts.length < 4) {
      return _createErrorAction(
          'ADD_DEBT requires at least 4 parameters: debtorName|amount|category|dueDate');
    }

    try {
      final debtorName = parts[1];
      final amount = double.parse(parts[2]);
      final category = parts[3];
      final dueDate = parts.length > 4 && parts[4].isNotEmpty
          ? DateTime.tryParse(parts[4])
          : null;

      // Validate debtor name
      if (debtorName.isEmpty) {
        return _createErrorAction('Debtor name cannot be empty');
      }

      // Validate amount
      if (amount <= 0) {
        return _createErrorAction('Amount must be greater than 0');
      }

      return AiAction(
        type: ActionType.addDebt,
        parameters: {
          'debtorName': debtorName,
          'amount': amount,
          'debtCategory': category,
          'dueDate': dueDate,
        },
        confirmationMessage:
            'Add debt of €${amount.toStringAsFixed(2)} from $debtorName in $category?',
      );
    } catch (e) {
      return _createErrorAction('Invalid amount format: ${parts[2]}');
    }
  }

  static AiAction _parseAddPaymentAction(List<String> parts) {
    if (parts.length < 3) {
      return _createErrorAction(
          'ADD_PAYMENT requires at least 3 parameters: debtId|amount|notes');
    }

    try {
      final debtId = parts[1];
      final amount = double.parse(parts[2]);

      // Validate debt ID
      if (debtId.isEmpty) {
        return _createErrorAction('Debt ID cannot be empty');
      }

      // Validate amount
      if (amount <= 0) {
        return _createErrorAction('Amount must be greater than 0');
      }

      return AiAction(
        type: ActionType.addPayment,
        parameters: {
          'debtId': debtId,
          'paymentAmount': amount.toStringAsFixed(2),
        },
        confirmationMessage:
            'Record payment of €${amount.toStringAsFixed(2)} for debt $debtId?',
      );
    } catch (e) {
      return _createErrorAction('Invalid amount format: ${parts[2]}');
    }
  }

  static AiAction _parseQueryAction(List<String> parts) {
    if (parts.length < 2) {
      return _createErrorAction(
          'QUERY requires at least 2 parameters: queryType|timeRange');
    }

    final queryType = parts[1];
    final timeRange = parts.length > 2 ? parts[2] : null;

    return AiAction(
      type: ActionType.query,
      parameters: {
        'queryType': queryType,
        'timeRange': timeRange,
      },
      confirmationMessage:
          'Execute query: $queryType${timeRange != null ? ' for $timeRange' : ''}?',
    );
  }

  static AiAction _parseSummaryAction(List<String> parts) {
    final summaryType = parts.length > 1 ? parts[1] : 'general';
    final timeRange = parts.length > 2 ? parts[2] : null;

    return AiAction(
      type: ActionType.summary,
      parameters: {
        'queryType': summaryType,
        'timeRange': timeRange,
      },
      confirmationMessage:
          'Generate $summaryType summary${timeRange != null ? ' for $timeRange' : ''}?',
    );
  }

  static AiAction _createErrorAction(String errorMessage) {
    return AiAction(
      type: ActionType.unknown,
      parameters: {},
      errorMessage: errorMessage,
    );
  }

  // Helper method to extract action from AI response
  static AiAction? extractActionFromResponse(String response) {
    // Look for ACTION: pattern in the response
    final actionPattern = RegExp(r'ACTION:[^|]+\|[^|]+(?:\|[^|]*)*');
    final match = actionPattern.firstMatch(response);

    if (match != null) {
      final actionString = response.substring(match.start, match.end);
      return parseAction(actionString);
    }

    return null;
  }

  // Helper method to check if response contains an action
  static bool hasActionInResponse(String response) {
    return response.contains('ACTION:');
  }

  // Helper method to clean response text (remove action markers)
  static String cleanResponseText(String response) {
    // Remove ACTION: lines from the response
    final lines = response.split('\n');
    final cleanedLines =
        lines.where((line) => !line.trim().startsWith('ACTION:')).toList();
    return cleanedLines.join('\n').trim();
  }
}
