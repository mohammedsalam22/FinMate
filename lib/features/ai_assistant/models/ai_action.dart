enum ActionType {
  addTransaction,
  addDebt,
  addPayment,
  query,
  summary,
  unknown,
}

class AiAction {
  final ActionType type;
  final Map<String, dynamic> parameters;
  final String? confirmationMessage;
  final String? errorMessage;

  const AiAction({
    required this.type,
    required this.parameters,
    this.confirmationMessage,
    this.errorMessage,
  });

  // Transaction parameters
  double? get amount => parameters['amount'] as double?;
  String? get category => parameters['category'] as String?;
  String? get transactionType => parameters['transactionType'] as String?;
  String? get notes => parameters['notes'] as String?;

  // Debt parameters
  String? get debtorName => parameters['debtorName'] as String?;
  String? get debtCategory => parameters['debtCategory'] as String?;
  DateTime? get dueDate => parameters['dueDate'] as DateTime?;

  // Payment parameters
  String? get debtId => parameters['debtId'] as String?;
  String? get paymentAmount => parameters['paymentAmount'] as String?;

  // Query parameters
  String? get queryType => parameters['queryType'] as String?;
  String? get timeRange => parameters['timeRange'] as String?;

  bool get hasError => errorMessage != null;
  bool get needsConfirmation => confirmationMessage != null && !hasError;
}

