// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'FinMate';

  @override
  String get transactions => 'Transactions';

  @override
  String get debts => 'Debts';

  @override
  String get analytics => 'Analytics';

  @override
  String get settings => 'Settings';

  @override
  String get totalIncome => 'Total Income';

  @override
  String get totalExpense => 'Total Expense';

  @override
  String get expenseBreakdown => 'Expense Breakdown';

  @override
  String get recentTransactions => 'Recent Transactions';

  @override
  String get noTransactionsYet => 'No transactions yet';

  @override
  String get tapToAddFirstTransaction => 'Tap + to add your first transaction';

  @override
  String get addDebt => 'Add Debt';

  @override
  String get editDebt => 'Edit Debt';

  @override
  String get debtorName => 'Debtor name';

  @override
  String get enterName => 'Enter a name';

  @override
  String get totalAmount => 'Total amount';

  @override
  String get nameExample => 'e.g. John Doe';

  @override
  String get createNewCategory => 'Create New Category';

  @override
  String get categoryName => 'Category Name';

  @override
  String get enterCategoryName => 'Please enter a category name';

  @override
  String get nameMinLength => 'Name must be at least 2 characters';

  @override
  String get categoryExample => 'e.g., Cafeteria, Work, Personal';

  @override
  String get cancel => 'Cancel';

  @override
  String get create => 'Create';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get success => 'Success';

  @override
  String get error => 'Error';

  @override
  String get noDebtsYet => 'No debts recorded yet';

  @override
  String get addFirstDebt => 'Add your first debt to get started';

  @override
  String get appearance => 'Appearance';

  @override
  String get language => 'Language';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get systemDefault => 'System Default';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get termsAndPrivacy => 'Terms & Privacy';

  @override
  String get unknown => 'Unknown';

  @override
  String get noExpenseDataYet => 'No expense data yet';

  @override
  String get owed => 'Owed';

  @override
  String get paid => 'Paid';

  @override
  String get remaining => 'Remaining';

  @override
  String get addCategory => 'Add Category';

  @override
  String get tapToAddFirstDebt => 'Tap + to add your first debt';

  @override
  String get savedSuccessfully => 'Saved successfully';

  @override
  String get enterAmount => 'Enter an amount';

  @override
  String get enterValidAmount => 'Enter a valid amount';

  @override
  String get dueDateOptional => 'Due date (optional)';

  @override
  String get noDueDate => 'No due date';

  @override
  String get notesOptional => 'Notes (optional)';

  @override
  String get addNote => 'Add a note...';

  @override
  String get payments => 'Payments';

  @override
  String get addPayment => 'Add payment';

  @override
  String get createDebt => 'Create Debt';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get categoryNotFound => 'Category Not Found';

  @override
  String get categoryNotFoundText => 'Category not found';

  @override
  String deleteCategoryTitle(String name) {
    return 'Delete \"$name\"';
  }

  @override
  String get deleteCategoryMessage => 'This will permanently delete:';

  @override
  String deleteCategoryItem(String name) {
    return '• The category \"$name\"';
  }

  @override
  String deleteDebtsCount(int count) {
    return '• All $count debts in this category';
  }

  @override
  String get deletePaymentHistory => '• All payment history for these debts';

  @override
  String get actionCannotBeUndone => 'This action cannot be undone.';

  @override
  String categoryDeletedSuccess(String name) {
    return 'Category \"$name\" and all debts deleted';
  }

  @override
  String errorDeletingCategory(String error) {
    return 'Error deleting category: $error';
  }

  @override
  String deletePersonTitle(String name) {
    return 'Delete \"$name\"';
  }

  @override
  String get deletePersonMessage =>
      'This will permanently delete all debts for this person';

  @override
  String get deletePersonDebts => '• All debts for this person will be deleted';

  @override
  String get deletePersonPayments =>
      '• All payment history for these debts will be deleted';

  @override
  String personDeletedSuccess(String name) {
    return 'All debts for \"$name\" deleted';
  }

  @override
  String errorDeletingPerson(String error) {
    return 'Error deleting person: $error';
  }

  @override
  String totalDebts(int count) {
    return '$count Total Debts';
  }

  @override
  String get totalAmountLabel => 'total amount';

  @override
  String get settled => 'Settled';

  @override
  String get deleteCategory => 'Delete Category';

  @override
  String get noPeopleInCategory => 'No people in this category yet';

  @override
  String get addFirstDebtToStart => 'Add your first debt to get started';

  @override
  String get addFirstDebtButton => 'Add First Debt';

  @override
  String debtCount(int count) {
    return '$count debt';
  }

  @override
  String debtsCount(int count) {
    return '$count debts';
  }

  @override
  String get total => 'total';

  @override
  String get debtTimeline => 'Debt Timeline';

  @override
  String get debtNotFound => 'Debt not found';

  @override
  String get totalAmountValue => 'Total Amount';

  @override
  String get due => 'Due:';

  @override
  String get history => 'History';

  @override
  String get noHistoryYet => 'No history yet';

  @override
  String get paymentHistoryWillAppear => 'Payment history will appear here';

  @override
  String get amount => 'Amount';

  @override
  String get totalOwed => 'Total Owed';

  @override
  String inCategory(String category) {
    return 'In $category';
  }

  @override
  String get addDebtButton => 'Add Debt';

  @override
  String get addPaymentButton => 'Add Payment';

  @override
  String get addFirstDebtOrPayment =>
      'Add your first debt or payment to get started';

  @override
  String personLabel(String name) {
    return 'Person: $name';
  }

  @override
  String get dueDateOptionalLabel => 'Due Date (Optional)';

  @override
  String forPerson(String name) {
    return 'For: $name';
  }

  @override
  String get noRemainingDebt => 'No remaining debt to pay';

  @override
  String errorDeletingDebt(String error) {
    return 'Error deleting debt: $error';
  }

  @override
  String errorDeletingPayment(String error) {
    return 'Error deleting payment: $error';
  }

  @override
  String get totalBalance => 'Total Balance';

  @override
  String get income => 'Income';

  @override
  String get expense => 'Expense';

  @override
  String get add => 'Add';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get thisWeek => 'This Week';

  @override
  String get thisMonth => 'This Month';

  @override
  String get addTransaction => 'Add Transaction';

  @override
  String get fillAllRequiredFields => 'Please fill all required fields';

  @override
  String get transactionAddedSuccess => 'Transaction added successfully';

  @override
  String errorAddingTransaction(String error) {
    return 'Error adding transaction: $error';
  }

  @override
  String get pleaseEnterAmount => 'Please enter an amount';

  @override
  String get pleaseEnterValidAmount => 'Please enter a valid amount';

  @override
  String get category => 'Category';

  @override
  String get dateAndTime => 'Date & Time';

  @override
  String get saveTransaction => 'Save Transaction';

  @override
  String get color => 'Color';

  @override
  String get icon => 'Icon';

  @override
  String get iconFolder => 'Folder';

  @override
  String get iconBusiness => 'Business';

  @override
  String get iconHome => 'Home';

  @override
  String get iconWork => 'Work';

  @override
  String get iconSchool => 'School';

  @override
  String get iconRestaurant => 'Restaurant';

  @override
  String get iconHealth => 'Health';

  @override
  String get iconCar => 'Car';

  @override
  String get iconShopping => 'Shopping';

  @override
  String get iconGames => 'Games';

  @override
  String categoryCreatedSuccess(String name) {
    return 'Category \"$name\" created successfully!';
  }

  @override
  String errorCreatingCategory(String error) {
    return 'Error creating category: $error';
  }

  @override
  String get timelineView => 'Timeline View';

  @override
  String get tableView => 'Table View';

  @override
  String get date => 'Date';

  @override
  String get type => 'Type';

  @override
  String get debtCreated => 'Debt Created';

  @override
  String get payment => 'Payment';

  @override
  String get balance => 'Balance';

  @override
  String get notes => 'Notes';

  @override
  String get aiAssistant => 'AI Assistant';

  @override
  String get askMeAboutFinances => 'Ask me about your finances...';

  @override
  String get clearChat => 'Clear chat';

  @override
  String get aiAssistantTitle => 'AI Assistant';

  @override
  String get aiAssistantDescription =>
      'Ask me about your finances, add transactions,\nmanage debts, or get insights!';

  @override
  String get summarizeThisWeek => 'Summarize this week';

  @override
  String get showSpendingBreakdown => 'Show spending breakdown';

  @override
  String get addExpense => 'Add expense';

  @override
  String get checkDebts => 'Check debts';

  @override
  String get currentBalance => 'Current balance';

  @override
  String get topCategories => 'Top categories';

  @override
  String get confirm => 'Confirm';

  @override
  String get addTransactionAction => 'Add Transaction';

  @override
  String get addDebtAction => 'Add Debt';

  @override
  String get recordPaymentAction => 'Record Payment';

  @override
  String get queryInformationAction => 'Query Information';

  @override
  String get unknownAction => 'Unknown Action';

  @override
  String get willAddTransaction =>
      'I will add this transaction to your records:';

  @override
  String get willAddDebt => 'I will add this debt to your records:';

  @override
  String get willRecordPayment => 'I will record this payment:';

  @override
  String get willProvideInformation => 'I will provide information about:';

  @override
  String get cannotUnderstandAction => 'I cannot understand this action.';

  @override
  String get tryRephrasing => 'Please try rephrasing your request.';

  @override
  String get amountLabel => 'Amount';

  @override
  String get categoryLabel => 'Category';

  @override
  String get typeLabel => 'Type';

  @override
  String get notesLabel => 'Notes';

  @override
  String get debtorLabel => 'Debtor';

  @override
  String get dueDateLabel => 'Due Date';

  @override
  String get debtIdLabel => 'Debt ID';

  @override
  String get queryTypeLabel => 'Query Type';

  @override
  String get timeRangeLabel => 'Time Range';

  @override
  String get aiServiceNotConfigured => 'AI service is not properly configured.';

  @override
  String get apiKeyNotFound =>
      'API key not found. Please create a .env file with GEMINI_API_KEY=your_key_here';

  @override
  String get apiKeyPlaceholder =>
      'Please replace \"your_api_key_here\" in .env file with your actual Google Gemini API key';

  @override
  String get aiModelInitFailed =>
      'Failed to initialize AI model. Please check your API key.';

  @override
  String get aiEncounteredError =>
      'Sorry, I encountered an error. Please try again.';

  @override
  String get apiKeyInvalid =>
      'API key is invalid. Please check your configuration.';

  @override
  String get apiQuotaExceeded => 'API quota exceeded. Please try again later.';

  @override
  String get networkError =>
      'Network error. Please check your internet connection.';

  @override
  String failedAfterRetries(int attempts) {
    return 'Failed to get response after $attempts attempts. Please try again later.';
  }

  @override
  String get unableToProcessRequest =>
      'Unable to process your request. Please try again.';

  @override
  String aiSystemPrompt(String context, String categories,
      String conversationHistory, String userMessage) {
    return 'You are FinMate\'s AI assistant. Current data: $context\nCategories: $categories\n\nFor actions that modify data, use this format: ACTION:TYPE|param1|param2|param3\nAvailable action types: ADD_TRANSACTION, ADD_DEBT, ADD_PAYMENT, QUERY, SUMMARY\n\nExamples:\n- Add expense: ACTION:ADD_TRANSACTION|25.50|groceries|expense|Coffee and sandwich\n- Add income: ACTION:ADD_TRANSACTION|1000|salary|income|Monthly salary\n- Add debt: ACTION:ADD_DEBT|John|500|personal|2024-12-31\n\nIMPORTANT: When user asks to add a transaction, immediately generate the ACTION format. Don\'t ask for clarification unless absolutely necessary.\n\nAlways confirm actions before executing. Keep responses brief and helpful.\n\n$conversationHistory\nUser: $userMessage';
  }

  @override
  String get chatHistory => 'Chat History';

  @override
  String get searchChats => 'Search chats...';

  @override
  String get noConversationsFound => 'No conversations found.';

  @override
  String get deleteConversationTitle => 'Delete Conversation?';

  @override
  String get deleteConversationMessage =>
      'Are you sure you want to delete this conversation? This action cannot be undone.';

  @override
  String conversationDeleted(String title) {
    return 'Conversation \"$title\" deleted';
  }

  @override
  String get untitledChat => 'Untitled Chat';

  @override
  String get open => 'Open';

  @override
  String get justNow => 'Just now';

  @override
  String get deleteDebtTitle => 'Delete Debt?';

  @override
  String get deletePaymentTitle => 'Delete Payment?';

  @override
  String get deleteDebtMessage =>
      'This will permanently delete this debt record and all its payment history. This action cannot be undone.';

  @override
  String get deletePaymentMessage =>
      'This will permanently delete this payment record. This action cannot be undone.';

  @override
  String get executingAction => 'Executing action...';

  @override
  String failedToExecuteAction(String error) {
    return 'Failed to execute action: $error';
  }

  @override
  String get aiResponding => 'AI is responding...';

  @override
  String get startNewChat => 'Start new chat';

  @override
  String get summarizeThisWeekPrompt =>
      'Give me a summary of my spending this week';

  @override
  String get showSpendingBreakdownPrompt =>
      'Show me my spending breakdown by category';

  @override
  String get addExpensePrompt => 'Help me add a new expense';

  @override
  String get checkDebtsPrompt => 'Show me all my outstanding debts';

  @override
  String get currentBalancePrompt => 'What is my current balance?';

  @override
  String get topCategoriesPrompt =>
      'What are my top spending categories this month?';
}
