// lib/features/auth/role_selection_page.dart
import 'package:flutter/material.dart';
import '../home/master_home_page.dart';
import '../home/customer_home_page.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // BAŞLIK – METRA
              Text(
                'METRA’ya Hoş Geldin',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // ALT AÇIKLAMA – METRA
              Text(
                'METRA’da ne yapmak istiyorsun?',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 32),

              // Profesyonel / Usta kartı
              _RoleCard(
                icon: Icons.handyman_outlined,
                title: 'Profesyonelim / Ustayım',
                description:
                'İşimi tanıtmak, iş almak ve yaptığım işleri paylaşmak istiyorum.',
                color: colorScheme.primary,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MasterHomePage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Hizmet arayan kartı
              _RoleCard(
                icon: Icons.search_outlined,
                title: 'Hizmet arıyorum',
                description:
                'İlan açmak, teklif almak ve en uygun uzmanı bulmak istiyorum.',
                color: colorScheme.secondary,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CustomerHomePage(),
                    ),
                  );
                },
              ),

              const Spacer(),

              // Küçük alt not
              Text(
                'Seçtiğin rol başlangıç içindir. Hesap ayarlarından rolünü daha sonra da değiştirebileceksin (ileride).',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: color,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
