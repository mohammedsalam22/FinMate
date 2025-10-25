# FinMate - Personal Finance Manager 💰

A sleek, cross-platform Flutter application designed to help you master your money with an intuitive UI, offline-first capabilities, comprehensive financial tracking, and an intelligent AI assistant.

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

### 🤖 AI Assistant (NEW!)
- **Conversational AI** powered by Google Gemini
- **Smart financial insights** and summaries
- **Voice-like commands** for adding transactions and debts
- **Quick action chips** for common operations
- **Full automation** with user confirmation
- **Multi-language support** (English & Arabic)

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

## AI Assistant Setup

The AI Assistant uses Google Gemini API (free tier) to provide intelligent financial assistance.

### Prerequisites
1. **Google AI Studio Account**: Sign up at [Google AI Studio](https://aistudio.google.com/)
2. **API Key**: Generate a free API key from Google AI Studio

### Setup Instructions

1. **Create `.env` file** in the project root:
   ```bash
   # Create .env file
   touch .env
   ```

2. **Add your API key** to `.env`:
   ```env
   GEMINI_API_KEY=your_api_key_here
   ```

3. **Get your API key**:
   - Go to [Google AI Studio](https://aistudio.google.com/)
   - Sign in with your Google account
   - Click "Get API Key" 
   - Create a new API key
   - Copy the key and paste it in your `.env` file

4. **Run the app**:
   ```bash
   flutter pub get
   flutter run
   ```

### AI Assistant Features

#### 💬 Conversational Interface
- Natural language processing
- Multi-turn conversations
- Context-aware responses

#### 📊 Financial Insights
- "How much did I spend this week?"
- "Show me my top spending categories"
- "What's my current balance?"
- "Compare this month to last month"

#### ⚡ Quick Actions
- **Summarize this week** - Get weekly financial summary
- **Show spending breakdown** - Category-wise expense analysis
- **Add expense** - Quick expense entry
- **Check debts** - Outstanding debt overview
- **Current balance** - Instant balance check
- **Top categories** - Most used expense categories

#### 🔧 Smart Automation
- **Add transactions**: "Add €25 coffee expense"
- **Manage debts**: "Record €50 payment from John"
- **Create debts**: "Add €200 debt from Sarah in Work category"
- **Get summaries**: "Show me all debts in Cafeteria category"

#### 🛡️ Privacy & Security
- Only aggregated financial summaries sent to AI
- No raw transaction data transmitted
- User confirmation required for all actions
- Free tier: 1,500 requests/day (plenty for personal use)

### API Limits (Free Tier)
- **15 requests per minute**
- **1,500 requests per day**
- **No credit card required**
- **Perfect for personal finance apps**

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
  - `ai_providers.dart` - AI assistant providers (NEW!)

### Data Storage
- **Hive**: Local database for offline-first approach
- **SharedPreferences**: User settings and preferences
- **Memory Store**: Web fallback for development

## Getting Started

### Prerequisites
- Flutter SDK (>=3.6.0)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Google AI Studio account (for AI Assistant)

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

3. **Setup AI Assistant** (Optional but recommended)
   ```bash
   # Create .env file
   echo "GEMINI_API_KEY=your_api_key_here" > .env
   ```

4. **Generate localization files**
   ```bash
   flutter gen-l10n
   ```

5. **Run the app**
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
│   ├── settings/         # App settings and preferences
│   └── ai_assistant/     # AI Assistant feature (NEW!)
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
- **Google Generative AI**: AI Assistant backend (NEW!)
- **flutter_markdown**: AI response formatting (NEW!)

## AI Assistant Usage Examples

### 💰 Financial Queries
```
User: "How much did I spend this week?"
AI: "You spent €127.50 this week across 8 transactions. Top category: Food (€45.20)."

User: "What's my current balance?"
AI: "Your current balance is €1,234.56. You have €2,500 in income and €1,265.44 in expenses."
```

### ⚡ Quick Actions
```
User: "Add €25 coffee expense"
AI: "I'll add a €25 expense for Coffee. [Confirm button shown]"

User: "Record €50 payment from John"
AI: "I'll record a €50 payment from John. [Confirm button with debt selection shown]"
```

### 📊 Insights & Analysis
```
User: "Show me spending patterns"
AI: "Your spending patterns show: Food (35%), Transport (20%), Entertainment (15%). You're spending 20% more on dining out this month."

User: "Who owes me money?"
AI: "You have 3 outstanding debts totaling €450: John (€200), Sarah (€150), Mike (€100)."
```

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