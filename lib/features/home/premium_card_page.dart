import 'package:flutter/material.dart';

import '../../core/user_session.dart';
import '../../core/premium/premium_config.dart';

class PremiumCardPage extends StatelessWidget {
  final String name;
  final String profession;
  final String city;
  final String district;

  const PremiumCardPage({
    super.key,
    required this.name,
    required this.profession,
    required this.city,
    required this.district,
  });

  Color get _primary => const Color(0xFF00B5E2);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tier = UserSession.instance.tier;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kartvizit & Paketler'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _digitalCard(context, theme, tier),
            const SizedBox(height: 20),
            _packages(context, theme, tier),
          ],
        ),
      ),
    );
  }

  // ---------------------------
  // DİJİTAL KARTVİZİT (V1: yumuşak kilit)
  // ---------------------------
  Widget _digitalCard(BuildContext context, ThemeData theme, UstaTier tier) {
    final hasCard =
    PremiumPolicy.hasFeature(tier, PremiumFeature.digitalBusinessCard);
    final hasQr = PremiumPolicy.hasFeature(tier, PremiumFeature.qrCode);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Dijital Kartvizit',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(width: 10),
                if (!hasCard)
                  _chip('Profesyonel ile açılır', Icons.lock_outline),
                if (hasCard) _chip('Aktif', Icons.verified_outlined),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: _primary.withOpacity(0.12),
                  child: Text(
                    name.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: _primary,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        profession,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$city / $district',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                _qrBox(
                  enabled: hasQr,
                  onTap: () => _showUpsell(context, feature: PremiumFeature.qrCode),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: hasCard
                        ? () => _snack(
                      context,
                      'Kartvizit linki kopyalandı (demo).',
                    )
                        : () => _showUpsell(
                      context,
                      feature: PremiumFeature.digitalBusinessCard,
                    ),
                    icon: Icon(hasCard ? Icons.link : Icons.lock_outline),
                    label: Text(hasCard ? 'Linki Kopyala' : 'Link (Kilitli)'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: hasCard
                        ? () => _snack(
                      context,
                      'Paylaşım seçenekleri açılacak (v1).',
                    )
                        : () => _showUpsell(
                      context,
                      feature: PremiumFeature.digitalBusinessCard,
                    ),
                    icon: Icon(hasCard ? Icons.share : Icons.lock_outline),
                    label: Text(hasCard ? 'Paylaş' : 'Paylaş (Kilitli)'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              hasCard
                  ? 'Kartvizit bağlantın hazır. Müşteri tek tıkla profiline gelsin.'
                  : 'İletişim her zaman ücretsiz. Kartvizit ise güven ve profesyonel görünüm için açılır.',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _qrBox({
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: enabled ? () {} : onTap,
      child: Ink(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          color: enabled ? Colors.transparent : Colors.grey.shade100,
        ),
        child: Icon(
          enabled ? Icons.qr_code_2 : Icons.lock_outline,
          size: 40,
          color: enabled ? null : Colors.grey.shade600,
        ),
      ),
    );
  }

  // ---------------------------
  // PAKETLER (V1: alınabilir demo)
  // ---------------------------
  Widget _packages(BuildContext context, ThemeData theme, UstaTier currentTier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Paketler',
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),

        _packageTile(
          context,
          theme: theme,
          title: 'Standart',
          subtitle: 'Ücretsiz',
          tier: UstaTier.standard,
          currentTier: currentTier,
          features: const [
            'Keşfette görünme',
            'İletişim ücretsiz (WhatsApp/arama)',
            'Öncesi–Sonrası: 3',
          ],
          highlighted: false,
        ),

        _packageTile(
          context,
          theme: theme,
          title: 'Profesyonel',
          subtitle: 'En mantıklı seçenek',
          tier: UstaTier.pro,
          currentTier: currentTier,
          features: const [
            'Dijital kartvizit + QR',
            'Mesaj & tekliflerde daha görünür (dengeleyici)',
            'Öncesi–Sonrası: 8',
            'Daha dengeli öne çıkma',
          ],
          highlighted: true,
        ),

        _packageTile(
          context,
          theme: theme,
          title: 'Vitrin',
          subtitle: 'Prestij paketi',
          tier: UstaTier.vitrin,
          currentTier: currentTier,
          features: const [
            'Vitrin rozet + vurgu tasarımı',
            'Mesaj & tekliflerde daha görünür (dengeleyici)',
            'Öncesi–Sonrası: sınırsız',
            'Daha güçlü görünürlük',
          ],
          highlighted: true,
        ),

        const SizedBox(height: 6),
        Text(
          'Not: İletişim her pakette ücretsizdir. Paketler sadece görünürlük ve güven avantajı sağlar.',
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
        ),
      ],
    );
  }

  Widget _packageTile(
      BuildContext context, {
        required ThemeData theme,
        required String title,
        required String subtitle,
        required List<String> features,
        required bool highlighted,
        required UstaTier tier,
        required UstaTier currentTier,
      }) {
    final selected = currentTier == tier;

    return Card(
      elevation: highlighted ? 2 : 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                if (selected)
                  _chip('Aktif', Icons.check_circle)
                else
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: highlighted ? _primary : Colors.grey[600],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            ...features.map(
                  (f) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: highlighted ? _primary : Colors.grey.shade500,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        f,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: selected
                    ? null
                    : () {
                  // V1 DEMO: paketi aktif et
                  UserSession.instance.tier = tier;

                  _snack(
                    context,
                    '$title paketi aktif edildi (demo).',
                  );

                  // sayfayı güncellemek için en basit yöntem:
                  // geri çıkıp tekrar girince güncellenir.
                  // İstersen sonraki adımda bunu Stateful + setState yaparız.
                  Navigator.of(context).pop();
                },
                child: Text(selected ? 'Aktif Paket' : 'Bu Paketi Seç (Demo)'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: _primary),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: _primary,
            ),
          ),
        ],
      ),
    );
  }

  void _snack(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showUpsell(BuildContext context, {required PremiumFeature feature}) {
    final title = _featureTitle(feature);
    final body = _featureBody(feature);

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  body,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Vazgeç'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _snack(context, 'Paketlerden “Profesyonel” seçerek açabilirsin.');
                        },
                        child: const Text('Anladım'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _featureTitle(PremiumFeature f) {
    switch (f) {
      case PremiumFeature.digitalBusinessCard:
        return 'Dijital Kartvizit';
      case PremiumFeature.qrCode:
        return 'QR Kod';
      case PremiumFeature.professionalBadge:
        return 'Profesyonel Rozet';
      case PremiumFeature.showcaseBadge:
        return 'Vitrin Rozeti';
      case PremiumFeature.sponsorBadge:
        return 'Sponsor Rozeti';
      case PremiumFeature.showcaseHighlight:
        return 'Vitrin Vurgusu';
      case PremiumFeature.priorityListing:
        return 'Daha Dengeli Öne Çıkma';
      case PremiumFeature.beforeAfterLimit:
        return 'Öncesi–Sonrası Limiti';
      case PremiumFeature.videoUpload:
        return 'Video Yükleme (V2)';
      case PremiumFeature.inboxPriority:
        return 'Mesajlarda Daha Görünür';
      case PremiumFeature.offerPriority:
        return 'Tekliflerde Daha Görünür';
    }
  }

  String _featureBody(PremiumFeature f) {
    switch (f) {
      case PremiumFeature.digitalBusinessCard:
        return 'Kartvizit linkini paylaşarak daha profesyonel görün. Müşteri tek tıkla profiline gelsin.';
      case PremiumFeature.qrCode:
        return 'QR kod ile kartvizitini hızlıca paylaş. Tek taramayla profilin açılır.';
      case PremiumFeature.inboxPriority:
        return 'Mesajlarda görünürlük artar; iletişim yine ücretsizdir. Ama dönüş alma hızın yükselir.';
      case PremiumFeature.offerPriority:
        return 'Teklif listelerinde adil sıralama korunur; premium sadece eşit durumlarda küçük avantaj sağlar.';
      case PremiumFeature.videoUpload:
        return 'Video yükleme V2’de açılacak. Şimdiden altyapısı hazır olacak.';
      default:
        return 'Bu özellik daha profesyonel görünüm ve güven için premium paketlerde açılır.';
    }
  }
}
