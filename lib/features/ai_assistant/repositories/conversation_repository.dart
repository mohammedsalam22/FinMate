import 'package:flutter/foundation.dart' as foundation;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocketsage/features/ai_assistant/models/conversation.dart';
import 'package:pocketsage/features/ai_assistant/models/chat_message.dart';
import 'package:uuid/uuid.dart';

class ConversationRepository {
  final Box<Conversation> _box;
  final String userId;
  
  // Smart caching
  final Map<String, List<ChatMessage>> _activeCache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  final Map<String, Conversation> _conversationCache = {};
  
  // Cache expires after 5 minutes of inactivity
  static const Duration _cacheExpiry = Duration(minutes: 5);
  
  ConversationRepository(this._box, this.userId);

  // Create new conversation
  Future<Conversation> createConversation({String? title}) async {
    final conversation = Conversation(
      id: const Uuid().v4(),
      userId: userId,
      messages: [],
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
      title: title,
      isActive: true,
    );

    await _box.put(conversation.id, conversation);
    _conversationCache[conversation.id] = conversation;
    
    foundation.debugPrint('Created conversation: ${conversation.id}');
    return conversation;
  }

  // Get conversation by ID with caching
  Future<Conversation?> getConversation(String conversationId) async {
    // Check cache first
    if (_conversationCache.containsKey(conversationId)) {
      return _conversationCache[conversationId];
    }

    // Load from Hive
    final conversation = _box.get(conversationId);
    if (conversation != null) {
      _conversationCache[conversationId] = conversation;
    }
    
    return conversation;
  }

  // Get messages with smart caching
  Future<List<ChatMessage>> getMessages(String conversationId) async {
    // Check cache first
    if (_isCacheValid(conversationId)) {
      foundation.debugPrint('Returning cached messages for $conversationId');
      return _activeCache[conversationId]!;
    }

    // Load from Hive
    final conversation = await getConversation(conversationId);
    if (conversation == null) {
      foundation.debugPrint('Conversation $conversationId not found');
      return [];
    }

    // Cache the messages
    _activeCache[conversationId] = conversation.messages;
    _cacheTimestamps[conversationId] = DateTime.now();
    
    foundation.debugPrint('Loaded ${conversation.messages.length} messages for $conversationId');
    return conversation.messages;
  }

  // Add message to conversation
  Future<void> addMessage(String conversationId, ChatMessage message) async {
    final conversation = await getConversation(conversationId);
    if (conversation == null) {
      foundation.debugPrint('Cannot add message: conversation $conversationId not found');
      return;
    }

    // Update conversation
    final updatedMessages = [...conversation.messages, message];
    final updatedConversation = conversation.copyWith(
      messages: updatedMessages,
      updatedAt: DateTime.now().toUtc(),
    );

    // Save to Hive
    await _box.put(conversationId, updatedConversation);
    
    // Update cache
    _conversationCache[conversationId] = updatedConversation;
    _activeCache[conversationId] = updatedMessages;
    _cacheTimestamps[conversationId] = DateTime.now();
    
    foundation.debugPrint('Added message to conversation $conversationId');
  }

  // Get all user conversations
  Future<List<Conversation>> getUserConversations() async {
    final conversations = _box.values
        .where((c) => c.userId == userId)
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    
    foundation.debugPrint('Found ${conversations.length} conversations for user $userId');
    return conversations;
  }

  // Get active conversation
  Future<Conversation?> getActiveConversation() async {
    final conversations = await getUserConversations();
    return conversations.where((c) => c.isActive).firstOrNull;
  }

  // Set active conversation
  Future<void> setActiveConversation(String conversationId) async {
    // Deactivate all conversations
    final allConversations = await getUserConversations();
    for (final conversation in allConversations) {
      if (conversation.isActive) {
        final updated = conversation.copyWith(isActive: false);
        await _box.put(conversation.id, updated);
        _conversationCache[conversation.id] = updated;
      }
    }

    // Activate the specified conversation
    final conversation = await getConversation(conversationId);
    if (conversation != null) {
      final updated = conversation.copyWith(isActive: true);
      await _box.put(conversationId, updated);
      _conversationCache[conversationId] = updated;
      
      foundation.debugPrint('Set active conversation: $conversationId');
    }
  }

  // Update conversation title
  Future<void> updateConversationTitle(String conversationId, String title) async {
    final conversation = await getConversation(conversationId);
    if (conversation != null) {
      final updated = conversation.copyWith(
        title: title,
        updatedAt: DateTime.now().toUtc(),
      );
      
      await _box.put(conversationId, updated);
      _conversationCache[conversationId] = updated;
      
      foundation.debugPrint('Updated conversation title: $conversationId -> $title');
    }
  }

  // Delete conversation
  Future<void> deleteConversation(String conversationId) async {
    await _box.delete(conversationId);
    
    // Clear from cache
    _conversationCache.remove(conversationId);
    _activeCache.remove(conversationId);
    _cacheTimestamps.remove(conversationId);
    
    foundation.debugPrint('Deleted conversation: $conversationId');
  }

  // Clear all conversations
  Future<void> clearAllConversations() async {
    final userConversations = await getUserConversations();
    for (final conversation in userConversations) {
      await _box.delete(conversation.id);
    }
    
    // Clear all caches
    _conversationCache.clear();
    _activeCache.clear();
    _cacheTimestamps.clear();
    
    foundation.debugPrint('Cleared all conversations for user $userId');
  }

  // Cleanup old conversations
  Future<void> cleanupOldConversations({int maxAgeInDays = 30}) async {
    final cutoff = DateTime.now().subtract(Duration(days: maxAgeInDays));
    final userConversations = await getUserConversations();
    
    int deletedCount = 0;
    for (final conversation in userConversations) {
      if (conversation.updatedAt.isBefore(cutoff) && !conversation.isActive) {
        await _box.delete(conversation.id);
        _conversationCache.remove(conversation.id);
        _activeCache.remove(conversation.id);
        _cacheTimestamps.remove(conversation.id);
        deletedCount++;
      }
    }
    
    foundation.debugPrint('Cleaned up $deletedCount old conversations');
  }

  // Cache management
  bool _isCacheValid(String conversationId) {
    if (!_activeCache.containsKey(conversationId)) return false;
    
    final timestamp = _cacheTimestamps[conversationId];
    if (timestamp == null) return false;
    
    return DateTime.now().difference(timestamp) < _cacheExpiry;
  }

  // Clear expired cache entries
  void clearExpiredCache() {
    final now = DateTime.now();
    final expiredKeys = _cacheTimestamps.entries
        .where((entry) => now.difference(entry.value) >= _cacheExpiry)
        .map((entry) => entry.key)
        .toList();
    
    for (final key in expiredKeys) {
      _activeCache.remove(key);
      _cacheTimestamps.remove(key);
    }
    
    if (expiredKeys.isNotEmpty) {
      foundation.debugPrint('Cleared ${expiredKeys.length} expired cache entries');
    }
  }

  // Get cache statistics
  Map<String, dynamic> getCacheStats() {
    return {
      'activeCacheSize': _activeCache.length,
      'conversationCacheSize': _conversationCache.length,
      'cacheTimestampsSize': _cacheTimestamps.length,
    };
  }
}
