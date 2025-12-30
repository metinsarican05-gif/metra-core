import 'package:flutter/material.dart';
import 'portfolio_full_page.dart';

class PortfolioItem {
  final String title;
  final String subtitle;
  final String badgeText;

  const PortfolioItem({
    required this.title,
    required this.subtitle,
    required this.badgeText,
  });
}

class ProfessionalPortfolioSection extends StatelessWidget {
  const ProfessionalPortfolioSection({super.key});

  Color get _primary => const Color(0xFF00B5E2);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const works = [
      PortfolioItem(
        title: 'Banyo yenileme',
        subtitle: 'Dörtyol • 2 günde teslim',
        badgeText: 'Görsel / Öncesi-Sonrası',
      ),
      PortfolioItem(
        title: 'Isı yalıtım projesi',
        subtitle: 'Apartman dış cephe mantolama',
        badgeText: 'Görsel / Öncesi-Sonrası',
      ),
    ];

    const beforeAfter = [
      PortfolioItem(
        title: 'Mutfak dönüşümü',
        subtitle: 'Eski dolaplardan modern mutfağa',
        badgeText: 'Öncesi / Sonrası',
      ),
      PortfolioItem(
        title: 'Salon dekorasyon',
        subtitle: 'Boyadan aydınlatmaya komple yenileme',
        badgeText: 'Öncesi / Sonrası',
      ),
    ];

    const jobs = [
      PortfolioItem(
        title: 'Anahtar teslim daire tadilatı',
        subtitle: 'Bütçe: 120.000 ₺ • Teslim: 30 gün',
        badgeText: 'İlan',
      ),
      PortfolioItem(
        title: 'Banyo + Mutfak yenileme',
        subtitle: 'Dörtyol ve çevresi',
        badgeText: 'İlan',
      ),
    ];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
        child: DefaultTabController(
          length: 3,
          child: Builder(
            builder: (context) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Başlık + "Tümünü Gör" aynı satır (daha temiz)
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Portföy ve Vitrin',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          final tabController = DefaultTabController.of(context);
                          final currentIndex = tabController.index;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PortfolioFullPage(
                                initialIndex: currentIndex,
                              ),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: _primary,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Tümünü Gör',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tamamladığın projeler, örnek çalışmalar ve ilanların burada görünecek.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[700],
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 3 sekme zaten sığıyor → scroll kapalı (kırpılma biter)
                  TabBar(
                    isScrollable: false,
                    labelColor: _primary,
                    unselectedLabelColor: Colors.black87,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorColor: _primary,
                    indicatorWeight: 2.5,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                    tabs: const [
                      Tab(text: 'Çalışmalarım'),
                      Tab(text: 'Öncesi / Sonrası'),
                      Tab(text: 'İlanlarım'),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Sabit 210 yerine daha stabil bir yükseklik (kart + padding dengesi)
                  SizedBox(
                    height: 200,
                    child: TabBarView(
                      children: [
                        _buildListView(context, works),
                        _buildListView(context, beforeAfter),
                        _buildListView(context, jobs),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Alt aksiyon daha düzenli
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Portföye yeni çalışma ekleme akışı daha sonra eklenecek.',
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 18,
                        color: _primary,
                      ),
                      label: Text(
                        'Portföye çalışma ekle',
                        style: TextStyle(
                          color: _primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  static Widget _buildListView(BuildContext context, List<PortfolioItem> items) {
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

    final screenW = MediaQuery.of(context).size.width;

    // Kart genişliği: küçük ekranda yarım kart hissini azalt
    // 360px → ~240, 420px → ~270 gibi düşünebilirsin
    final cardW = (screenW * 0.66).clamp(220.0, 280.0);

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 2),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(width: 10),
      itemBuilder: (context, index) {
        final item = items[index];

        return SizedBox(
          width: cardW,
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Görsel alanı
                Container(
                  height: 108,
                  color: Colors.grey[200],
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    item.badgeText,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[700],
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
