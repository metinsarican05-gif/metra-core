// ===============================
// lib/features/messages/message_models.dart
// ===============================
class ConversationItem {
  final String id;
  final String otherUserId;
  final String otherUserName;
  final String lastMessage;
  final DateTime lastMessageAt;
  final int unreadCount;

  // Backend gelince burası karşı tarafın tier'ı olacak.
  // Şimdilik demo: true/false
  final bool otherPartyIsPremiumDemo;

  const ConversationItem({
    required this.id,
    required this.otherUserId,
    required this.otherUserName,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.unreadCount,
    required this.otherPartyIsPremiumDemo,
  });
}

class ChatMessage {
  final String id;
  final String conversationId;
  final String fromUserId;
  final String text;
  final DateTime createdAt;

  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.fromUserId,
    required this.text,
    required this.createdAt,
  });
}


