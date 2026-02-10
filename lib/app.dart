import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketsage/providers/providers.dart';
import 'package:pocketsage/l10n/app_localizations.dart';
import 'package:pocketsage/features/transactions/add_transaction_screen.dart';
import 'package:pocketsage/features/transactions/transactions_list_screen.dart';
import 'package:pocketsage/features/analytics/analytics_screen.dart';
import 'package:pocketsage/features/settings/settings_screen.dart';
import 'package:pocketsage/features/debts/debts_list/debts_list_screen.dart';
import 'package:pocketsage/features/debts/add_edit_debt/add_edit_debt_screen.dart';
import 'package:pocketsage/features/debts/debt_timeline/debt_timeline_screen.dart';
import 'package:pocketsage/features/debts/category_details/category_details_screen.dart';
import 'package:pocketsage/features/debts/person_timeline/person_timeline_screen.dart';
import 'package:pocketsage/features/ai_assistant/ai_chat_screen.dart';
import 'package:pocketsage/widgets/neumorphic_bottom_navigation_bar.dart';
import 'package:pocketsage/core/theme/theme.dart';

class FinMateApp extends ConsumerWidget {
  const FinMateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'FinMate',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: _router,
    );
  }
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainShell(),
    ),
    GoRoute(
      path: '/add-transaction',
      builder: (context, state) => const AddTransactionScreen(),
    ),
    GoRoute(
      path: '/add-debt',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final categoryId = extra?['categoryId'] as String?;
        return AddEditDebtScreen(categoryId: categoryId);
      },
    ),
    GoRoute(
      path: '/edit-debt',
      builder: (context, state) {
        final debt = state.extra;
        if (debt == null) {
          // Handle null case gracefully - redirect to debt list
          return const DebtsListScreen();
        }
        return AddEditDebtScreen(debt: debt as dynamic);
      },
    ),
    GoRoute(
      path: '/debt-timeline/:debtId',
      builder: (context, state) {
        final debtId = state.pathParameters['debtId'];
        // We need to get the debt from the providers
        // For now, we'll pass the debtId and handle it in the screen
        return DebtTimelineScreen.fromId(debtId: debtId!);
      },
    ),
    GoRoute(
      path: '/category-details/:categoryId',
      builder: (context, state) {
        final categoryId = state.pathParameters['categoryId'];
        return CategoryDetailsScreen(categoryId: categoryId!);
      },
    ),
    GoRoute(
      path: '/person-timeline/:categoryId/:personName',
      builder: (context, state) {
        final categoryId = state.pathParameters['categoryId'];
        final personName = state.pathParameters['personName'];
        return PersonTimelineScreen(
          categoryId: categoryId!,
          personName: personName!,
        );
      },
    ),
  ],
);

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          TransactionsListScreen(),
          DebtsListScreen(),
          AnalyticsScreen(),
          SettingsScreen(),
          AiChatScreen(),
        ],
      ),
      bottomNavigationBar: NeumorphicBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: [
          NeumorphicNavItem(
            icon: Icons.receipt_long_outlined,
            selectedIcon: Icons.receipt_long,
            label: l10n.transactions,
          ),
          NeumorphicNavItem(
            icon: Icons.account_balance_wallet_outlined,
            selectedIcon: Icons.account_balance_wallet,
            label: l10n.debts,
          ),
          NeumorphicNavItem(
            icon: Icons.bar_chart_outlined,
            selectedIcon: Icons.bar_chart,
            label: l10n.analytics,
          ),
          NeumorphicNavItem(
            icon: Icons.settings_outlined,
            selectedIcon: Icons.settings,
            label: l10n.settings,
          ),
          NeumorphicNavItem(
            icon: Icons.smart_toy_outlined,
            selectedIcon: Icons.smart_toy,
            label: l10n.aiAssistant,
          ),
        ],
      ),
    );
  }
}
