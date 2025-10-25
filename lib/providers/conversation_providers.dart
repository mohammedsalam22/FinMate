import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocketsage/core/constants/constants.dart';
import 'package:pocketsage/features/ai_assistant/models/conversation.dart';
import 'package:pocketsage/features/ai_assistant/models/chat_message.dart';
import 'package:pocketsage/features/ai_assistant/repositories/conversation_repository.dart';
import 'package:pocketsage/providers/app_providers.dart';

// Conversation Repository Provider
final conversationRepositoryProvider = Provider<ConversationRepository>((ref) {
  final userId = ref.watch(currentUserProvider).id;
  final box = Hive.box<Conversation>(HiveBoxes.conversations);
  return ConversationRepository(box, userId);
});

// Current Conversation Provider
final currentConversationProvider = NotifierProvider<CurrentConversationNotifier, Conversation?>(CurrentConversationNotifier.new);

// Conversation Messages Provider
final conversationMessagesProvider = NotifierProvider<ConversationMessagesNotifier, List<ChatMessage>>(ConversationMessagesNotifier.new);

// All User Conversations Provider
final userConversationsProvider = FutureProvider<List<Conversation>>((ref) async {
  final repository = ref.watch(conversationRepositoryProvider);
  return await repository.getUserConversations();
});

// Notifier classes
class CurrentConversationNotifier extends Notifier<Conversation?> {
  @override
  Conversation? build() => null;
  
  void setConversation(Conversation? conversation) {
    state = conversation;
  }
}

class ConversationMessagesNotifier extends Notifier<List<ChatMessage>> {
  @override
  List<ChatMessage> build() => [];
  
  void setMessages(List<ChatMessage> messages) {
    state = messages;
  }
  
  void addMessage(ChatMessage message) {
    state = [...state, message];
  }
  
  void clearMessages() {
    state = [];
  }
}

// Conversation Service Provider
final conversationServiceProvider = Provider<ConversationService>((ref) {
  final repository = ref.watch(conversationRepositoryProvider);
  
  return ConversationService(
    repository: repository,
    ref: ref,
  );
});

class ConversationService {
  final ConversationRepository repository;
  final Ref ref;

  ConversationService({
    required this.repository,
    required this.ref,
  });

  // Start new conversation
  Future<Conversation> startNewConversation({String? title}) async {
    // Create new conversation
    final conversation = await repository.createConversation(title: title);
    
    // Set as active
    await repository.setActiveConversation(conversation.id);
    
    // Update state
    ref.read(currentConversationProvider.notifier).setConversation(conversation);
    ref.read(conversationMessagesProvider.notifier).clearMessages();
    
    return conversation;
  }

  // Load existing conversation
  Future<void> loadConversation(String conversationId) async {
    final conversation = await repository.getConversation(conversationId);
    if (conversation != null) {
      final conversationMessages = await repository.getMessages(conversationId);
      
      // Set as active
      await repository.setActiveConversation(conversationId);
      
      // Update state
      ref.read(currentConversationProvider.notifier).setConversation(conversation);
      ref.read(conversationMessagesProvider.notifier).setMessages(conversationMessages);
    }
  }

  // Add message to current conversation
  Future<void> addMessage(ChatMessage message) async {
    final conversation = ref.read(currentConversationProvider);
    if (conversation == null) {
      // Start new conversation if none exists
      await startNewConversation();
      final newConversation = ref.read(currentConversationProvider)!;
      await repository.addMessage(newConversation.id, message);
    } else {
      await repository.addMessage(conversation.id, message);
    }
    
    // Update local state
    ref.read(conversationMessagesProvider.notifier).addMessage(message);
  }

  // Clear current conversation
  Future<void> clearCurrentConversation() async {
    final conversation = ref.read(currentConversationProvider);
    if (conversation != null) {
      await repository.deleteConversation(conversation.id);
    }
    
    ref.read(currentConversationProvider.notifier).setConversation(null);
    ref.read(conversationMessagesProvider.notifier).clearMessages();
  }

  // Delete a specific conversation
  Future<void> deleteConversation(String conversationId) async {
    await repository.deleteConversation(conversationId);
    
    // If the deleted conversation was the current one, clear it
    final currentConversation = ref.read(currentConversationProvider);
    if (currentConversation?.id == conversationId) {
      ref.read(currentConversationProvider.notifier).setConversation(null);
      ref.read(conversationMessagesProvider.notifier).clearMessages();
    }
    
    // Refresh the conversations list
    ref.invalidate(userConversationsProvider);
  }

  // Update conversation title
  Future<void> updateConversationTitle(String title) async {
    final conversation = ref.read(currentConversationProvider);
    if (conversation != null) {
      await repository.updateConversationTitle(conversation.id, title);
      
      // Update local state
      ref.read(currentConversationProvider.notifier).setConversation(conversation.copyWith(title: title));
    }
  }

  // Get conversation history for AI
  List<ChatMessage> getConversationHistory() {
    return ref.read(conversationMessagesProvider);
  }

  // Cleanup old conversations
  Future<void> cleanupOldConversations({int maxAgeInDays = 30}) async {
    await repository.cleanupOldConversations(maxAgeInDays: maxAgeInDays);
  }

  // Get cache statistics
  Map<String, dynamic> getCacheStats() {
    return repository.getCacheStats();
  }
}