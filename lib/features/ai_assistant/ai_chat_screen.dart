import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketsage/providers/providers.dart';
import 'package:pocketsage/providers/conversation_providers.dart';
import 'package:pocketsage/features/ai_assistant/models/chat_message.dart';
import 'package:pocketsage/features/ai_assistant/models/ai_action.dart';
import 'package:pocketsage/features/ai_assistant/widgets/message_bubble.dart';
import 'package:pocketsage/features/ai_assistant/widgets/quick_action_chips.dart';
import 'package:pocketsage/features/ai_assistant/widgets/conversation_history_drawer.dart';
import 'package:pocketsage/features/ai_assistant/widgets/action_confirmation_dialog.dart';
import 'package:pocketsage/features/ai_assistant/widgets/typing_indicator.dart';
import 'package:pocketsage/features/ai_assistant/intent_parser.dart';
import 'package:pocketsage/core/theme/theme.dart';
import 'package:pocketsage/l10n/app_localizations.dart';

class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final messages = ref.watch(conversationMessagesProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      drawer: const ConversationHistoryDrawer(),
      appBar: AppBar(
        title: Text(l10n.aiAssistant),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: isDark ? AppColors.darkText : AppColors.lightText,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_comment),
            onPressed: () => _startNewChat(),
            tooltip: l10n.startNewChat,
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick Action Chips
          QuickActionChips(
            onActionSelected: _sendQuickAction,
          ),

          // Messages List
          Expanded(
            child: messages.isEmpty && !_isLoading
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: messages.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == messages.length && _isLoading) {
                        return const TypingIndicator();
                      }
                      final message = messages[index];
                      return MessageBubble(message: message);
                    },
                  ),
          ),

          // Error Banner
          if (_error != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.errorRose.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: AppColors.errorRose.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline,
                      color: AppColors.errorRose, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _error!,
                      style:
                          TextStyle(color: AppColors.errorRose, fontSize: 12),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 16),
                    onPressed: () => setState(() => _error = null),
                  ),
                ],
              ),
            ),

          // Input Area
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    enabled: !_isLoading,
                    decoration: InputDecoration(
                      hintText: _isLoading
                          ? l10n.aiResponding
                          : l10n.askMeAboutFinances,
                      hintStyle: TextStyle(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: (isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary)
                              .withValues(alpha: 0.2),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: (isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary)
                              .withValues(alpha: 0.2),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: AppColors.primaryIndigo.withValues(alpha: 0.5),
                          width: 1,
                        ),
                      ),
                      filled: true,
                      fillColor: isDark
                          ? AppColors.darkBackground
                          : AppColors.lightBackground,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: _isLoading ? null : (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton.small(
                  heroTag: 'aiSendFab',
                  onPressed: _isLoading ? null : _sendMessage,
                  backgroundColor: _isLoading
                      ? (isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary)
                      : AppColors.primaryIndigo,
                  child: Icon(
                    Icons.send,
                    color: _isLoading
                        ? (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary)
                        : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.smart_toy,
            size: 64,
            color: AppColors.primaryIndigo.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.aiAssistantTitle,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.aiAssistantDescription,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty || _isLoading) return;

    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    _messageController.clear();

    // Add user message
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: message,
      type: MessageType.user,
      timestamp: DateTime.now(),
    );

    // Add to conversation service
    final conversationService = ref.read(conversationServiceProvider);
    await conversationService.addMessage(userMessage);

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    try {
      // Get AI service and send message
      final aiService = ref.read(aiServiceProvider);
      final conversationHistory = ref.read(conversationMessagesProvider);
      final response = await aiService.sendMessageWithRetry(message,
          conversationHistory: conversationHistory, l10n: l10n);

      // Add AI response
      final aiMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: response.content,
        type: MessageType.ai,
        timestamp: DateTime.now(),
        error: response.error,
      );

      // Add to conversation service
      await conversationService.addMessage(aiMessage);

      // Update conversation history in AI service (this is now handled automatically in sendMessage)

      // Check if response contains an action
      if (IntentParser.hasActionInResponse(response.content)) {
        final action = IntentParser.extractActionFromResponse(response.content);
        if (action != null && action.needsConfirmation) {
          _showActionConfirmation(action);
        }
      }

      // Scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      final errorMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: l10n.aiEncounteredError,
        type: MessageType.system,
        timestamp: DateTime.now(),
        error: e.toString(),
      );

      // Add error message to conversation
      await conversationService.addMessage(errorMessage);
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _sendQuickAction(String prompt) async {
    _messageController.text = prompt;
    await _sendMessage();
  }

  void _startNewChat() {
    final conversationService = ref.read(conversationServiceProvider);
    conversationService.startNewConversation();
    setState(() {
      _error = null;
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _showActionConfirmation(AiAction action) {
    showDialog(
      context: context,
      builder: (context) => ActionConfirmationDialog(
        action: action,
        onConfirm: () => _executeAction(action),
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }

  Future<void> _executeAction(AiAction action) async {
    Navigator.of(context).pop(); // Close dialog

    final l10n = AppLocalizations.of(context)!;
    // Show loading message
    final loadingMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: l10n.executingAction,
      type: MessageType.system,
      timestamp: DateTime.now(),
    );

    // Add loading message to conversation
    final conversationService = ref.read(conversationServiceProvider);
    await conversationService.addMessage(loadingMessage);

    try {
      final actionExecutor = ref.read(actionExecutorProvider);
      final result = await actionExecutor.executeAction(action);

      // Replace loading message with result
      final resultMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: result.message,
        type: MessageType.system,
        timestamp: DateTime.now(),
        error: result.success ? null : result.error,
      );

      // Add result message to conversation
      await conversationService.addMessage(resultMessage);
    } catch (e) {
      final errorMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: l10n.failedToExecuteAction(e.toString()),
        type: MessageType.system,
        timestamp: DateTime.now(),
        error: e.toString(),
      );

      // Add error message to conversation
      await conversationService.addMessage(errorMessage);
    }
  }
}
