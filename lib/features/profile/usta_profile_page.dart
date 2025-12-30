import 'package:flutter/material.dart';
import 'package:nexira/core/premium/premium_config.dart';
import 'package:nexira/features/explore/presentation/explore_page.dart'; // UstaExploreItem için

class UstaProfilePage extends StatelessWidget {
  const UstaProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // ExplorePage’den arguments olarak UstaExploreItem gönderiyoruz
    final args = ModalRoute.of(context)?.settings.arguments;

    // Güvenlik: args null/yanlış gelirse çökmesin
    final UstaExploreItem? usta =
    args is UstaExploreItem ? args : null;

    final theme = Theme.of(context);

    if (usta == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profil')),
        body: Center(
          child: Text(
            'Profil verisi bulunamadı (V1).',
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }

    // Tier konfigürasyonu (mevcut premium_config yapınla uyumlu)
    final cfg = UstaTierConfig.of(context, usta.tier);
    final isDark = cfg.darkCard;

    final primaryText = isDark ? Colors.white : Colors.black87;
    final secondaryText = isDark ? Colors.white70 : (Colors.grey[700] ?? Colors.black54);
    final accent = cfg.borderColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Usta / Profesyonel Profili'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Üst kart (kimlik)
            Container(
              decoration: BoxDecoration(
                color: cfg.backgroundColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cfg.borderColor, width: 1.6),
                boxShadow: cfg.highlightCard
                    ? [
                  BoxShadow(
                    color: cfg.borderColor.withOpacity(0.14),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                ]
                    : null,
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // İsim + rozet
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          usta.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: primaryText,
                          ),
                        ),
                      ),
                      if (cfg.name != 'Standart')
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: cfg.badgeColor,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: (cfg.badgeTextColor ?? Colors.white).withOpacity(0.18),
                            ),
                          ),
                          child: Text(
                            cfg.name,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: cfg.badgeTextColor ?? Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(
                    usta.jobTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: secondaryText,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Puan + konum
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
                      const SizedBox(width: 6),
                      Text(
                        '${usta.rating.toStringAsFixed(1)} (${usta.ratingCount})',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: primaryText,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Icon(Icons.place_outlined, size: 18, color: secondaryText),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${usta.locationText} • ${usta.distanceText}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: secondaryText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Aksiyonlar (Takip / Mesaj)
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Takip (V1 demo)')),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: accent.withOpacity(0.85), width: 1.2),
                        foregroundColor: accent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.person_add_alt_1_outlined, size: 18),
                      label: const Text(
                        'Takip Et',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Mesaj (V1 demo)')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accent.withOpacity(0.14),
                        foregroundColor: accent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(color: accent.withOpacity(0.40)),
                        ),
                      ),
                      icon: const Icon(Icons.chat_bubble_outline, size: 18),
                      label: const Text(
                        'Mesaj',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Öncesi/Sonrası placeholder
            Text(
              'Öncesi / Sonrası',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black12),
                color: Colors.grey[50],
              ),
              child: const Text(
                'V1: Burada öncesi/sonrası iş görselleri listelenecek.\n'
                    'V1.1: Firebase ile gerçek data bağlanacak.',
              ),
            ),

            const SizedBox(height: 14),

            // Hakkında placeholder
            Text(
              'Hakkında',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black12),
                color: Colors.grey[50],
              ),
              child: Text(
                'V1: ${usta.name} profili demo olarak gösteriliyor.\n'
                    'V1.1: Hakkında metni, hizmet bölgeleri, deneyim, web sitesi gibi alanlar eklenecek.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
