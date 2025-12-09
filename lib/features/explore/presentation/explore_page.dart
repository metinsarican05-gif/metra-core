import 'package:flutter/material.dart';
import '/core/premium/premium_config.dart';
import '../usta_card.dart';
/// Filtre tipleri
enum ExploreFilter {
  nearby,     // Yakınımda
  topRated,   // En yüksek puan
  premium,    // Pro + Vitrin + Sponsor
  cheap,      // Fiyat uygun
}

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  // Tüm ustalar (şimdilik demo veri)
  late final List<UstaCard> _allUstas;

  // Aktif filtreler
  List<ExploreFilter> activeFilters = [];

  // Arama kutusu
  String searchQuery = '';

  @override
  void initState() {
    super.initState();

    _allUstas = [
      UstaCard(
        name: 'Sarıcan Yapı & Dekorasyon',
        companyName: 'Sarıcan Yapı & Dekorasyon',
        jobTitle: 'Seramik & Banyo Yenileme',
        rating: 4.9,
        ratingCount: 128,
        locationText: 'Dörtyol',
        distanceText: '3 km',
        priceText: '9.500 ₺',
        priceSubtitle: 'Malzemeler hariç',
        description:
        'Banyonuzu 2 günde tertemiz teslim ederim. Kırım, tesisat, seramik tek elden.',
        hasPhotoPreview: true,
        tier: UstaTier.pro,
      ),
      UstaCard(
        name: 'Usta Mehmet',
        jobTitle: 'Elektrik Tesisatı',
        rating: 4.7,
        ratingCount: 64,
        locationText: 'Payas',
        distanceText: '7 km',
        description:
        'Kısa devre, sigorta, aydınlatma, led işleri. Fiyat için mesajlaşalım.',
        tier: UstaTier.pro,
      ),
      UstaCard(
        name: 'Altın Eller İnşaat',
        jobTitle: 'İç Mekan Tadilat',
        rating: 4.8,
        ratingCount: 93,
        locationText: 'İskenderun',
        distanceText: '10 km',
        priceText: '45.000 ₺',
        priceSubtitle: 'Anahtar teslim daire tadilatı',
        description:
        'Mutfak, banyo, parke, boya, kapı – komple iç mekan yenileme.',
        hasPhotoPreview: true,
        tier: UstaTier.vitrin,
      ),
      UstaCard(
        name: 'Hızır Tesisat',
        jobTitle: 'Su Tesisatı',
        rating: 4.4,
        ratingCount: 41,
        locationText: 'Dörtyol',
        distanceText: '1.5 km',
        priceText: '3.000 ₺',
        priceSubtitle: 'Basit tadilatlar için ortalama',
        description:
        'Su kaçakları, tıkanıklık açma, kombi bağlantıları. Uygun fiyatlı çözümler.',
        tier: UstaTier.standard,
      ),
      UstaCard(
        name: 'Lüks Dekor Metal',
        jobTitle: 'Ferforje & Korkuluk',
        rating: 4.6,
        ratingCount: 52,
        locationText: 'İskenderun',
        distanceText: '4 km',
        description:
        'Balkon, merdiven, bahçe kapısı – özel tasarım metal işler.',
        tier: UstaTier.sponsor,
      ),
    ];
  }

  // Filtreleri uygula + arama metnine göre filtrele
  List<UstaCard> applyFilters(List<UstaCard> all) {
    List<UstaCard> filtered = List<UstaCard>.from(all);

    // Yakınımda → mesafe < 5 km
    if (activeFilters.contains(ExploreFilter.nearby)) {
      filtered = filtered.where((u) {
        final km = _parseKm(u.distanceText);
        if (km == null) return true;
        return km < 5.0;
      }).toList();
    }

    // En yüksek puan → 4.5 ve üzeri
    if (activeFilters.contains(ExploreFilter.topRated)) {
      filtered = filtered.where((u) => u.rating >= 4.5).toList();
    }

    // Premium → pro + vitrin + sponsor
    if (activeFilters.contains(ExploreFilter.premium)) {
      filtered = filtered.where((u) {
        return u.tier == UstaTier.pro ||
            u.tier == UstaTier.vitrin ||
            u.tier == UstaTier.sponsor;
      }).toList();
    }

    // Fiyat uygun → 10.000 ₺ altı (fiyatı olanlar için)
    if (activeFilters.contains(ExploreFilter.cheap)) {
      filtered = filtered.where((u) {
        if (u.priceText == null) return false;
        final value = _parsePrice(u.priceText!);
        if (value == null) return false;
        return value < 10000;
      }).toList();
    }

    // Arama metni → isim, firma, meslek, lokasyon içinde ara
    final q = searchQuery.trim().toLowerCase();
    if (q.isNotEmpty) {
      filtered = filtered.where((u) {
        final fields = [
          u.name,
          u.companyName ?? '',
          u.jobTitle,
          u.locationText,
        ].join(' ').toLowerCase();
        return fields.contains(q);
      }).toList();
    }

    // İleride burada sıralama algoritmasını (sponsor > vitrin > pro > standard) ekleriz.

    return filtered;
  }

  // Filtreyi aç/kapat
  void toggleFilter(ExploreFilter filter) {
    setState(() {
      if (activeFilters.contains(filter)) {
        activeFilters.remove(filter);
      } else {
        activeFilters.add(filter);
      }
    });
  }

  // Fiyat metninden sayıyı çeker (ör: "9.500 ₺" → 9500.0)
  double? _parsePrice(String text) {
    final cleaned = text
        .replaceAll('₺', '')
        .replaceAll('.', '')
        .replaceAll(',', '.')
        .trim();
    return double.tryParse(cleaned);
  }

  // "3 km" → 3.0
  double? _parseKm(String text) {
    final parts = text.split(' ');
    if (parts.isEmpty) return null;
    return double.tryParse(parts.first.replaceAll(',', '.'));
  }

  // Ortak filtre butonu
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
    final visibleList = applyFilters(_allUstas);

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
            padding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
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
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          // Filtre butonları
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                _buildFilterChip(
                  label: 'Yakınımda',
                  filter: ExploreFilter.nearby,
                ),
                _buildFilterChip(
                  label: 'En yüksek puan',
                  filter: ExploreFilter.topRated,
                ),
                _buildFilterChip(
                  label: 'Premium',
                  filter: ExploreFilter.premium,
                ),
                _buildFilterChip(
                  label: 'Fiyat uygun',
                  filter: ExploreFilter.cheap,
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Usta listesi
          Expanded(
            child: visibleList.isEmpty
                ? Center(
              child: Text(
                'Filtrelere uygun usta bulunamadı.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                ),
              ),
            )
                : ListView.builder(
              itemCount: visibleList.length,
              itemBuilder: (context, index) {
                return visibleList[index];
              },
            ),
          ),
        ],
      ),
    );
  }
}
