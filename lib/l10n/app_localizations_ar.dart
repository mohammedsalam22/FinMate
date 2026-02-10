// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'فين ميت';

  @override
  String get transactions => 'المعاملات';

  @override
  String get debts => 'الدين';

  @override
  String get analytics => 'التحليلات';

  @override
  String get settings => 'الإعدادات';

  @override
  String get totalIncome => 'إجمالي الدخل';

  @override
  String get totalExpense => 'إجمالي المصروفات';

  @override
  String get expenseBreakdown => 'تفصيل المصروفات';

  @override
  String get recentTransactions => 'المعاملات الحديثة';

  @override
  String get noTransactionsYet => 'لا توجد معاملات بعد';

  @override
  String get tapToAddFirstTransaction => 'اضغط + لإضافة أول معاملة';

  @override
  String get addDebt => 'إضافة دين';

  @override
  String get editDebt => 'تعديل الدين';

  @override
  String get debtorName => 'اسم المدين';

  @override
  String get enterName => 'أدخل الاسم';

  @override
  String get totalAmount => 'المبلغ الإجمالي';

  @override
  String get nameExample => 'مثال: أحمد محمد';

  @override
  String get createNewCategory => 'إنشاء فئة جديدة';

  @override
  String get categoryName => 'اسم الفئة';

  @override
  String get enterCategoryName => 'يرجى إدخال اسم الفئة';

  @override
  String get nameMinLength => 'يجب أن يكون الاسم على الأقل حرفين';

  @override
  String get categoryExample => 'مثال: الكافتيريا، العمل، شخصي';

  @override
  String get cancel => 'إلغاء';

  @override
  String get create => 'إنشاء';

  @override
  String get save => 'حفظ';

  @override
  String get delete => 'حذف';

  @override
  String get success => 'نجح';

  @override
  String get error => 'خطأ';

  @override
  String get noDebtsYet => 'لا توجد ديون مسجلة بعد';

  @override
  String get addFirstDebt => 'أضف أول دين لك للبدء';

  @override
  String get appearance => 'المظهر';

  @override
  String get language => 'اللغة';

  @override
  String get lightMode => 'الوضع الفاتح';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get systemDefault => 'افتراضي النظام';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get about => 'حول';

  @override
  String get version => 'النسخة';

  @override
  String get termsAndPrivacy => 'الشروط والخصوصية';

  @override
  String get unknown => 'غير معروف';

  @override
  String get noExpenseDataYet => 'لا توجد بيانات مصروفات بعد';

  @override
  String get owed => 'مستحق';

  @override
  String get paid => 'مدفوع';

  @override
  String get remaining => 'متبقي';

  @override
  String get addCategory => 'إضافة فئة';

  @override
  String get tapToAddFirstDebt => 'اضغط + لإضافة أول دين';

  @override
  String get savedSuccessfully => 'تم الحفظ بنجاح';

  @override
  String get enterAmount => 'أدخل المبلغ';

  @override
  String get enterValidAmount => 'أدخل مبلغاً صحيحاً';

  @override
  String get dueDateOptional => 'تاريخ الاستحقاق (اختياري)';

  @override
  String get noDueDate => 'لا يوجد تاريخ استحقاق';

  @override
  String get notesOptional => 'ملاحظات (اختياري)';

  @override
  String get addNote => 'أضف ملاحظة...';

  @override
  String get payments => 'الدفعات';

  @override
  String get addPayment => 'إضافة دفعة';

  @override
  String get createDebt => 'إنشاء دين';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get categoryNotFound => 'الفئة غير موجودة';

  @override
  String get categoryNotFoundText => 'الفئة غير موجودة';

  @override
  String deleteCategoryTitle(String name) {
    return 'حذف \"$name\"';
  }

  @override
  String get deleteCategoryMessage => 'سيتم حذف التالي نهائياً:';

  @override
  String deleteCategoryItem(String name) {
    return '• الفئة \"$name\"';
  }

  @override
  String deleteDebtsCount(int count) {
    return '• جميع الديون الـ $count في هذه الفئة';
  }

  @override
  String get deletePaymentHistory => '• جميع سجلات الدفع لهذه الديون';

  @override
  String get actionCannotBeUndone => 'لا يمكن التراجع عن هذا الإجراء.';

  @override
  String categoryDeletedSuccess(String name) {
    return 'تم حذف الفئة \"$name\" وجميع الديون';
  }

  @override
  String errorDeletingCategory(String error) {
    return 'خطأ في حذف الفئة: $error';
  }

  @override
  String deletePersonTitle(String name) {
    return 'حذف \"$name\"';
  }

  @override
  String get deletePersonMessage => 'سيتم حذف جميع الديون لهذا الشخص نهائياً';

  @override
  String get deletePersonDebts => '• سيتم حذف جميع الديون لهذا الشخص';

  @override
  String get deletePersonPayments => '• سيتم حذف جميع سجلات الدفع لهذه الديون';

  @override
  String personDeletedSuccess(String name) {
    return 'تم حذف جميع ديون \"$name\"';
  }

  @override
  String errorDeletingPerson(String error) {
    return 'خطأ في حذف الشخص: $error';
  }

  @override
  String totalDebts(int count) {
    return '$count إجمالي الديون';
  }

  @override
  String get totalAmountLabel => 'إجمالي المبلغ';

  @override
  String get settled => 'مسدد';

  @override
  String get deleteCategory => 'حذف الفئة';

  @override
  String get noPeopleInCategory => 'لا يوجد أشخاص في هذه الفئة بعد';

  @override
  String get addFirstDebtToStart => 'أضف أول دين لك للبدء';

  @override
  String get addFirstDebtButton => 'إضافة أول دين';

  @override
  String debtCount(int count) {
    return '$count دين';
  }

  @override
  String debtsCount(int count) {
    return '$count ديون';
  }

  @override
  String get total => 'إجمالي';

  @override
  String get debtTimeline => 'الجدول الزمني للدين';

  @override
  String get debtNotFound => 'الدين غير موجود';

  @override
  String get totalAmountValue => 'المبلغ الإجمالي';

  @override
  String get due => 'الاستحقاق:';

  @override
  String get history => 'السجل';

  @override
  String get noHistoryYet => 'لا يوجد سجل بعد';

  @override
  String get paymentHistoryWillAppear => 'سيظهر سجل الدفع هنا';

  @override
  String get amount => 'المبلغ';

  @override
  String get totalOwed => 'إجمالي المستحق';

  @override
  String inCategory(String category) {
    return 'في $category';
  }

  @override
  String get addDebtButton => 'إضافة دين';

  @override
  String get addPaymentButton => 'إضافة دفعة';

  @override
  String get addFirstDebtOrPayment => 'أضف أول دين أو دفعة للبدء';

  @override
  String personLabel(String name) {
    return 'الشخص: $name';
  }

  @override
  String get dueDateOptionalLabel => 'تاريخ الاستحقاق (اختياري)';

  @override
  String forPerson(String name) {
    return 'لـ: $name';
  }

  @override
  String get noRemainingDebt => 'لا يوجد دين متبقي للدفع';

  @override
  String errorDeletingDebt(String error) {
    return 'خطأ في حذف الدين: $error';
  }

  @override
  String errorDeletingPayment(String error) {
    return 'خطأ في حذف الدفعة: $error';
  }

  @override
  String get totalBalance => 'الرصيد الإجمالي';

  @override
  String get income => 'دخل';

  @override
  String get expense => 'مصروف';

  @override
  String get add => 'إضافة';

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String get thisWeek => 'هذا الأسبوع';

  @override
  String get thisMonth => 'هذا الشهر';

  @override
  String get addTransaction => 'إضافة معاملة';

  @override
  String get fillAllRequiredFields => 'يرجى ملء جميع الحقول المطلوبة';

  @override
  String get transactionAddedSuccess => 'تمت إضافة المعاملة بنجاح';

  @override
  String errorAddingTransaction(String error) {
    return 'خطأ في إضافة المعاملة: $error';
  }

  @override
  String get pleaseEnterAmount => 'يرجى إدخال المبلغ';

  @override
  String get pleaseEnterValidAmount => 'يرجى إدخال مبلغ صحيح';

  @override
  String get category => 'الفئة';

  @override
  String get dateAndTime => 'التاريخ والوقت';

  @override
  String get saveTransaction => 'حفظ المعاملة';

  @override
  String get color => 'اللون';

  @override
  String get icon => 'الأيقونة';

  @override
  String get iconFolder => 'مجلد';

  @override
  String get iconBusiness => 'عمل';

  @override
  String get iconHome => 'منزل';

  @override
  String get iconWork => 'وظيفة';

  @override
  String get iconSchool => 'مدرسة';

  @override
  String get iconRestaurant => 'مطعم';

  @override
  String get iconHealth => 'صحة';

  @override
  String get iconCar => 'سيارة';

  @override
  String get iconShopping => 'تسوق';

  @override
  String get iconGames => 'ألعاب';

  @override
  String categoryCreatedSuccess(String name) {
    return 'تم إنشاء الفئة \"$name\" بنجاح!';
  }

  @override
  String errorCreatingCategory(String error) {
    return 'خطأ في إنشاء الفئة: $error';
  }

  @override
  String get timelineView => 'عرض الجدول الزمني';

  @override
  String get tableView => 'عرض الجدول';

  @override
  String get date => 'التاريخ';

  @override
  String get type => 'النوع';

  @override
  String get debtCreated => 'تم إنشاء الدين';

  @override
  String get payment => 'دفعة';

  @override
  String get balance => 'الرصيد';

  @override
  String get notes => 'ملاحظات';

  @override
  String get aiAssistant => 'المساعد الذكي';

  @override
  String get askMeAboutFinances => 'اسألني عن أموالك...';

  @override
  String get clearChat => 'مسح المحادثة';

  @override
  String get aiAssistantTitle => 'المساعد الذكي';

  @override
  String get aiAssistantDescription =>
      'اسألني عن أموالك، أضف المعاملات،\nأدر الديون، أو احصل على رؤى!';

  @override
  String get summarizeThisWeek => 'ملخص هذا الأسبوع';

  @override
  String get showSpendingBreakdown => 'عرض تفصيل المصروفات';

  @override
  String get addExpense => 'إضافة مصروف';

  @override
  String get checkDebts => 'فحص الديون';

  @override
  String get currentBalance => 'الرصيد الحالي';

  @override
  String get topCategories => 'أهم الفئات';

  @override
  String get confirm => 'تأكيد';

  @override
  String get addTransactionAction => 'إضافة معاملة';

  @override
  String get addDebtAction => 'إضافة دين';

  @override
  String get recordPaymentAction => 'تسجيل دفعة';

  @override
  String get queryInformationAction => 'استعلام المعلومات';

  @override
  String get unknownAction => 'إجراء غير معروف';

  @override
  String get willAddTransaction => 'سأضيف هذه المعاملة إلى سجلاتك:';

  @override
  String get willAddDebt => 'سأضيف هذا الدين إلى سجلاتك:';

  @override
  String get willRecordPayment => 'سأسجل هذه الدفعة:';

  @override
  String get willProvideInformation => 'سأقدم معلومات حول:';

  @override
  String get cannotUnderstandAction => 'لا أستطيع فهم هذا الإجراء.';

  @override
  String get tryRephrasing => 'يرجى إعادة صياغة طلبك.';

  @override
  String get amountLabel => 'المبلغ';

  @override
  String get categoryLabel => 'الفئة';

  @override
  String get typeLabel => 'النوع';

  @override
  String get notesLabel => 'ملاحظات';

  @override
  String get debtorLabel => 'المدين';

  @override
  String get dueDateLabel => 'تاريخ الاستحقاق';

  @override
  String get debtIdLabel => 'معرف الدين';

  @override
  String get queryTypeLabel => 'نوع الاستعلام';

  @override
  String get timeRangeLabel => 'النطاق الزمني';

  @override
  String get aiServiceNotConfigured =>
      'خدمة الذكاء الاصطناعي غير مُعدة بشكل صحيح.';

  @override
  String get apiKeyNotFound =>
      'مفتاح API غير موجود. يرجى إنشاء ملف .env مع GEMINI_API_KEY=your_key_here';

  @override
  String get apiKeyPlaceholder =>
      'يرجى استبدال \"your_api_key_here\" في ملف .env بمفتاح Google Gemini API الفعلي';

  @override
  String get aiModelInitFailed =>
      'فشل في تهيئة نموذج الذكاء الاصطناعي. يرجى التحقق من مفتاح API.';

  @override
  String get aiEncounteredError => 'عذراً، واجهت خطأ. يرجى المحاولة مرة أخرى.';

  @override
  String get apiKeyInvalid => 'مفتاح API غير صحيح. يرجى التحقق من إعداداتك.';

  @override
  String get apiQuotaExceeded => 'تم تجاوز حصة API. يرجى المحاولة لاحقاً.';

  @override
  String get networkError => 'خطأ في الشبكة. يرجى التحقق من اتصال الإنترنت.';

  @override
  String failedAfterRetries(int attempts) {
    return 'فشل في الحصول على استجابة بعد $attempts محاولات. يرجى المحاولة لاحقاً.';
  }

  @override
  String get unableToProcessRequest =>
      'غير قادر على معالجة طلبك. يرجى المحاولة مرة أخرى.';

  @override
  String aiSystemPrompt(String context, String categories,
      String conversationHistory, String userMessage) {
    return 'أنت مساعد FinMate الذكي. البيانات الحالية: $context\nالفئات المتاحة: $categories\n\nللإجراءات التي تعدل البيانات، استخدم هذا التنسيق: ACTION:TYPE|param1|param2|param3\nأنواع الإجراءات المتاحة: ADD_TRANSACTION, ADD_DEBT, ADD_PAYMENT, QUERY, SUMMARY\n\nأمثلة:\n- إضافة مصروف: ACTION:ADD_TRANSACTION|25.50|groceries|expense|قهوة وساندويتش\n- إضافة دخل: ACTION:ADD_TRANSACTION|1000|salary|income|راتب شهري\n- إضافة دين: ACTION:ADD_DEBT|أحمد|500|personal|2024-12-31\n\nمهم جداً: عندما يطلب المستخدم إضافة معاملة، قم بتوليد تنسيق ACTION فوراً. لا تطلب توضيحات إضافية إلا إذا كان ذلك ضرورياً تماماً.\n\nتأكد دائماً من الإجراءات قبل التنفيذ. اجعل الردود مختصرة ومفيدة ومفهومة.\n\n$conversationHistory\nالمستخدم: $userMessage';
  }

  @override
  String get chatHistory => 'تاريخ المحادثات';

  @override
  String get searchChats => 'البحث في المحادثات...';

  @override
  String get noConversationsFound => 'لم يتم العثور على محادثات.';

  @override
  String get deleteConversationTitle => 'حذف المحادثة؟';

  @override
  String get deleteConversationMessage =>
      'هل أنت متأكد من أنك تريد حذف هذه المحادثة؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String conversationDeleted(String title) {
    return 'تم حذف المحادثة \"$title\"';
  }

  @override
  String get untitledChat => 'محادثة بدون عنوان';

  @override
  String get open => 'فتح';

  @override
  String get justNow => 'الآن';

  @override
  String get deleteDebtTitle => 'حذف الدين؟';

  @override
  String get deletePaymentTitle => 'حذف الدفعة؟';

  @override
  String get deleteDebtMessage =>
      'سيتم حذف هذا الدين وجميع سجلات الدفع الخاصة به نهائياً. لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get deletePaymentMessage =>
      'سيتم حذف سجل هذه الدفعة نهائياً. لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get executingAction => 'تنفيذ الإجراء...';

  @override
  String failedToExecuteAction(String error) {
    return 'فشل في تنفيذ الإجراء: $error';
  }

  @override
  String get aiResponding => 'الذكاء الاصطناعي يرد...';

  @override
  String get startNewChat => 'بدء محادثة جديدة';

  @override
  String get summarizeThisWeekPrompt => 'أعطني ملخصاً لمصروفاتي هذا الأسبوع';

  @override
  String get showSpendingBreakdownPrompt => 'أرني تفصيل مصروفاتي حسب الفئة';

  @override
  String get addExpensePrompt => 'ساعدني في إضافة مصروف جديد';

  @override
  String get checkDebtsPrompt => 'أرني جميع ديوني المستحقة';

  @override
  String get currentBalancePrompt => 'ما هو رصيدي الحالي؟';

  @override
  String get topCategoriesPrompt => 'ما هي أهم فئات مصروفاتي هذا الشهر؟';
}
