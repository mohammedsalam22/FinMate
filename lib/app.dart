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
import 'package:pocketsage/features/debts/debts_list_screen.dart';
import 'package:pocketsage/features/debts/add_edit_debt_screen.dart';
import 'package:pocketsage/features/debts/debt_timeline_screen.dart';
import 'package:pocketsage/features/debts/category_details_screen.dart';
import 'package:pocketsage/features/debts/person_timeline_screen.dart';
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
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const TransactionsListScreen(),
        ),
        GoRoute(
          path: '/debts',
          builder: (context, state) => const DebtsListScreen(),
        ),
        GoRoute(
          path: '/analytics',
          builder: (context, state) => const AnalyticsScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
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
          personName: Uri.decodeComponent(personName!),
        );
      },
    ),
  ],
);

class MainShell extends StatefulWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() => _currentIndex = index);
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/debts');
        break;
      case 2:
        context.go('/analytics');
        break;
      case 3:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: (isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary)
                  .withValues(alpha: 0.2),
              width: 1,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: _onItemTapped,
          backgroundColor:
              isDark ? AppColors.darkBackground : AppColors.lightBackground,
          indicatorColor: isDark
              ? AppColors.primaryLight.withValues(alpha: 0.2)
              : AppColors.primaryIndigo.withValues(alpha: 0.1),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.receipt_long_outlined),
              selectedIcon: const Icon(Icons.receipt_long),
              label: l10n.transactions,
            ),
            NavigationDestination(
              icon: const Icon(Icons.account_balance_wallet_outlined),
              selectedIcon: const Icon(Icons.account_balance_wallet),
              label: l10n.debts,
            ),
            NavigationDestination(
              icon: const Icon(Icons.bar_chart_outlined),
              selectedIcon: const Icon(Icons.bar_chart),
              label: l10n.analytics,
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined),
              selectedIcon: const Icon(Icons.settings),
              label: l10n.settings,
            ),
          ],
        ),
      ),
    );
  }
}
