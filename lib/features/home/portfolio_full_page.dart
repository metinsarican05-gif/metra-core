import 'package:flutter/material.dart';

/// Portföy ve Vitrin için tam ekran sayfa.
/// Burada 3 sekmenin (Çalışmalarım / Öncesi Sonrası / İlanlarım)
/// dikey liste (vertical) hâlini gösteriyoruz.
class PortfolioFullPage extends StatelessWidget {
  final int initialIndex;

  const PortfolioFullPage({
    super.key,
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    // Gelen index 0-2 dışında ise 0'a çek
    final safeIndex = (initialIndex < 0 || initialIndex > 2) ? 0 : initialIndex;

    // Demo veriler (şimdilik buraya kopyaladık; ileride backend’den gelir)
    final List<_FullPortfolioItem> works = const [
      _FullPortfolioItem(
        title: 'Banyo yenileme',
        subtitle: 'Dörtyol • 2 günde teslim',
        description:
        'Eski banyonun komple seramik, tesisat ve duş alanını yeniledim.',
        badgeText: 'Çalışma',
      ),
      _FullPortfolioItem(
        title: 'Isı yalıtım projesi',
        subtitle: 'Apartman dış cephe mantolama',
        description:
        'Dış cephe mantolama ile ısı kaybını ciddi oranda azalttık.',
        badgeText: 'Çalışma',
      ),
    ];

    final List<_FullPortfolioItem> beforeAfter = const [
      _FullPortfolioItem(
        title: 'Mutfak dönüşümü',
        subtitle: 'Eski dolaplardan modern mutfağa',
        description:
        'Öncesi / sonrası görselleri ile mutfağın komple değişimini gösterdim.',
        badgeText: 'Öncesi / Sonrası',
      ),
      _FullPortfolioItem(
        title: 'Salon dekorasyon',
        subtitle: 'Boyadan aydınlatmaya komple yenileme',
        description:
        'Ofis ve salon için renk, aydınlatma ve dekorasyon değişimi.',
        badgeText: 'Öncesi / Sonrası',
      ),
    ];

    final List<_FullPortfolioItem> jobs = const [
      _FullPortfolioItem(
        title: 'Anahtar teslim daire tadilatı',
        subtitle: 'Bütçe: 120.000 ₺ • Teslim: 30 gün',
        description:
        'Mutfak, banyo, parke, boya ve kapı değişimi dahil komple iç tadilat.',
        badgeText: 'İlan',
      ),
      _FullPortfolioItem(
        title: 'Banyo + Mutfak yenileme',
        subtitle: 'Dörtyol ve çevresi',
        description:
        'Banyo ve mutfak için seramik, dolap, tezgâh ve tesisat yenileme işleri.',
        badgeText: 'İlan',
      ),
    ];

    return DefaultTabController(
      length: 3,
      initialIndex: safeIndex,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Portföy ve Vitrin'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Çalışmalarım'),
              Tab(text: 'Öncesi / Sonrası'),
              Tab(text: 'İlanlarım'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildVerticalList(context, works),
            _buildVerticalList(context, beforeAfter),
            _buildVerticalList(context, jobs),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalList(
      BuildContext context,
      List<_FullPortfolioItem> items,
      ) {
    final theme = Theme.of(context);

    if (items.isEmpty) {
      return Center(
        child: Text(
          'Henüz içerik eklenmemiş.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Şimdilik placeholder görsel alanı
              Container(
                height: 160,
                width: double.infinity,
                color: Colors.grey[200],
                alignment: Alignment.center,
                child: Text(
                  item.badgeText,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.description,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Bu sayfaya özel basit model
class _FullPortfolioItem {
  final String title;
  final String subtitle;
  final String description;
  final String badgeText;

  const _FullPortfolioItem({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.badgeText,
  });
}
