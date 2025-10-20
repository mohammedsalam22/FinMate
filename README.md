# FinMate - Personal Finance Manager 💰

A sleek, cross-platform Flutter application designed to help you master your money with an intuitive UI, offline-first capabilities, and comprehensive financial tracking.

## Features

### 💳 Transaction Management
- Add and categorize income and expenses
- Real-time balance tracking
- Visual analytics with charts and breakdowns

### 🏦 Debt Management with Categories
- Hierarchical debt categorization system
- Track multiple debters across different categories (e.g., Cafeteria, Work, Personal)
- Detailed debt timeline with payment history
- Swipe-to-delete functionality for debt records

### 🌍 Internationalization (i18n)
- **Arabic and English** language support
- RTL (Right-to-Left) layout support for Arabic
- Real-time language switching without app restart

### 🎨 Modern UI/UX
- Dark and light theme support
- Material Design 3 components
- Responsive design for all screen sizes
- Smooth animations and transitions

### 📱 Cross-Platform
- **Android** - Native performance with offline storage
- **iOS** - Seamless iOS experience
- **Web** - Progressive Web App capabilities

## Architecture

### Clean Architecture
- **Separation of Concerns**: Domain-specific provider files
- **SOLID Principles**: Maintainable and scalable codebase
- **Repository Pattern**: Data abstraction layer

### State Management
- **Riverpod**: Reactive state management
- **Provider Organization**: 
  - `app_providers.dart` - User, theme, locale providers
  - `transaction_providers.dart` - Transaction-related providers
  - `debt_providers.dart` - Debt management providers
  - `category_providers.dart` - Category management providers
  - `analytics_providers.dart` - Analytics and summary providers

### Data Storage
- **Hive**: Local database for offline-first approach
- **SharedPreferences**: User settings and preferences
- **Memory Store**: Web fallback for development

## Getting Started

### Prerequisites
- Flutter SDK (>=3.6.0)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/mohammedsalam22/finmate.git
   cd finmate
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate localization files**
   ```bash
   flutter gen-l10n
   ```

4. **Run the app**
   ```bash
   # For Android
   flutter run

   # For iOS
   flutter run -d ios

   # For Web
   flutter run -d web-server
   ```

## Project Structure

```
lib/
├── core/
│   ├── constants/          # App constants and configuration
│   └── theme/             # App theming and colors
├── data/
│   ├── models/            # Data models and Hive adapters
│   ├── repositories/      # Data access layer
│   └── memory/            # In-memory storage for web
├── features/
│   ├── transactions/      # Transaction management screens
│   ├── debts/            # Debt management screens and widgets
│   ├── analytics/        # Analytics and reporting
│   └── settings/         # App settings and preferences
├── l10n/                 # Internationalization files
├── providers/            # State management providers
└── app.dart              # Main app configuration
```

## Key Technologies

- **Flutter**: Cross-platform UI framework
- **Riverpod**: State management
- **Hive**: Local database
- **GoRouter**: Navigation
- **fl_chart**: Data visualization
- **intl**: Internationalization

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Author

**Mohammed Salam** - [@mohammedsalam22](https://github.com/mohammedsalam22)

---

⭐ Star this repository if you found it helpful!
