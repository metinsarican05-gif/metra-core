// lib/features/home/jobs_page.dart
import 'package:flutter/material.dart';
import 'job_model.dart';
import 'job_detail_page.dart';

/// Ustanın gördüğü "ilan / ihale" listesi.
/// Şimdilik tüm veriler lokal listeden geliyor (demo).
class JobsPage extends StatefulWidget {
  const JobsPage({super.key});

  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  late final List<JobModel> _jobs;

  @override
  void initState() {
    super.initState();

    // DEMO İLAN VERİLERİ (Artık fotoğraflı)
    _jobs = const [
      JobModel(
        id: '1',
        title: 'Banyo Komple Tadilat',
        description:
        'Eski fayanslar sökülecek, tesisat kontrol edilecek, yeni seramik ve duşakabin yapılacak. '
            'Dolap ve ayna için ayrıca teklif verebilirsiniz. İş Dörtyol\'da, 2 hafta içinde başlanması gerekiyor.',
        category: 'Tadilat',
        location: 'Dörtyol / Hatay',
        createdAgoText: '3 saat önce',
        minBudget: 20000,
        maxBudget: 35000,
        isUrgent: true,
        isVerified: true,
        offerCount: 4,
        imageUrls: [
          'https://picsum.photos/seed/job1a/900/600',
          'https://picsum.photos/seed/job1b/900/600',
        ],
      ),
      JobModel(
        id: '2',
        title: 'Salon Boya & Dekoratif Çalışma',
        description:
        'Salonun duvarları açık renge boyanacak, TV ünitesi arkası için dekoratif boya veya duvar kağıdı düşünüyorum. '
            'Sadece işçilik fiyatı istiyorum, malzeme benden olabilir.',
        category: 'Boya / Dekorasyon',
        location: 'İskenderun / Hatay',
        createdAgoText: 'Dün',
        minBudget: 5000,
        maxBudget: 8000,
        isUrgent: false,
        isVerified: false,
        offerCount: 2,
        imageUrls: [
          'https://picsum.photos/seed/job2a/900/600',
        ],
      ),
      JobModel(
        id: '3',
        title: 'Elektrik Tesisatı Kontrolü',
        description:
        'Eski daire, sigortalar sık sık atıyor. Tesisatın genel kontrolü ve gerekiyorsa kısmi yenileme yapılacak. '
            'Uygun fiyatlı, güvenilir bir usta arıyorum.',
        category: 'Elektrik',
        location: 'Payas / Hatay',
        createdAgoText: '2 gün önce',
        minBudget: 3000,
        maxBudget: 6000,
        isUrgent: false,
        isVerified: true,
        offerCount: 1,
        imageUrls: [
          'https://picsum.photos/seed/job3a/900/600',
        ],
      ),
      JobModel(
        id: '4',
        title: 'Mutfak Dolabı Yenileme',
        description:
        'Mevcut dolaplar eskidi, kapaklar ve tezgah değişecek. Granit tezgah düşünüyorum. '
            'Ölçü alınıp yerinde bakılması gerekiyor. Yaklaşık 12 m2 mutfak.',
        category: 'Mobilya / Mutfak',
        location: 'Antakya / Hatay',
        createdAgoText: '1 hafta önce',
        minBudget: 25000,
        maxBudget: 40000,
        isUrgent: false,
        isVerified: false,
        offerCount: 5,
        imageUrls: [
          'https://picsum.photos/seed/job4a/900/600',
          'https://picsum.photos/seed/job4b/900/600',
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_jobs.isEmpty) {
      return Center(
        child: Text(
          'Şu an gösterilecek ilan yok.\n\nİleride buraya müşterilerin açtığı işler gelecek.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey[700],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _jobs.length,
      itemBuilder: (context, index) {
        final job = _jobs[index];
        return _JobCard(job: job);
      },
    );
  }
}

/// Liste üzerindeki tekil ilan kartı.
class _JobCard extends StatelessWidget {
  final JobModel job;

  const _JobCard({required this.job});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => JobDetailPage(job: job),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Üst satır: kategori + tarih
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
              const SizedBox(height: 8),

              // Başlık
              Text(
                job.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),

              // Konum
              Row(
                children: [
                  const Icon(Icons.location_on_outlined,
                      size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      job.location,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Bütçe + etiketler
              Row(
                children: [
                  Icon(Icons.payments_outlined,
                      size: 18, color: colorScheme.primary),
                  const SizedBox(width: 4),
                  Text(
                    job.budgetText,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                  ),
                  const Spacer(),
                  if (job.isUrgent)
                    _TagChip(
                      label: 'Acil',
                      icon: Icons.flash_on,
                      color: Colors.redAccent,
                    ),
                  if (job.isVerified) ...[
                    const SizedBox(width: 4),
                    _TagChip(
                      label: 'Doğrulanmış',
                      icon: Icons.verified,
                      color: Colors.green,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),

              // FOTOĞRAF ÖNİZLEMESİ (varsa)
              if (job.imageUrls.isNotEmpty) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      job.imageUrls.first,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],

              // Açıklamadan kısa özet
              Text(
                job.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),

              // Alt satır: teklif sayısı + "detay"
              Row(
                children: [
                  Icon(Icons.gavel_outlined,
                      size: 16, color: Colors.grey[700]),
                  const SizedBox(width: 4),
                  Text(
                    '${job.offerCount} teklif',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[700],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Detayları gör',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Icon(Icons.chevron_right,
                      size: 18, color: Colors.grey),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Küçük renkli etiket (Acil, Doğrulanmış vb.)
class _TagChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _TagChip({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.6), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
