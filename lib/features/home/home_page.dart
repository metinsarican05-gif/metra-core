// lib/features/home/home_page.dart
import 'package:flutter/material.dart';

import '../messages/messages_inbox_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // 🔹 Demo okunmamış mesaj sayısı (ileride backend’den gelecek)
  final int unreadMessageCount = 2;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nexira'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Merhaba Metin 👋',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Burada yakınındaki ilanları, profesyonelleri ve iş paylaşımlarını göreceksin.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: [
                  _NexiraCard(
                    title: 'İlanlar',
                    subtitle: 'Müşterilerin açtığı iş ilanlarını keşfet',
                    icon: Icons.assignment_outlined,
                    onTap: () {},
                  ),
                  _NexiraCard(
                    title: 'Profesyoneller',
                    subtitle: 'Ustaları ve diğer meslek sahiplerini incele',
                    icon: Icons.people_outline,
                    onTap: () {},
                  ),
                  _NexiraCard(
                    title: 'Akış',
                    subtitle: 'Öncesi / sonrası iş fotoğraflarına göz at',
                    icon: Icons.photo_library_outlined,
                    onTap: () {},
                  ),

                  // ✅ MESAJLAR + BADGE
                  _NexiraCard(
                    title: 'Mesajlar',
                    subtitle: 'Müşterilerle ve ustalarla yazışmalar',
                    icon: Icons.message_outlined,
                    badgeCount: unreadMessageCount,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MessagesInboxPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NexiraCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final int? badgeCount;

  const _NexiraCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: ListTile(
        leading: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(icon, size: 32),
            if (badgeCount != null && badgeCount! > 0)
              Positioned(
                right: -6,
                top: -6,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badgeCount!.toString(),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
