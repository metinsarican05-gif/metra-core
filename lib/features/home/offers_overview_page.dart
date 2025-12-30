// lib/features/home/offers_overview_page.dart
import 'package:flutter/material.dart';

import '../../core/user_session.dart';
import '../../core/premium/premium_config.dart';
import 'offers_received_page.dart';
import 'offers_sent_page.dart';

class OffersOverviewPage extends StatelessWidget {
  const OffersOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tier = UserSession.instance.tier;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const OffersReceivedPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.inbox_outlined),
              label: const Text(
                'Gelen Teklifler',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const OffersSentPage(),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.send_outlined),
              label: const Text(
                'Verdiğim Teklifler',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          const SizedBox(height: 18),

          // ✅ Yumuşak premium mesajı (Armut gibi değil)
          _softInfoCard(context, tier),
        ],
      ),
    );
  }

  Widget _softInfoCard(BuildContext context, UstaTier tier) {
    final theme = Theme.of(context);

    final isProOrAbove = tier == UstaTier.pro || tier == UstaTier.vitrin || tier == UstaTier.sponsor;

    final title = isProOrAbove
        ? 'Paket Avantajın Aktif'
        : 'Daha Hızlı Dönüş İçin';

    final body = isProOrAbove
        ? 'Teklif ve mesaj görünürlüğünde dengeleyici avantajın var. Sistem yine lokasyon ve puanı esas alır.'
        : 'İletişim herkes için ücretsiz. Profesyonel paket, teklif ve mesajlarda küçük ama etkili bir görünürlük avantajı sağlar.';

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isProOrAbove ? Icons.verified_outlined : Icons.info_outline,
              size: 22,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    body,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[700],
                      height: 1.25,
                    ),
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
