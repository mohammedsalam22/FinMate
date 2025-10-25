import 'package:hive/hive.dart';
import 'package:pocketsage/features/ai_assistant/models/chat_message.dart';

part 'conversation.g.dart';

@HiveType(typeId: 10)
class Conversation extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final List<ChatMessage> messages;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final DateTime updatedAt;

  @HiveField(5)
  final String? title;

  @HiveField(6)
  final bool isActive;

  Conversation({
    required this.id,
    required this.userId,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
    this.title,
    this.isActive = false,
  });

  Conversation copyWith({
    String? id,
    String? userId,
    List<ChatMessage>? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? title,
    bool? isActive,
  }) {
    return Conversation(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      title: title ?? this.title,
      isActive: isActive ?? this.isActive,
    );
  }

  // Helper methods
  String get displayTitle => title ?? _generateTitle();
  
  String _generateTitle() {
    if (messages.isEmpty) return 'New Conversation';
    
    final firstUserMessage = messages.firstWhere(
      (m) => m.type == MessageType.user,
      orElse: () => messages.first,
    );
    
    // Truncate long messages for title
    final content = firstUserMessage.content;
    if (content.length <= 30) return content;
    return '${content.substring(0, 30)}...';
  }

  int get messageCount => messages.length;
  
  DateTime get lastMessageTime {
    if (messages.isEmpty) return createdAt;
    return messages.last.timestamp;
  }

  bool get hasMessages => messages.isNotEmpty;
  
  List<ChatMessage> get userMessages => 
      messages.where((m) => m.type == MessageType.user).toList();
  
  List<ChatMessage> get aiMessages => 
      messages.where((m) => m.type == MessageType.ai).toList();

  @override
  String toString() {
    return 'Conversation(id: $id, title: $displayTitle, messageCount: $messageCount, isActive: $isActive)';
  }
}
