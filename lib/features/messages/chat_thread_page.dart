// ===============================
// lib/features/messages/chat_thread_page.dart
// ===============================
import 'package:flutter/material.dart';

import '../../core/user_session.dart';
import 'message_models.dart';

class ChatThreadPage extends StatefulWidget {
  final String conversationId;
  final String otherUserName;

  const ChatThreadPage({
    super.key,
    required this.conversationId,
    required this.otherUserName,
  });

  @override
  State<ChatThreadPage> createState() => _ChatThreadPageState();
}

class _ChatThreadPageState extends State<ChatThreadPage> {
  final _controller = TextEditingController();

  late List<ChatMessage> _messages;

  @override
  void initState() {
    super.initState();

    // DEMO mesajlar
    _messages = [
      ChatMessage(
        id: 'm1',
        conversationId: widget.conversationId,
        fromUserId: 'cust',
        text: 'Merhaba usta, müsait misiniz?',
        createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
      ),
      ChatMessage(
        id: 'm2',
        conversationId: widget.conversationId,
        fromUserId: 'me',
        text: 'Merhaba, müsaitim. Detayı yazabilirsiniz.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 42)),
      ),
    ];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          conversationId: widget.conversationId,
          fromUserId: 'me',
          text: text,
          createdAt: DateTime.now(),
        ),
      );
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final meName = UserSession.instance.name ?? 'Ben';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.otherUserName),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                final m = _messages[i];
                final isMe = m.fromUserId == 'me';

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 320),
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: isMe
                          ? theme.colorScheme.primary.withOpacity(0.12)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isMe ? theme.colorScheme.primary.withOpacity(0.20) : Colors.grey.shade300,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isMe ? meName : widget.otherUserName,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(m.text),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Mesaj yaz…',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  FilledButton(
                    onPressed: _send,
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}