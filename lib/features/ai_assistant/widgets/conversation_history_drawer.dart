import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketsage/features/ai_assistant/models/conversation.dart';
import 'package:pocketsage/features/ai_assistant/models/chat_message.dart';
import 'package:pocketsage/providers/conversation_providers.dart';
import 'package:pocketsage/core/theme/theme.dart';
import 'package:intl/intl.dart';
import 'package:pocketsage/l10n/app_localizations.dart';

class ConversationHistoryDrawer extends ConsumerStatefulWidget {
  const ConversationHistoryDrawer({super.key});

  @override
  ConsumerState<ConversationHistoryDrawer> createState() =>
      _ConversationHistoryDrawerState();
}

class _ConversationHistoryDrawerState
    extends ConsumerState<ConversationHistoryDrawer> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final conversationsAsync = ref.watch(userConversationsProvider);
    final currentConversation = ref.watch(currentConversationProvider);
    final l10n = AppLocalizations.of(context)!;

    return Drawer(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
            decoration: BoxDecoration(
              color:
                  isDark ? AppColors.darkBackground : AppColors.lightBackground,
              border: Border(
                bottom: BorderSide(
                  color: (isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary)
                      .withValues(alpha: 0.1),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.history,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.chatHistory,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:
                            isDark ? AppColors.darkText : AppColors.lightText,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        Icons.delete_sweep,
                        color: AppColors.errorRose,
                        size: 20,
                      ),
                      onPressed: () => _showDeleteAllConfirmation(),
                      tooltip: 'Delete all conversations',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Search bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: l10n.searchChats,
                    prefixIcon: Icon(
                      Icons.search,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor:
                        isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                  onChanged: (value) {
                    setState(() => _searchQuery = value.toLowerCase());
                  },
                ),
              ],
            ),
          ),

          // Conversations list
          Expanded(
            child: conversationsAsync.when(
              data: (conversations) {
                final filteredConversations =
                    _filterConversations(conversations);
                final groupedConversations =
                    _groupConversationsByDay(filteredConversations);

                if (filteredConversations.isEmpty) {
                  return _buildEmptyState(isDark);
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: groupedConversations.length,
                  itemBuilder: (context, index) {
                    final dayGroup = groupedConversations[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Day header
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Text(
                            dayGroup['day'] as String,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                        ),
                        // Conversations for this day
                        ...dayGroup['conversations']!
                            .map<Widget>((conversation) {
                          final isActive =
                              currentConversation?.id == conversation.id;
                          return _buildConversationTile(
                            conversation,
                            isActive,
                            isDark,
                          );
                        }).toList(),
                      ],
                    );
                  },
                );
              },
              loading: () => Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryIndigo,
                ),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: AppColors.errorRose,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load conversations',
                      style: TextStyle(
                        color:
                            isDark ? AppColors.darkText : AppColors.lightText,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style: TextStyle(
                        color: AppColors.errorRose,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty
                ? 'No conversations yet'
                : 'No conversations found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty
                ? 'Start a new conversation to see it here'
                : 'Try adjusting your search terms',
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildConversationTile(
      Conversation conversation, bool isActive, bool isDark) {
    final conversationService = ref.read(conversationServiceProvider);
    final title = conversation.title ?? _generateTitle(conversation);
    final lastMessage =
        conversation.messages.isNotEmpty ? conversation.messages.last : null;
    final timeAgo = _getTimeAgo(conversation.updatedAt);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primaryIndigo.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isActive
            ? Border.all(color: AppColors.primaryIndigo.withValues(alpha: 0.3))
            : null,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isActive
              ? AppColors.primaryIndigo
              : (isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary),
          child: Icon(
            Icons.chat,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: lastMessage != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    lastMessage.content,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    timeAgo,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              )
            : Text(
                timeAgo,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
        trailing: PopupMenuButton<String>(
          icon: Icon(
            Icons.more_vert,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
          onSelected: (value) {
            switch (value) {
              case 'open':
                conversationService.loadConversation(conversation.id);
                Navigator.of(context).pop();
                break;
              case 'delete':
                _showDeleteConfirmation(conversation);
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'open',
              child: Row(
                children: [
                  Icon(Icons.open_in_new, size: 20),
                  const SizedBox(width: 8),
                  Text('Open'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: AppColors.errorRose, size: 20),
                  const SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: AppColors.errorRose)),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          conversationService.loadConversation(conversation.id);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  List<Conversation> _filterConversations(List<Conversation> conversations) {
    if (_searchQuery.isEmpty) return conversations;

    return conversations.where((conversation) {
      final title = conversation.title ?? _generateTitle(conversation);
      final lastMessage = conversation.messages.isNotEmpty
          ? conversation.messages.last.content
          : '';

      return title.toLowerCase().contains(_searchQuery) ||
          lastMessage.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  List<Map<String, dynamic>> _groupConversationsByDay(
      List<Conversation> conversations) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final thisWeek = today.subtract(Duration(days: now.weekday - 1));
    final thisMonth = DateTime(now.year, now.month, 1);

    final groups = <String, List<Conversation>>{};

    for (final conversation in conversations) {
      final conversationDate = DateTime(
        conversation.updatedAt.year,
        conversation.updatedAt.month,
        conversation.updatedAt.day,
      );

      String dayLabel;
      if (conversationDate == today) {
        dayLabel = 'Today';
      } else if (conversationDate == yesterday) {
        dayLabel = 'Yesterday';
      } else if (conversationDate.isAfter(thisWeek)) {
        dayLabel = 'This Week';
      } else if (conversationDate.isAfter(thisMonth)) {
        dayLabel = 'This Month';
      } else {
        dayLabel = DateFormat('MMMM yyyy').format(conversationDate);
      }

      groups.putIfAbsent(dayLabel, () => []).add(conversation);
    }

    // Sort conversations within each group by updatedAt (newest first)
    groups.forEach((key, value) {
      value.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    });

    // Convert to list and sort groups
    final sortedGroups = groups.entries
        .map((entry) => {
              'day': entry.key,
              'conversations': entry.value,
            })
        .toList();

    sortedGroups.sort((a, b) {
      final dayOrder = ['Today', 'Yesterday', 'This Week', 'This Month'];
      final aIndex = dayOrder.indexOf(a['day'] as String);
      final bIndex = dayOrder.indexOf(b['day'] as String);

      if (aIndex != -1 && bIndex != -1) {
        return aIndex.compareTo(bIndex);
      } else if (aIndex != -1) {
        return -1;
      } else if (bIndex != -1) {
        return 1;
      } else {
        return (a['day'] as String).compareTo(b['day'] as String);
      }
    });

    return sortedGroups;
  }

  String _generateTitle(Conversation conversation) {
    if (conversation.messages.isEmpty) return 'Empty conversation';

    final firstUserMessage = conversation.messages
        .where((m) => m.type == MessageType.user)
        .firstOrNull;

    if (firstUserMessage != null) {
      final content = firstUserMessage.content;
      return content.length > 50 ? '${content.substring(0, 50)}...' : content;
    }

    return 'Conversation';
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(dateTime);
    }
  }

  void _showDeleteConfirmation(Conversation conversation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Conversation'),
        content: Text(
            'Are you sure you want to delete "${conversation.title ?? _generateTitle(conversation)}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(conversationServiceProvider)
                  .deleteConversation(conversation.id);
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.errorRose),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAllConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Conversations'),
        content: const Text(
            'Are you sure you want to delete all conversations? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Delete all conversations
              final conversations =
                  ref.read(userConversationsProvider).value ?? [];
              for (final conversation in conversations) {
                ref
                    .read(conversationServiceProvider)
                    .deleteConversation(conversation.id);
              }
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.errorRose),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }
}
