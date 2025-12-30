import 'package:flutter/material.dart';
import 'package:nexira/core/premium/premium_config.dart';
import '../usta_card.dart';

/// Filtre tipleri
enum ExploreFilter {
  nearby,     // Yakınımda
  topRated,   // En yüksek puan
  premium,    // Pro + Vitrin + Sponsor
  cheap,      // (şimdilik yok)
}

/// Keşfet için model (Widget değil!)
class UstaExploreItem {
  final String name;
  final String jobTitle;
  final double rating;
  final int ratingCount;
  final String locationText;
  final String distanceText; // "3 km"
  final UstaTier tier;

  // İleride: ustaId / userId / slug
  final String id;

  const UstaExploreItem({
    required this.id,
    required this.name,
    required this.jobTitle,
    required this.rating,
    required this.ratingCount,
    required this.locationText,
    required this.distanceText,
    required this.tier,
  });

  double? get distanceKm {
    final parts = distanceText.trim().split(' ');
    if (parts.isEmpty) return null;
    return double.tryParse(parts.first.replaceAll(',', '.'));
  }
}

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late final List<UstaExploreItem> _all;

  // Aktif filtreler
  final List<ExploreFilter> activeFilters = [];

  // Arama kutusu
  String searchQuery = '';

  @override
  void initState() {
    super.initState();

    // Demo veri (Widget değil, model!)
    _all = const [
      UstaExploreItem(
        id: '1',
        name: 'Sarıcan Yapı & Dekorasyon',
        jobTitle: 'Seramik & Banyo Yenileme',
        rating: 4.9,
        ratingCount: 128,
        locationText: 'Dörtyol',
        distanceText: '3 km',
        tier: UstaTier.pro,
      ),
      UstaExploreItem(
        id: '2',
        name: 'Usta Mehmet',
        jobTitle: 'Elektrik Tesisatı',
        rating: 4.7,
        ratingCount: 64,
        locationText: 'Payas',
        distanceText: '7 km',
        tier: UstaTier.pro,
      ),
      UstaExploreItem(
        id: '3',
        name: 'Altın Eller İnşaat',
        jobTitle: 'İç Mekan Tadilat',
        rating: 4.8,
        ratingCount: 93,
        locationText: 'İskenderun',
        distanceText: '10 km',
        tier: UstaTier.vitrin,
      ),
      UstaExploreItem(
        id: '4',
        name: 'Hızır Tesisat',
        jobTitle: 'Su Tesisatı',
        rating: 4.4,
        ratingCount: 41,
        locationText: 'Dörtyol',
        distanceText: '1.5 km',
        tier: UstaTier.standard,
      ),
      UstaExploreItem(
        id: '5',
        name: 'Lüks Dekor Metal',
        jobTitle: 'Ferforje & Korkuluk',
        rating: 4.6,
        ratingCount: 52,
        locationText: 'İskenderun',
        distanceText: '4 km',
        tier: UstaTier.sponsor,
      ),
    ];
  }

  void toggleFilter(ExploreFilter filter) {
    setState(() {
      if (activeFilters.contains(filter)) {
        activeFilters.remove(filter);
      } else {
        activeFilters.add(filter);
      }
    });
  }

  List<UstaExploreItem> applyFilters(List<UstaExploreItem> all) {
    var filtered = List<UstaExploreItem>.from(all);

    // Yakınımda: < 5 km
    if (activeFilters.contains(ExploreFilter.nearby)) {
      filtered = filtered.where((u) {
        final km = u.distanceKm;
        if (km == null) return true;
        return km < 5.0;
      }).toList();
    }

    // En yüksek puan: >= 4.5
    if (activeFilters.contains(ExploreFilter.topRated)) {
      filtered = filtered.where((u) => u.rating >= 4.5).toList();
    }

    // Premium: pro + vitrin + sponsor
    if (activeFilters.contains(ExploreFilter.premium)) {
      filtered = filtered.where((u) {
        return u.tier == UstaTier.pro ||
            u.tier == UstaTier.vitrin ||
            u.tier == UstaTier.sponsor;
      }).toList();
    }

    // Arama
    final q = searchQuery.trim().toLowerCase();
    if (q.isNotEmpty) {
      filtered = filtered.where((u) {
        final fields = [
          u.name,
          u.jobTitle,
          u.locationText,
        ].join(' ').toLowerCase();
        return fields.contains(q);
      }).toList();
    }

    // (Şimdilik) temel sıralama: tier > puan > mesafe
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

  Widget _buildFilterChip({
    required String label,
    required ExploreFilter filter,
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
    final visibleList = applyFilters(_all);

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Usta / Profesyonel Bul'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Arama kutusu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Usta, meslek, şehir ara...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(999),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
          ),

          // Keşfet açıklaması
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Keşfet',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Sana en yakın ustalar; puan, paket ve konumuna göre listelenir.',
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
                _buildFilterChip(label: 'Yakınımda', filter: ExploreFilter.nearby),
                _buildFilterChip(label: 'En yüksek puan', filter: ExploreFilter.topRated),
                _buildFilterChip(label: 'Premium', filter: ExploreFilter.premium),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Grid (dopdolu)
          Expanded(
            child: visibleList.isEmpty
                ? Center(
              child: Text(
                'Filtrelere uygun usta bulunamadı.',
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
              ),
            )
                : GridView.builder(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 7,
                crossAxisSpacing: 7,
                mainAxisExtent: 172, // ✅ dopdolu görünümün anahtarı
              ),
              itemCount: visibleList.length,
              itemBuilder: (context, index) {
                final u = visibleList[index];

                return UstaCard(
                  name: u.name,
                  jobTitle: u.jobTitle,
                  rating: u.rating,
                  ratingCount: u.ratingCount,
                  locationText: u.locationText,
                  distanceText: u.distanceText,
                  tier: u.tier,
                  onTap: () {
                    // Senin projende var olan route adı:
                    Navigator.pushNamed(
                      context,
                      '/ustaProfile',
                      arguments: u, // ileride u.id göndereceğiz
                    );
                  },
                  onFollow: () {
                    // TODO: takip state
                  },
                  onMessage: () {
                    // TODO: mesaj ekranı
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
