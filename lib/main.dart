import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocketsage/app.dart';
import 'package:pocketsage/core/constants/constants.dart';
import 'package:pocketsage/data/models/category.dart';
import 'package:pocketsage/data/models/transaction.dart';
import 'package:pocketsage/data/models/user.dart';
import 'package:pocketsage/data/models/debt.dart';
import 'package:pocketsage/data/models/debt_adapter.dart';
import 'package:pocketsage/data/models/debt_category.dart';
import 'package:pocketsage/data/migrations/debt_migration.dart';
import 'package:pocketsage/features/ai_assistant/models/conversation.dart';
import 'package:pocketsage/features/ai_assistant/models/chat_message.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  if (!kIsWeb) {
    await Hive.initFlutter();

    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(CategoryAdapter());
    Hive.registerAdapter(CategoryTypeAdapter());
    Hive.registerAdapter(FinTransactionAdapter());
    Hive.registerAdapter(TransactionTypeAdapter());
    Hive.registerAdapter(DebtAdapter());
    Hive.registerAdapter(DebtPaymentAdapter());
    Hive.registerAdapter(DebtCategoryAdapter());
    Hive.registerAdapter(ConversationAdapter());
    Hive.registerAdapter(MessageTypeAdapter());
    Hive.registerAdapter(ChatMessageAdapter());

    await Hive.openBox<User>(HiveBoxes.users);
    await Hive.openBox<Category>(HiveBoxes.categories);
    await Hive.openBox<FinTransaction>(HiveBoxes.transactions);
    await Hive.openBox<Debt>(HiveBoxes.debts);
    await Hive.openBox<DebtCategory>(HiveBoxes.debtCategories);
    await Hive.openBox<Conversation>(HiveBoxes.conversations);

    // Run debt categories migration
    await DebtMigration.migrateExistingDebts();
  }

  runApp(const ProviderScope(child: FinMateApp()));
}
