// lib/features/home/home_page.dart
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                children: const [
                  _NexiraCard(
                    title: 'İlanlar',
                    subtitle: 'Müşterilerin açtığı iş ilanlarını keşfet',
                    icon: Icons.assignment_outlined,
                  ),
                  _NexiraCard(
                    title: 'Profesyoneller',
                    subtitle: 'Ustaları ve diğer meslek sahiplerini incele',
                    icon: Icons.people_outline,
                  ),
                  _NexiraCard(
                    title: 'Akış',
                    subtitle: 'Öncesi / sonrası iş fotoğraflarına göz at',
                    icon: Icons.photo_library_outlined,
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

  const _NexiraCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // ADIM 2'de buradan ilan / profesyonel / akış sayfalarına gideceğiz.
        },
      ),
    );
  }
}
