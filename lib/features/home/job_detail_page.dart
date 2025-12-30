// lib/features/home/job_detail_page.dart
import 'package:flutter/material.dart';
import 'job_model.dart';

/// İlan kartına tıklanınca açılan detay sayfası.
/// Şimdilik sadece okuma modunda, ileride buraya "Teklif ver" gelecek.
class JobDetailPage extends StatelessWidget {
  final JobModel job;

  const JobDetailPage({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('İlan Detayı'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kategori + tarih
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    job.category,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  job.createdAgoText,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Başlık
            Text(
              job.title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),

            // Konum
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 18, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    job.location,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // FOTO GALERİ (varsa)
            if (job.imageUrls.isNotEmpty) ...[
              SizedBox(
                height: 220,
                child: PageView.builder(
                  itemCount: job.imageUrls.length,
                  itemBuilder: (context, index) {
                    final url = job.imageUrls[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          url,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              if (job.imageUrls.length > 1)
                Text(
                  'İlan fotoğrafları (${job.imageUrls.length} adet)',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[700],
                  ),
                ),
              const SizedBox(height: 16),
            ],

            // Bütçe kutusu
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.04),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.primary.withOpacity(0.5),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.payments_outlined,
                      size: 24, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tahmini bütçe aralığı',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        job.budgetText,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Etiketler
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (job.isUrgent)
                  Chip(
                    avatar: const Icon(Icons.flash_on, size: 18),
                    label: const Text('Acil iş'),
                    backgroundColor: Colors.redAccent.withOpacity(0.08),
                  ),
                if (job.isVerified)
                  Chip(
                    avatar: const Icon(Icons.verified, size: 18),
                    label: const Text('Doğrulanmış ilan'),
                    backgroundColor: Colors.green.withOpacity(0.08),
                  ),
                Chip(
                  avatar: const Icon(Icons.gavel_outlined, size: 18),
                  label: Text('${job.offerCount} teklif mevcut'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Açıklama
            Text(
              'İşin detaylı açıklaması',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              job.description,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),

            // Şimdilik pasif olan buton bölgesi
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // İLERİDE: teklif formu açılacak.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Demo sürüm: Teklif verme henüz aktif değil.',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.gavel_outlined),
                label: const Text('Bu iş için teklif ver (yakında)'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
