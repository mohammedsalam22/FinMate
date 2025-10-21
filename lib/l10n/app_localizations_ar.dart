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
}
