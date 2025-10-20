import 'package:intl/intl.dart';

String formatCurrency(double amount, {String currencySymbol = '€'}) {
  return '$currencySymbol${amount.toStringAsFixed(2)}';
}

String formatDateShort(DateTime date) {
  return DateFormat('MMM d, yyyy').format(date);
}
