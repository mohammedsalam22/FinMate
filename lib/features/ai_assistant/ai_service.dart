import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pocketsage/features/ai_assistant/models/chat_message.dart';
import 'package:pocketsage/features/ai_assistant/context_builder.dart';
import 'package:pocketsage/l10n/app_localizations.dart';

class AiService {
  static const int _maxRetries = 3;
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

  final ContextBuilder _contextBuilder;
  String? _apiKey;
  String? _cachedContext; // Cache context to avoid rebuilding
  DateTime? _lastContextUpdate;

  AiService(this._contextBuilder) {
    _initializeApiKey();
  }

  void _initializeApiKey() {
    _apiKey = dotenv.env['GEMINI_API_KEY'];
    if (_apiKey == null || _apiKey!.isEmpty) {
      debugPrint('GEMINI_API_KEY not found in environment variables');
    } else {
      debugPrint('Successfully initialized API key');
    }
  }

  bool get isInitialized => _apiKey != null && _apiKey!.isNotEmpty;

  Future<ChatMessage> sendMessage(String userMessage,
      {List<ChatMessage>? conversationHistory, AppLocalizations? l10n}) async {
    if (!isInitialized) {
      final apiKey = dotenv.env['GEMINI_API_KEY'];
      String errorMessage = l10n?.aiServiceNotConfigured ??
          'AI service is not properly configured.';

      if (apiKey == null || apiKey.isEmpty) {
        errorMessage = l10n?.apiKeyNotFound ??
            'API key not found. Please create a .env file with GEMINI_API_KEY=your_key_here';
      } else if (apiKey == 'your_api_key_here') {
        errorMessage = l10n?.apiKeyPlaceholder ??
            'Please replace "your_api_key_here" in .env file with your actual Google Gemini API key';
      } else {
        errorMessage = l10n?.aiModelInitFailed ??
            'Failed to initialize AI model. Please check your API key.';
      }

      return ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: errorMessage,
        type: MessageType.system,
        timestamp: DateTime.now(),
        error: 'Service not initialized',
      );
    }

    try {
      // Use cached context if available and recent (within 30 seconds)
      String context;
      final now = DateTime.now();
      if (_cachedContext != null &&
          _lastContextUpdate != null &&
          now.difference(_lastContextUpdate!).inSeconds < 30) {
        context = _cachedContext!;
      } else {
        context = _contextBuilder.buildFinancialContext();
        _cachedContext = context;
        _lastContextUpdate = now;
      }

      // Create optimized system prompt with conversation history
      final systemPrompt = l10n?.aiSystemPrompt(
            context,
            _contextBuilder.getAvailableCategories().join(', '),
            _buildConversationContext(conversationHistory),
            userMessage,
          ) ??
          '''You are FinMate's AI assistant. Current data: $context
Categories: ${_contextBuilder.getAvailableCategories().join(', ')}

For actions that modify data, use this format: ACTION:TYPE|param1|param2|param3
Available action types: ADD_TRANSACTION, ADD_DEBT, ADD_PAYMENT, QUERY, SUMMARY

Examples:
- Add expense: ACTION:ADD_TRANSACTION|25.50|groceries|expense|Coffee and sandwich
- Add income: ACTION:ADD_TRANSACTION|1000|salary|income|Monthly salary
- Add debt: ACTION:ADD_DEBT|John|500|personal|2024-12-31

IMPORTANT: When user asks to add a transaction, immediately generate the ACTION format. Don't ask for clarification unless absolutely necessary.

Always confirm actions before executing. Keep responses brief and helpful.

${_buildConversationContext(conversationHistory)}
User: $userMessage''';

      // Send HTTP request to Gemini API
      final response = await _sendHttpRequest(systemPrompt);

      if (response.error != null) {
        return response;
      }

      return ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: response.content,
        type: MessageType.ai,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      // Log error for debugging
      debugPrint('Error sending message to AI: $e');

      String errorMessage = l10n?.aiEncounteredError ??
          'Sorry, I encountered an error. Please try again.';

      if (e.toString().contains('API_KEY')) {
        errorMessage = l10n?.apiKeyInvalid ??
            'API key is invalid. Please check your configuration.';
      } else if (e.toString().contains('quota')) {
        errorMessage = l10n?.apiQuotaExceeded ??
            'API quota exceeded. Please try again later.';
      } else if (e.toString().contains('network')) {
        errorMessage = l10n?.networkError ??
            'Network error. Please check your internet connection.';
      }

      return ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: errorMessage,
        type: MessageType.system,
        timestamp: DateTime.now(),
        error: e.toString(),
      );
    }
  }

  Future<ChatMessage> sendMessageWithRetry(String userMessage,
      {List<ChatMessage>? conversationHistory, AppLocalizations? l10n}) async {
    for (int attempt = 1; attempt <= _maxRetries; attempt++) {
      try {
        final response = await sendMessage(userMessage,
            conversationHistory: conversationHistory, l10n: l10n);
        if (response.error == null) {
          return response;
        }

        // If it's a configuration error, don't retry
        if (response.error == 'Service not initialized') {
          return response;
        }

        if (attempt < _maxRetries) {
          // Shorter wait time for faster retries
          await Future.delayed(Duration(milliseconds: 500 * attempt));
        }
      } catch (e) {
        if (attempt == _maxRetries) {
          return ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            content: l10n?.failedAfterRetries(attempt) ??
                'Failed to get response after $attempt attempts. Please try again later.',
            type: MessageType.system,
            timestamp: DateTime.now(),
            error: e.toString(),
          );
        }
      }
    }

    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: l10n?.unableToProcessRequest ??
          'Unable to process your request. Please try again.',
      type: MessageType.system,
      timestamp: DateTime.now(),
      error: 'Max retries exceeded',
    );
  }

  void clearConversation() {
    // Clear cached context to force refresh
    _cachedContext = null;
    _lastContextUpdate = null;
    debugPrint('Conversation cleared');
  }

  String _buildConversationContext(List<ChatMessage>? conversationHistory) {
    if (conversationHistory == null || conversationHistory.isEmpty) {
      return '';
    }

    // Build conversation context from recent messages (last 10 exchanges)
    final recentHistory =
        conversationHistory.take(20).toList(); // 10 exchanges = 20 messages
    final contextBuffer = StringBuffer();

    for (final message in recentHistory) {
      final role = message.type == MessageType.user ? 'User' : 'Assistant';
      contextBuffer.writeln('$role: ${message.content}');
    }

    return 'Recent conversation:\n$contextBuffer';
  }

  List<ChatMessage> getConversationHistory() {
    // Conversation history is now managed by the UI
    return [];
  }

  String? extractActionFromResponse(String response) {
    // Look for ACTION: pattern in the response
    final actionPattern = RegExp(r'ACTION:([^|]+)\|([^|]+)\|([^|]+)\|([^|]*)');
    final match = actionPattern.firstMatch(response);

    if (match != null) {
      return response.substring(match.start, match.end);
    }

    return null;
  }

  bool hasActionInResponse(String response) {
    return response.contains('ACTION:');
  }

  Future<ChatMessage> _sendHttpRequest(String prompt) async {
    final url = Uri.parse('$_baseUrl?key=$_apiKey');

    final requestBody = {
      'contents': [
        {
          'parts': [
            {'text': prompt}
          ]
        }
      ],
      'generationConfig': {
        'temperature':
            0.3, // Lower temperature for faster, more focused responses
        'maxOutputTokens': 500, // Reduced token limit for faster responses
        'topP': 0.8, // Optimized for speed
        'topK': 20, // Optimized for speed
      }
    };

    try {
      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(Duration(
              seconds: 15)); // Add timeout for faster failure detection

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Check if response has the expected structure
        if (data['candidates'] != null &&
            data['candidates'].isNotEmpty &&
            data['candidates'][0]['content'] != null &&
            data['candidates'][0]['content']['parts'] != null &&
            data['candidates'][0]['content']['parts'].isNotEmpty) {
          final content = data['candidates'][0]['content']['parts'][0]
                  ['text'] ??
              'No response generated';
          return ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            content: content,
            type: MessageType.ai,
            timestamp: DateTime.now(),
          );
        } else {
          debugPrint('Unexpected API response structure: $data');
          return ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            content:
                'Sorry, I received an unexpected response format. Please try again.',
            type: MessageType.system,
            timestamp: DateTime.now(),
            error: 'Unexpected response structure',
          );
        }
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['error']['message'] ?? 'Unknown error';
        debugPrint('API Error: $errorMessage');
        return ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: 'Error: $errorMessage',
          type: MessageType.system,
          timestamp: DateTime.now(),
          error: errorMessage,
        );
      }
    } catch (e) {
      debugPrint('HTTP Error: $e');
      return ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: 'Network error: $e',
        type: MessageType.system,
        timestamp: DateTime.now(),
        error: e.toString(),
      );
    }
  }
}
