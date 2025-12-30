// lib/features/messages/messages_inbox_page.dart
import 'package:flutter/material.dart';

import '../../core/user_session.dart';
import '../../core/premium/premium_config.dart';

class MessagesInboxPage extends StatelessWidget {
  final bool fromOffer;
  final String? jobTitle;
  final String? professionalName;

  const MessagesInboxPage({
    super.key,
    this.fromOffer = false,
    this.jobTitle,
    this.professionalName,
  });

  int _priorityScore({
    required bool unread,
    required bool isPriority,
  }) {
    if (unread && isPriority) return 0;
    if (unread) return 1;
    if (isPriority) return 2;
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Not: Projende UserSession.instance.tier varsa bunu kullanıyoruz.
    // Yoksa IDE "tier yok" diye hata verir (o durumda bana söyle).
    final tier = UserSession.instance.tier;

    final isProOrAbove =
        tier == UstaTier.pro || tier == UstaTier.vitrin || tier == UstaTier.sponsor;

    final List<_ChatItem> chats = [
      if (fromOffer)
        _ChatItem(
          name: professionalName ?? 'Teklif Veren',
          lastMessage: '${jobTitle ?? "İlan"} için mesajlaşma başlatıldı.',
          unread: true,
          isPriority: isProOrAbove,
          time: DateTime.now(),
          fromOffer: true,
        ),
      _ChatItem(
        name: 'Ahmet Yılmaz',
        lastMessage: 'Yarın gelip bakabilir misiniz?',
        unread: true,
        isPriority: isProOrAbove,
        time: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
      _ChatItem(
        name: 'Seda Dekorasyon',
        lastMessage: 'Fiyat teklifinizi aldım.',
        unread: false,
        isPriority: false,
        time: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ];

    // ✅ Akıllı sıralama
    chats.sort((a, b) {
      final scoreA = _priorityScore(unread: a.unread, isPriority: a.isPriority);
      final scoreB = _priorityScore(unread: b.unread, isPriority: b.isPriority);

      if (scoreA != scoreB) return scoreA.compareTo(scoreB);
      return b.time.compareTo(a.time);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mesajlar'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (fromOffer) _offerInfoCard(context),
          const SizedBox(height: 8),
          ...chats.map((c) => _chatTile(context, c)),
        ],
      ),
    );
  }

  Widget _offerInfoCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.assignment_turned_in_outlined),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${jobTitle ?? "İlan"} için ${professionalName ?? "usta"} ile mesajlaşma başlatıldı.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chatTile(BuildContext context, _ChatItem chat) {
    final theme = Theme.of(context);

    final highlight = chat.fromOffer ? theme.colorScheme.primary.withOpacity(0.04) : null;

    return Card(
      color: highlight,
      elevation: chat.unread ? 3 : 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
          child: chat.fromOffer
              ? Icon(Icons.assignment_turned_in_outlined,
              size: 18, color: theme.colorScheme.primary)
              : Text(
            chat.name.substring(0, 1),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                chat.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            if (chat.fromOffer) _badge(theme, 'Tekliften'),
            if (!chat.fromOffer && chat.isPriority) _badge(theme, 'Öncelikli'),
          ],
        ),
        subtitle: Text(
          chat.lastMessage,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: chat.unread
            ? Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
          ),
        )
            : null,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sohbet ekranı V2’de eklenecek.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  Widget _badge(ThemeData theme, String text) {
    return Container(
      margin: const EdgeInsets.only(left: 6),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

class _ChatItem {
  final String name;
  final String lastMessage;
  final bool unread;
  final bool isPriority;
  final DateTime time;
  final bool fromOffer;

  _ChatItem({
    required this.name,
    required this.lastMessage,
    required this.unread,
    required this.isPriority,
    required this.time,
    this.fromOffer = false,
  });
}
