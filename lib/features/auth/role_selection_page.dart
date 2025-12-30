// lib/features/auth/role_selection_page.dart
import 'package:flutter/material.dart';
import '../../core/user_session.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  void _goRegister(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/register');
  }

  Future<void> _selectProfessionalType(BuildContext context) async {
    final theme = Theme.of(context);

    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Profesyonel hesabını seç',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Bu seçim “firma keşfeti” ve adil sıralama mimarisinin temelidir.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                _TypeTile(
                  icon: Icons.person_outline,
                  title: 'Bireysel çalışıyorum',
                  subtitle: 'Tek başıma hizmet veriyorum.',
                  onTap: () => Navigator.pop(ctx, 'individual'),
                ),
                const SizedBox(height: 10),

                _TypeTile(
                  icon: Icons.badge_outlined,
                  title: 'Şahıs şirketim var',
                  subtitle: 'Küçük işletme / fatura kesebilirim.',
                  onTap: () => Navigator.pop(ctx, 'sole'),
                ),
                const SizedBox(height: 10),

                _TypeTile(
                  icon: Icons.apartment_outlined,
                  title: 'Firmayım (LTD/A.Ş.)',
                  subtitle: 'Ekip + proje; birden çok hizmet olabilir.',
                  onTap: () => Navigator.pop(ctx, 'company'),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selected == null) return;

    // ✅ Session’a yaz
    final s = UserSession.instance;
    s.role = 'professional';
    s.professionalType = selected;

    // ✅ Kayıt sayfasına devam
    _goRegister(context);
  }

  void _selectCustomer(BuildContext context) {
    final s = UserSession.instance;
    s.role = 'customer';
    s.professionalType = null;

    _goRegister(context);
  }

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

              Text(
                'METRA’ya Hoş Geldin',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                'METRA’da ne yapmak istiyorsun?',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 32),

              _RoleCard(
                icon: Icons.handyman_outlined,
                title: 'Hizmet Veriyorum (Profesyonelim)',
                description:
                'İşimi tanıtmak, iş almak ve yaptığım işleri paylaşmak istiyorum.',
                color: colorScheme.primary,
                onTap: () => _selectProfessionalType(context),
              ),
              const SizedBox(height: 16),

              _RoleCard(
                icon: Icons.search_outlined,
                title: 'Hizmet Arıyorum (Müşteriyim)',
                description:
                'İlan açmak, teklif almak ve en uygun uzmanı bulmak istiyorum.',
                color: colorScheme.secondary,
                onTap: () => _selectCustomer(context),
              ),

              const Spacer(),

              Text(
                'Not: Bu seçim başlangıç içindir. İleride hesap ayarlarından rol değişimi eklenebilir.',
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

class _TypeTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _TypeTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: theme.colorScheme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
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
                  color: color.withOpacity(0.10),
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
                        fontWeight: FontWeight.w700,
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
              const Icon(Icons.chevron_right, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
