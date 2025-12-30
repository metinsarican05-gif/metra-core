import 'package:flutter/material.dart';
import 'package:nexira/core/premium/premium_config.dart';

/// ✅ Firma keşfeti için V1 model
/// (UstaExploreItem gibi widget değil, veri modeli)
class CompanyExploreItem {
  final String id;
  final String companyName;
  final String category; // "İnşaat", "Dekorasyon", "Elektrik"...
  final String serviceTitle; // "Anahtar Teslim Tadilat" gibi
  final double rating;
  final int ratingCount;
  final String locationText;
  final String distanceText; // "3 km"
  final UstaTier tier; // standard/pro/vitrin/sponsor
  final bool hasInvoice; // fatura kesebilir mi? (şahıs/firma)

  const CompanyExploreItem({
    required this.id,
    required this.companyName,
    required this.category,
    required this.serviceTitle,
    required this.rating,
    required this.ratingCount,
    required this.locationText,
    required this.distanceText,
    required this.tier,
    required this.hasInvoice,
  });

  double? get distanceKm {
    final parts = distanceText.trim().split(' ');
    if (parts.isEmpty) return null;
    return double.tryParse(parts.first.replaceAll(',', '.'));
  }
}

/// ✅ Bölüm (section): Örn "İnşaat Firmaları"
class CompanySection {
  final String category;
  final int demandScore; // Bölgedeki talep/arama yoğunluğu: büyükse yukarıda
  final List<CompanyExploreItem> items;

  const CompanySection({
    required this.category,
    required this.demandScore,
    required this.items,
  });
}

/// Filtreler (firma keşfeti)
enum CompanyExploreFilter {
  nearby,       // yakınımda
  topRated,     // puanı yüksek
  premiumOnly,  // pro/vitrin/sponsor
  invoiceOnly,  // fatura kesenler
}

class CompanyExplorePage extends StatefulWidget {
  const CompanyExplorePage({super.key});

  @override
  State<CompanyExplorePage> createState() => _CompanyExplorePageState();
}

class _CompanyExplorePageState extends State<CompanyExplorePage> {
  final List<CompanyExploreFilter> activeFilters = [];
  String searchQuery = '';

  late final List<CompanyExploreItem> _allCompanies;

  @override
  void initState() {
    super.initState();

    // ✅ Demo veri (V1)
    _allCompanies = const [
      CompanyExploreItem(
        id: 'c1',
        companyName: 'Altın Eller İnşaat',
        category: 'İnşaat',
        serviceTitle: 'Anahtar Teslim Tadilat',
        rating: 4.8,
        ratingCount: 93,
        locationText: 'İskenderun',
        distanceText: '10 km',
        tier: UstaTier.vitrin,
        hasInvoice: true,
      ),
      CompanyExploreItem(
        id: 'c2',
        companyName: 'Sarıcan Yapı & Dekorasyon',
        category: 'Dekorasyon',
        serviceTitle: 'Seramik & Banyo Yenileme',
        rating: 4.9,
        ratingCount: 128,
        locationText: 'Dörtyol',
        distanceText: '3 km',
        tier: UstaTier.pro,
        hasInvoice: true,
      ),
      CompanyExploreItem(
        id: 'c3',
        companyName: 'Lüks Dekor Metal',
        category: 'Dekorasyon',
        serviceTitle: 'Ferforje & Korkuluk',
        rating: 4.6,
        ratingCount: 52,
        locationText: 'İskenderun',
        distanceText: '4 km',
        tier: UstaTier.sponsor,
        hasInvoice: true,
      ),
      CompanyExploreItem(
        id: 'c4',
        companyName: 'Hızlı Elektrik Ltd.',
        category: 'Elektrik',
        serviceTitle: 'Elektrik Tesisatı & Arıza',
        rating: 4.7,
        ratingCount: 64,
        locationText: 'Payas',
        distanceText: '7 km',
        tier: UstaTier.standard,
        hasInvoice: true,
      ),
      CompanyExploreItem(
        id: 'c5',
        companyName: 'Usta Mehmet (Şahıs)',
        category: 'Elektrik',
        serviceTitle: 'Elektrik Tesisatı',
        rating: 4.5,
        ratingCount: 18,
        locationText: 'Dörtyol',
        distanceText: '2 km',
        tier: UstaTier.pro,
        hasInvoice: true,
      ),
    ];
  }

  void toggleFilter(CompanyExploreFilter filter) {
    setState(() {
      if (activeFilters.contains(filter)) {
        activeFilters.remove(filter);
      } else {
        activeFilters.add(filter);
      }
    });
  }

  List<CompanyExploreItem> _applyItemFilters(List<CompanyExploreItem> list) {
    var filtered = List<CompanyExploreItem>.from(list);

    // Yakınımda: < 5 km
    if (activeFilters.contains(CompanyExploreFilter.nearby)) {
      filtered = filtered.where((c) {
        final km = c.distanceKm;
        if (km == null) return true;
        return km < 5.0;
      }).toList();
    }

    // Top rated: >= 4.5
    if (activeFilters.contains(CompanyExploreFilter.topRated)) {
      filtered = filtered.where((c) => c.rating >= 4.5).toList();
    }

    // Premium only
    if (activeFilters.contains(CompanyExploreFilter.premiumOnly)) {
      filtered = filtered.where((c) =>
      c.tier == UstaTier.pro ||
          c.tier == UstaTier.vitrin ||
          c.tier == UstaTier.sponsor).toList();
    }

    // Invoice only
    if (activeFilters.contains(CompanyExploreFilter.invoiceOnly)) {
      filtered = filtered.where((c) => c.hasInvoice).toList();
    }

    // Search
    final q = searchQuery.trim().toLowerCase();
    if (q.isNotEmpty) {
      filtered = filtered.where((c) {
        final fields = [
          c.companyName,
          c.category,
          c.serviceTitle,
          c.locationText,
        ].join(' ').toLowerCase();
        return fields.contains(q);
      }).toList();
    }

    // Sıralama: tier > rating > distance
    filtered.sort((a, b) {
      int tierScore(UstaTier t) {
        switch (t) {
          case UstaTier.sponsor:
            return 3;
          case UstaTier.vitrin:
            return 2;
          case UstaTier.pro:
            return 1;
          case UstaTier.standard:
          default:
            return 0;
        }
      }

      final t = tierScore(b.tier).compareTo(tierScore(a.tier));
      if (t != 0) return t;

      final r = b.rating.compareTo(a.rating);
      if (r != 0) return r;

      final ak = a.distanceKm ?? 9999;
      final bk = b.distanceKm ?? 9999;
      return ak.compareTo(bk);
    });

    return filtered;
  }

  /// ✅ Bölümlere ayır (category section)
  List<CompanySection> _buildSections(List<CompanyExploreItem> items) {
    // V1 DEMO: demandScore (talep) sabit map (V1.1’de analytics/arama verisiyle beslenecek)
    const demandByCategory = {
      'İnşaat': 95,
      'Dekorasyon': 88,
      'Elektrik': 76,
      'Tesisat': 70,
    };

    final Map<String, List<CompanyExploreItem>> grouped = {};
    for (final c in items) {
      grouped.putIfAbsent(c.category, () => []);
      grouped[c.category]!.add(c);
    }

    final sections = grouped.entries.map((e) {
      final demand = demandByCategory[e.key] ?? 50;
      return CompanySection(category: e.key, demandScore: demand, items: e.value);
    }).toList();

    // Bölüm sırası: demandScore yüksek olan üstte
    sections.sort((a, b) => b.demandScore.compareTo(a.demandScore));

    return sections;
  }

  Widget _buildFilterChip({
    required String label,
    required CompanyExploreFilter filter,
  }) {
    final isSelected = activeFilters.contains(filter);
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => toggleFilter(filter),
        showCheckmark: false,
        selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.12),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.shade400,
        ),
        labelStyle: TextStyle(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final filteredItems = _applyItemFilters(_allCompanies);
    final sections = _buildSections(filteredItems);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Firma Keşfeti'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Arama
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Firma, kategori, hizmet, şehir ara...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(999),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              ),
              onChanged: (v) => setState(() => searchQuery = v),
            ),
          ),

          // Açıklama
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kategorilere göre firmalar',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Bölüm sırası; bölgede en çok aranan kategoriye göre yükselir. İçte adil sıralama tier/puan/mesafe ile yapılır.',
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Filtreler
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                _buildFilterChip(label: 'Yakınımda', filter: CompanyExploreFilter.nearby),
                _buildFilterChip(label: 'En yüksek puan', filter: CompanyExploreFilter.topRated),
                _buildFilterChip(label: 'Premium', filter: CompanyExploreFilter.premiumOnly),
                _buildFilterChip(label: 'Faturalı', filter: CompanyExploreFilter.invoiceOnly),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: sections.isEmpty
                ? Center(
              child: Text(
                'Filtrelere uygun firma bulunamadı.',
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
              itemCount: sections.length,
              itemBuilder: (context, index) {
                final s = sections[index];
                return _CompanySectionWidget(section: s);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CompanySectionWidget extends StatelessWidget {
  final CompanySection section;

  const _CompanySectionWidget({required this.section});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Expanded(
                child: Text(
                  '${section.category} Firmaları',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: theme.colorScheme.primary.withOpacity(0.10),
                ),
                child: Text(
                  'Talep: ${section.demandScore}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Section list
          Column(
            children: section.items.map((c) => _CompanyCard(item: c)).toList(),
          ),
        ],
      ),
    );
  }
}

class _CompanyCard extends StatelessWidget {
  final CompanyExploreItem item;

  const _CompanyCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String tierLabel(UstaTier t) {
      switch (t) {
        case UstaTier.sponsor:
          return 'SPONSOR';
        case UstaTier.vitrin:
          return 'VİTRİN';
        case UstaTier.pro:
          return 'PRO';
        case UstaTier.standard:
        default:
          return 'STANDART';
      }
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // TODO: Firma profil sayfası route’u bağlanacak
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Sol ikon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.apartment_outlined,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 10),

              // Orta
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.companyName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.serviceTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.star, size: 16, color: Colors.amber.shade700),
                        const SizedBox(width: 4),
                        Text(
                          '${item.rating.toStringAsFixed(1)} (${item.ratingCount})',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${item.locationText} • ${item.distanceText}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Sağ rozetler
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: theme.colorScheme.primary.withOpacity(0.10),
                    ),
                    child: Text(
                      tierLabel(item.tier),
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (item.hasInvoice)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        color: Colors.green.withOpacity(0.10),
                      ),
                      child: Text(
                        'FATURALI',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
