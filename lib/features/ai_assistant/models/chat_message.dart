import 'package:hive/hive.dart';

part 'chat_message.g.dart';

@HiveType(typeId: 11)
enum MessageType {
  @HiveField(0)
  user,
  @HiveField(1)
  ai,
  @HiveField(2)
  system,
}

@HiveType(typeId: 12)
class ChatMessage {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String content;

  @HiveField(2)
  final MessageType type;

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4)
  final bool isLoading;

  @HiveField(5)
  final String? error;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.type,
    required this.timestamp,
    this.isLoading = false,
    this.error,
  });

  ChatMessage copyWith({
    String? id,
    String? content,
    MessageType? type,
    DateTime? timestamp,
    bool? isLoading,
    String? error,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  bool get isUser => type == MessageType.user;
  bool get isAi => type == MessageType.ai;
  bool get isSystem => type == MessageType.system;
}
