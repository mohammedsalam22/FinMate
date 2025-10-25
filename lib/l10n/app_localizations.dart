import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'FinMate'**
  String get appTitle;

  /// Label for transactions navigation and screen
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// Label for debts navigation and screen
  ///
  /// In en, this message translates to:
  /// **'Debts'**
  String get debts;

  /// Label for analytics navigation and screen
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// Label for settings navigation and screen
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Label for total income display
  ///
  /// In en, this message translates to:
  /// **'Total Income'**
  String get totalIncome;

  /// Label for total expense display
  ///
  /// In en, this message translates to:
  /// **'Total Expense'**
  String get totalExpense;

  /// Label for expense breakdown section
  ///
  /// In en, this message translates to:
  /// **'Expense Breakdown'**
  String get expenseBreakdown;

  /// Label for recent transactions section
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recentTransactions;

  /// Message shown when no transactions exist
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get noTransactionsYet;

  /// Instruction to add first transaction
  ///
  /// In en, this message translates to:
  /// **'Tap + to add your first transaction'**
  String get tapToAddFirstTransaction;

  /// Title for add debt screen
  ///
  /// In en, this message translates to:
  /// **'Add Debt'**
  String get addDebt;

  /// Title for edit debt screen
  ///
  /// In en, this message translates to:
  /// **'Edit Debt'**
  String get editDebt;

  /// Label for debtor name field
  ///
  /// In en, this message translates to:
  /// **'Debtor name'**
  String get debtorName;

  /// Validation message for name field
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get enterName;

  /// Label for total amount field
  ///
  /// In en, this message translates to:
  /// **'Total amount'**
  String get totalAmount;

  /// Example text for name field
  ///
  /// In en, this message translates to:
  /// **'e.g. John Doe'**
  String get nameExample;

  /// Title for create category dialog
  ///
  /// In en, this message translates to:
  /// **'Create New Category'**
  String get createNewCategory;

  /// Label for category name field
  ///
  /// In en, this message translates to:
  /// **'Category Name'**
  String get categoryName;

  /// Validation message for category name
  ///
  /// In en, this message translates to:
  /// **'Please enter a category name'**
  String get enterCategoryName;

  /// Validation message for minimum name length
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get nameMinLength;

  /// Example text for category name field
  ///
  /// In en, this message translates to:
  /// **'e.g., Cafeteria, Work, Personal'**
  String get categoryExample;

  /// Cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Create button label
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// Save button label
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Delete button label
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Success message
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Error message title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Message shown when no debts exist
  ///
  /// In en, this message translates to:
  /// **'No debts recorded yet'**
  String get noDebtsYet;

  /// Instruction to add first debt
  ///
  /// In en, this message translates to:
  /// **'Add your first debt to get started'**
  String get addFirstDebt;

  /// Appearance settings section
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// Language settings section
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// System theme option
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Arabic language option
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// About section
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Version label
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Terms and privacy label
  ///
  /// In en, this message translates to:
  /// **'Terms & Privacy'**
  String get termsAndPrivacy;

  /// Unknown label for missing items
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// Message when there's no expense data
  ///
  /// In en, this message translates to:
  /// **'No expense data yet'**
  String get noExpenseDataYet;

  /// Amount owed label
  ///
  /// In en, this message translates to:
  /// **'Owed'**
  String get owed;

  /// Amount paid label
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// Remaining amount label
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// Add category button label
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get addCategory;

  /// Instruction to add first debt
  ///
  /// In en, this message translates to:
  /// **'Tap + to add your first debt'**
  String get tapToAddFirstDebt;

  /// Success message after saving
  ///
  /// In en, this message translates to:
  /// **'Saved successfully'**
  String get savedSuccessfully;

  /// Validation message for amount field
  ///
  /// In en, this message translates to:
  /// **'Enter an amount'**
  String get enterAmount;

  /// Validation message for invalid amount
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get enterValidAmount;

  /// Label for optional due date field
  ///
  /// In en, this message translates to:
  /// **'Due date (optional)'**
  String get dueDateOptional;

  /// Text when no due date is set
  ///
  /// In en, this message translates to:
  /// **'No due date'**
  String get noDueDate;

  /// Label for optional notes field
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesOptional;

  /// Hint text for notes field
  ///
  /// In en, this message translates to:
  /// **'Add a note...'**
  String get addNote;

  /// Payments section label
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get payments;

  /// Add payment button label
  ///
  /// In en, this message translates to:
  /// **'Add payment'**
  String get addPayment;

  /// Create debt button label
  ///
  /// In en, this message translates to:
  /// **'Create Debt'**
  String get createDebt;

  /// Save changes button label
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// Error message when category is not found
  ///
  /// In en, this message translates to:
  /// **'Category Not Found'**
  String get categoryNotFound;

  /// Error text when category is not found
  ///
  /// In en, this message translates to:
  /// **'Category not found'**
  String get categoryNotFoundText;

  /// Title for delete category dialog
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"'**
  String deleteCategoryTitle(String name);

  /// Delete category warning message
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete:'**
  String get deleteCategoryMessage;

  /// Delete category item
  ///
  /// In en, this message translates to:
  /// **'• The category \"{name}\"'**
  String deleteCategoryItem(String name);

  /// Number of debts to be deleted
  ///
  /// In en, this message translates to:
  /// **'• All {count} debts in this category'**
  String deleteDebtsCount(int count);

  /// Payment history deletion warning
  ///
  /// In en, this message translates to:
  /// **'• All payment history for these debts'**
  String get deletePaymentHistory;

  /// Warning that action is permanent
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get actionCannotBeUndone;

  /// Success message after deleting category
  ///
  /// In en, this message translates to:
  /// **'Category \"{name}\" and all debts deleted'**
  String categoryDeletedSuccess(String name);

  /// Error message when deleting category fails
  ///
  /// In en, this message translates to:
  /// **'Error deleting category: {error}'**
  String errorDeletingCategory(String error);

  /// Title for delete person dialog
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"'**
  String deletePersonTitle(String name);

  /// Delete person warning message
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete all debts for this person'**
  String get deletePersonMessage;

  /// Delete person debts warning
  ///
  /// In en, this message translates to:
  /// **'• All debts for this person will be deleted'**
  String get deletePersonDebts;

  /// Delete person payments warning
  ///
  /// In en, this message translates to:
  /// **'• All payment history for these debts will be deleted'**
  String get deletePersonPayments;

  /// Success message after deleting person
  ///
  /// In en, this message translates to:
  /// **'All debts for \"{name}\" deleted'**
  String personDeletedSuccess(String name);

  /// Error message when deleting person fails
  ///
  /// In en, this message translates to:
  /// **'Error deleting person: {error}'**
  String errorDeletingPerson(String error);

  /// Total debts count
  ///
  /// In en, this message translates to:
  /// **'{count} Total Debts'**
  String totalDebts(int count);

  /// Total amount label
  ///
  /// In en, this message translates to:
  /// **'total amount'**
  String get totalAmountLabel;

  /// Settled status label
  ///
  /// In en, this message translates to:
  /// **'Settled'**
  String get settled;

  /// Delete category menu item
  ///
  /// In en, this message translates to:
  /// **'Delete Category'**
  String get deleteCategory;

  /// Empty state message for category
  ///
  /// In en, this message translates to:
  /// **'No people in this category yet'**
  String get noPeopleInCategory;

  /// Instruction to add first debt
  ///
  /// In en, this message translates to:
  /// **'Add your first debt to get started'**
  String get addFirstDebtToStart;

  /// Add first debt button
  ///
  /// In en, this message translates to:
  /// **'Add First Debt'**
  String get addFirstDebtButton;

  /// Single debt count
  ///
  /// In en, this message translates to:
  /// **'{count} debt'**
  String debtCount(int count);

  /// Multiple debts count
  ///
  /// In en, this message translates to:
  /// **'{count} debts'**
  String debtsCount(int count);

  /// Total label
  ///
  /// In en, this message translates to:
  /// **'total'**
  String get total;

  /// Debt timeline screen title
  ///
  /// In en, this message translates to:
  /// **'Debt Timeline'**
  String get debtTimeline;

  /// Error message when debt is not found
  ///
  /// In en, this message translates to:
  /// **'Debt not found'**
  String get debtNotFound;

  /// Total amount label in summary
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmountValue;

  /// Due date prefix
  ///
  /// In en, this message translates to:
  /// **'Due:'**
  String get due;

  /// History section label
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// Empty history message
  ///
  /// In en, this message translates to:
  /// **'No history yet'**
  String get noHistoryYet;

  /// Empty history instruction
  ///
  /// In en, this message translates to:
  /// **'Payment history will appear here'**
  String get paymentHistoryWillAppear;

  /// Amount field label
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// Total owed label
  ///
  /// In en, this message translates to:
  /// **'Total Owed'**
  String get totalOwed;

  /// Category context label
  ///
  /// In en, this message translates to:
  /// **'In {category}'**
  String inCategory(String category);

  /// Add debt button label
  ///
  /// In en, this message translates to:
  /// **'Add Debt'**
  String get addDebtButton;

  /// Add payment button label
  ///
  /// In en, this message translates to:
  /// **'Add Payment'**
  String get addPaymentButton;

  /// Empty state instruction for timeline
  ///
  /// In en, this message translates to:
  /// **'Add your first debt or payment to get started'**
  String get addFirstDebtOrPayment;

  /// Person label with name
  ///
  /// In en, this message translates to:
  /// **'Person: {name}'**
  String personLabel(String name);

  /// Optional due date label
  ///
  /// In en, this message translates to:
  /// **'Due Date (Optional)'**
  String get dueDateOptionalLabel;

  /// For person label
  ///
  /// In en, this message translates to:
  /// **'For: {name}'**
  String forPerson(String name);

  /// Message when there's no remaining debt
  ///
  /// In en, this message translates to:
  /// **'No remaining debt to pay'**
  String get noRemainingDebt;

  /// Error message when deleting debt fails
  ///
  /// In en, this message translates to:
  /// **'Error deleting debt: {error}'**
  String errorDeletingDebt(String error);

  /// Error message when deleting payment fails
  ///
  /// In en, this message translates to:
  /// **'Error deleting payment: {error}'**
  String errorDeletingPayment(String error);

  /// Total balance label
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get totalBalance;

  /// Income label
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// Expense label
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// Add button label
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Today label
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Yesterday label
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// Add transaction screen title
  ///
  /// In en, this message translates to:
  /// **'Add Transaction'**
  String get addTransaction;

  /// Validation message for missing fields
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields'**
  String get fillAllRequiredFields;

  /// Success message after adding transaction
  ///
  /// In en, this message translates to:
  /// **'Transaction added successfully'**
  String get transactionAddedSuccess;

  /// Error message when adding transaction fails
  ///
  /// In en, this message translates to:
  /// **'Error adding transaction: {error}'**
  String errorAddingTransaction(String error);

  /// Validation message for empty amount
  ///
  /// In en, this message translates to:
  /// **'Please enter an amount'**
  String get pleaseEnterAmount;

  /// Validation message for invalid amount
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount'**
  String get pleaseEnterValidAmount;

  /// Category label
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// Date and time label
  ///
  /// In en, this message translates to:
  /// **'Date & Time'**
  String get dateAndTime;

  /// Save transaction button label
  ///
  /// In en, this message translates to:
  /// **'Save Transaction'**
  String get saveTransaction;

  /// Color label
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// Icon label
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get icon;

  /// Folder icon name
  ///
  /// In en, this message translates to:
  /// **'Folder'**
  String get iconFolder;

  /// Business icon name
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get iconBusiness;

  /// Home icon name
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get iconHome;

  /// Work icon name
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get iconWork;

  /// School icon name
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get iconSchool;

  /// Restaurant icon name
  ///
  /// In en, this message translates to:
  /// **'Restaurant'**
  String get iconRestaurant;

  /// Health icon name
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get iconHealth;

  /// Car icon name
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get iconCar;

  /// Shopping icon name
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get iconShopping;

  /// Games icon name
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get iconGames;

  /// Success message after creating category
  ///
  /// In en, this message translates to:
  /// **'Category \"{name}\" created successfully!'**
  String categoryCreatedSuccess(String name);

  /// Error message when creating category fails
  ///
  /// In en, this message translates to:
  /// **'Error creating category: {error}'**
  String errorCreatingCategory(String error);

  /// Timeline view option
  ///
  /// In en, this message translates to:
  /// **'Timeline View'**
  String get timelineView;

  /// Table view option
  ///
  /// In en, this message translates to:
  /// **'Table View'**
  String get tableView;

  /// Date column header
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// Type column header
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// Debt created event label
  ///
  /// In en, this message translates to:
  /// **'Debt Created'**
  String get debtCreated;

  /// Payment event label
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// Balance label
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// Notes label
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// AI Assistant screen title
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get aiAssistant;

  /// AI Assistant input placeholder
  ///
  /// In en, this message translates to:
  /// **'Ask me about your finances...'**
  String get askMeAboutFinances;

  /// Clear chat button tooltip
  ///
  /// In en, this message translates to:
  /// **'Clear chat'**
  String get clearChat;

  /// AI Assistant title in empty state
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get aiAssistantTitle;

  /// AI Assistant description in empty state
  ///
  /// In en, this message translates to:
  /// **'Ask me about your finances, add transactions,\nmanage debts, or get insights!'**
  String get aiAssistantDescription;

  /// Quick action: summarize this week
  ///
  /// In en, this message translates to:
  /// **'Summarize this week'**
  String get summarizeThisWeek;

  /// Quick action: show spending breakdown
  ///
  /// In en, this message translates to:
  /// **'Show spending breakdown'**
  String get showSpendingBreakdown;

  /// Quick action: add expense
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get addExpense;

  /// Quick action: check debts
  ///
  /// In en, this message translates to:
  /// **'Check debts'**
  String get checkDebts;

  /// Quick action: current balance
  ///
  /// In en, this message translates to:
  /// **'Current balance'**
  String get currentBalance;

  /// Quick action: top categories
  ///
  /// In en, this message translates to:
  /// **'Top categories'**
  String get topCategories;

  /// Confirm button label
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Add transaction action title
  ///
  /// In en, this message translates to:
  /// **'Add Transaction'**
  String get addTransactionAction;

  /// Add debt action title
  ///
  /// In en, this message translates to:
  /// **'Add Debt'**
  String get addDebtAction;

  /// Record payment action title
  ///
  /// In en, this message translates to:
  /// **'Record Payment'**
  String get recordPaymentAction;

  /// Query information action title
  ///
  /// In en, this message translates to:
  /// **'Query Information'**
  String get queryInformationAction;

  /// Unknown action title
  ///
  /// In en, this message translates to:
  /// **'Unknown Action'**
  String get unknownAction;

  /// Transaction confirmation description
  ///
  /// In en, this message translates to:
  /// **'I will add this transaction to your records:'**
  String get willAddTransaction;

  /// Debt confirmation description
  ///
  /// In en, this message translates to:
  /// **'I will add this debt to your records:'**
  String get willAddDebt;

  /// Payment confirmation description
  ///
  /// In en, this message translates to:
  /// **'I will record this payment:'**
  String get willRecordPayment;

  /// Query confirmation description
  ///
  /// In en, this message translates to:
  /// **'I will provide information about:'**
  String get willProvideInformation;

  /// Unknown action description
  ///
  /// In en, this message translates to:
  /// **'I cannot understand this action.'**
  String get cannotUnderstandAction;

  /// Unknown action instruction
  ///
  /// In en, this message translates to:
  /// **'Please try rephrasing your request.'**
  String get tryRephrasing;

  /// Amount label in confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amountLabel;

  /// Category label in confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// Type label in confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get typeLabel;

  /// Notes label in confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesLabel;

  /// Debtor label in confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Debtor'**
  String get debtorLabel;

  /// Due date label in confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get dueDateLabel;

  /// Debt ID label in confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Debt ID'**
  String get debtIdLabel;

  /// Query type label in confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Query Type'**
  String get queryTypeLabel;

  /// Time range label in confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Time Range'**
  String get timeRangeLabel;

  /// AI service configuration error
  ///
  /// In en, this message translates to:
  /// **'AI service is not properly configured.'**
  String get aiServiceNotConfigured;

  /// API key not found error
  ///
  /// In en, this message translates to:
  /// **'API key not found. Please create a .env file with GEMINI_API_KEY=your_key_here'**
  String get apiKeyNotFound;

  /// API key placeholder error
  ///
  /// In en, this message translates to:
  /// **'Please replace \"your_api_key_here\" in .env file with your actual Google Gemini API key'**
  String get apiKeyPlaceholder;

  /// AI model initialization error
  ///
  /// In en, this message translates to:
  /// **'Failed to initialize AI model. Please check your API key.'**
  String get aiModelInitFailed;

  /// General AI error message
  ///
  /// In en, this message translates to:
  /// **'Sorry, I encountered an error. Please try again.'**
  String get aiEncounteredError;

  /// Invalid API key error
  ///
  /// In en, this message translates to:
  /// **'API key is invalid. Please check your configuration.'**
  String get apiKeyInvalid;

  /// API quota exceeded error
  ///
  /// In en, this message translates to:
  /// **'API quota exceeded. Please try again later.'**
  String get apiQuotaExceeded;

  /// Network error message
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your internet connection.'**
  String get networkError;

  /// Failed after retries message
  ///
  /// In en, this message translates to:
  /// **'Failed to get response after {attempts} attempts. Please try again later.'**
  String failedAfterRetries(int attempts);

  /// Unable to process request message
  ///
  /// In en, this message translates to:
  /// **'Unable to process your request. Please try again.'**
  String get unableToProcessRequest;

  /// AI system prompt template
  ///
  /// In en, this message translates to:
  /// **'You are FinMate\'s AI assistant. Current data: {context}\nCategories: {categories}\n\nFor actions that modify data, use this format: ACTION:TYPE|param1|param2|param3\nAvailable action types: ADD_TRANSACTION, ADD_DEBT, ADD_PAYMENT, QUERY, SUMMARY\n\nExamples:\n- Add expense: ACTION:ADD_TRANSACTION|25.50|groceries|expense|Coffee and sandwich\n- Add income: ACTION:ADD_TRANSACTION|1000|salary|income|Monthly salary\n- Add debt: ACTION:ADD_DEBT|John|500|personal|2024-12-31\n\nIMPORTANT: When user asks to add a transaction, immediately generate the ACTION format. Don\'t ask for clarification unless absolutely necessary.\n\nAlways confirm actions before executing. Keep responses brief and helpful.\n\n{conversationHistory}\nUser: {userMessage}'**
  String aiSystemPrompt(String context, String categories,
      String conversationHistory, String userMessage);

  /// Chat history drawer title
  ///
  /// In en, this message translates to:
  /// **'Chat History'**
  String get chatHistory;

  /// Search chats placeholder
  ///
  /// In en, this message translates to:
  /// **'Search chats...'**
  String get searchChats;

  /// No conversations found message
  ///
  /// In en, this message translates to:
  /// **'No conversations found.'**
  String get noConversationsFound;

  /// Delete conversation dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Conversation?'**
  String get deleteConversationTitle;

  /// Delete conversation confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this conversation? This action cannot be undone.'**
  String get deleteConversationMessage;

  /// Conversation deleted success message
  ///
  /// In en, this message translates to:
  /// **'Conversation \"{title}\" deleted'**
  String conversationDeleted(String title);

  /// Default title for untitled chat
  ///
  /// In en, this message translates to:
  /// **'Untitled Chat'**
  String get untitledChat;

  /// Executing action message
  ///
  /// In en, this message translates to:
  /// **'Executing action...'**
  String get executingAction;

  /// Failed to execute action error
  ///
  /// In en, this message translates to:
  /// **'Failed to execute action: {error}'**
  String failedToExecuteAction(String error);

  /// AI responding placeholder text
  ///
  /// In en, this message translates to:
  /// **'AI is responding...'**
  String get aiResponding;

  /// Start new chat tooltip
  ///
  /// In en, this message translates to:
  /// **'Start new chat'**
  String get startNewChat;

  /// Quick action prompt for summarizing this week
  ///
  /// In en, this message translates to:
  /// **'Give me a summary of my spending this week'**
  String get summarizeThisWeekPrompt;

  /// Quick action prompt for showing spending breakdown
  ///
  /// In en, this message translates to:
  /// **'Show me my spending breakdown by category'**
  String get showSpendingBreakdownPrompt;

  /// Quick action prompt for adding expense
  ///
  /// In en, this message translates to:
  /// **'Help me add a new expense'**
  String get addExpensePrompt;

  /// Quick action prompt for checking debts
  ///
  /// In en, this message translates to:
  /// **'Show me all my outstanding debts'**
  String get checkDebtsPrompt;

  /// Quick action prompt for current balance
  ///
  /// In en, this message translates to:
  /// **'What is my current balance?'**
  String get currentBalancePrompt;

  /// Quick action prompt for top categories
  ///
  /// In en, this message translates to:
  /// **'What are my top spending categories this month?'**
  String get topCategoriesPrompt;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
