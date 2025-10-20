# FinMate - Architecture Plan

## Overview
FinMate is a personal finance & expense tracker with offline-first approach, clean architecture, and optional cloud sync. Built with Flutter, Riverpod, Hive, and Supabase.

## Tech Stack
- **UI**: Flutter with shadcn_flutter for sleek, modern components
- **State Management**: Riverpod (flutter_riverpod)
- **Local Storage**: Hive + hive_flutter
- **Cloud Backend**: Supabase (optional sync)
- **Navigation**: go_router
- **Charts**: fl_chart
- **Localization**: intl, flutter_localizations (en, nl)
- **Security**: flutter_secure_storage

## Architecture Layers
```
UI Layer (shadcn_flutter widgets)
    ↓
State Layer (Riverpod providers)
    ↓
Domain Layer (use cases, business logic)
    ↓
Repository Layer (interfaces)
    ↓           ↓
Hive (local)  Supabase (remote)
    ↘         ↙
   Sync Manager
```

## Folder Structure
```
lib/
├── core/
│   ├── constants.dart
│   ├── providers.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── utils/
│       ├── currency_formatter.dart
│       └── date_helpers.dart
├── l10n/
│   ├── app_en.arb
│   └── app_nl.arb
├── data/
│   ├── models/
│   │   ├── user.dart
│   │   ├── transaction.dart
│   │   ├── category.dart
│   │   ├── budget.dart
│   │   └── recurring_rule.dart
│   ├── repositories/
│   │   ├── transaction_repository.dart
│   │   ├── category_repository.dart
│   │   ├── budget_repository.dart
│   │   └── settings_repository.dart
│   └── sources/
│       ├── local/
│       │   └── hive_service.dart
│       └── remote/
│           └── supabase_service.dart
├── features/
│   ├── auth/
│   │   └── auth_screen.dart
│   ├── transactions/
│   │   ├── transactions_list_screen.dart
│   │   ├── add_transaction_screen.dart
│   │   └── transaction_card.dart
│   ├── analytics/
│   │   └── analytics_screen.dart
│   └── settings/
│       └── settings_screen.dart
├── app.dart
└── main.dart
```

## Data Models

### 1. User
- id (String, UUID)
- email (String?)
- createdAt (DateTime)
- settings (Map)

### 2. Transaction
- id (String, UUID)
- userId (String)
- amount (double)
- currency (String, default: 'EUR')
- type (enum: income/expense)
- categoryId (String)
- date (DateTime)
- notes (String?)
- receiptUrl (String?)
- syncStatus (enum: synced/pending/conflict)
- createdAt (DateTime)
- updatedAt (DateTime)

### 3. Category
- id (String, UUID)
- userId (String)
- name (String)
- icon (String, IconData name)
- color (int, Color value)
- type (enum: income/expense)

### 4. Budget
- id (String, UUID)
- userId (String)
- categoryId (String)
- amount (double)
- periodStart (DateTime)
- periodEnd (DateTime)
- createdAt (DateTime)
- updatedAt (DateTime)

### 5. RecurringRule
- id (String, UUID)
- userId (String)
- amount (double)
- categoryId (String)
- frequency (enum: daily/weekly/monthly)
- nextDue (DateTime)
- notes (String?)

## Core Features - MVP

### Phase 1: Foundation (Files: 6)
1. Setup dependencies and Hive initialization
2. Core models with Hive adapters (User, Transaction, Category)
3. Theme configuration with sleek, modern colors
4. Basic navigation setup with go_router
5. Settings repository for theme persistence
6. Anonymous local user flow

### Phase 2: Transactions (Files: 4)
1. Transaction repository (Hive-backed)
2. Category service with default categories
3. Add/Edit transaction screen with beautiful form UI
4. Transactions list screen with grouping by date

### Phase 3: Analytics & Settings (Files: 2)
1. Analytics screen with charts (income vs expenses)
2. Settings screen with theme toggle

## Implementation Steps

### Step 1: Dependencies & Setup
- Add all required packages to pubspec.yaml
- Initialize Hive in main.dart
- Register Hive adapters
- Setup go_router for navigation

### Step 2: Theme & Core
- Update theme.dart with modern, sleek colors (avoiding Material Design patterns)
- Create constants.dart for app-wide values
- Setup currency formatter and date helpers

### Step 3: Data Layer
- Create models with Hive type adapters
- Implement repositories for transactions, categories, budgets
- Add sample default categories
- Create HiveService for local storage abstraction

### Step 4: State Management
- Setup Riverpod providers for:
  - hiveBoxProvider
  - settingsProvider (theme mode persistence)
  - transactionsRepositoryProvider
  - transactionsListProvider
  - categoriesProvider
  - analyticsProvider

### Step 5: UI Implementation
- Create transaction list screen with grouped transactions
- Build add/edit transaction form with shadcn_flutter components
- Implement analytics screen with fl_chart
- Create settings screen with theme toggle

### Step 6: Testing & Polish
- Run dart analyze and fix all errors
- Test theme persistence
- Test transaction CRUD operations
- Verify offline-first functionality

## Color Palette (Modern & Sleek)
- Primary: Deep indigo (#4F46E5) / Soft lavender (#A5B4FC) for dark
- Success: Emerald (#10B981)
- Error: Rose (#F43F5E)
- Warning: Amber (#F59E0B)
- Background Light: Neutral (#F9FAFB)
- Background Dark: Slate (#0F172A)
- Surface Light: White (#FFFFFF) with subtle shadows
- Surface Dark: Dark slate (#1E293B)
- Text: Neutral 900 / Neutral 100

## Notes
- Start with local-only storage (Hive)
- Supabase integration is optional and can be added later
- Use freezed for immutable models with copyWith
- Use uuid package for client-side ID generation
- All timestamps in UTC
- Currency default: EUR (can be configurable later)
- Localization setup for en/nl (arb files)

## File Count: ~11 files total (MVP)
- Core: 4 (main, app, theme, constants)
- Models: 3 (user, transaction, category)
- Repositories: 2 (transaction_repository, settings_repository)
- Screens: 3 (transactions_list, add_transaction, settings)
- Utils: 1 (hive_service)

This MVP focuses on core transaction tracking with offline persistence, beautiful UI, and theme toggle.
