// lib/features/home/jobs_page.dart
import 'package:flutter/material.dart';
import 'job_model.dart';
import 'create_job_page.dart';
import 'job_detail_page.dart';

/// Hem usta hem müşteri için ortak "İlanlar" sekmesi
class JobsPage extends StatelessWidget {
  const JobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Sahte ilan verileri
    final List<Job> jobs = [
      const Job(
        id: '1',
        ownerId: 'user_1',
        title: '2+1 ev için komple boya',
        description:
        'Salon ve iki oda olacak şekilde toplam 90 m². Düz renk, silinebilir boya istiyoruz.',
        category: 'Boya & Dekorasyon',
        city: 'İstanbul',
        district: 'Kadıköy',
        budgetMin: 8000,
        budgetMax: 12000,
        urgency: 'Bu hafta içinde',
      ),
      const Job(
        id: '2',
        ownerId: 'user_2',
        title: 'Mutfak dolabı yenileme',
        description:
        'Eski dolaplar sökülüp yerine modern, lake kapaklı dolap yapılacak. Metrekare yaklaşık 12 m².',
        category: 'Marangoz',
        city: 'Ankara',
        district: 'Çankaya',
        budgetMin: 20000,
        budgetMax: 30000,
        urgency: 'Bu ay içinde',
      ),
      const Job(
        id: '3',
        ownerId: 'user_3',
        title: 'Banyo su tesisatı sorunları',
        description:
        'Duş kısmında su basıncı düşük, sıcak su geç geliyor. Tesisat kontrolü ve gerekirse yenileme.',
        category: 'Su Tesisatı',
        city: 'İzmir',
        district: 'Karşıyaka',
        budgetMin: 3000,
        budgetMax: 6000,
        urgency: 'Acil',
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: jobs.length + 1, // ilk eleman "İlan Aç" butonu
      itemBuilder: (context, index) {
        if (index == 0) {
          // Üstte "İlan Aç" butonu
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CreateJobPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.add_box_outlined),
                label: const Text(
                  'İlan Aç',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          );
        }

        final job = jobs[index - 1];
        return _JobCard(job: job);
      },
    );
  }
}

class _JobCard extends StatelessWidget {
  final Job job;

  const _JobCard({required this.job});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    String budgetText;
    if (job.budgetMin != null && job.budgetMax != null) {
      budgetText = '${job.budgetMin!.toStringAsFixed(0)}₺ - '
          '${job.budgetMax!.toStringAsFixed(0)}₺';
    } else if (job.budgetMin != null) {
      budgetText = 'Min ${job.budgetMin!.toStringAsFixed(0)}₺';
    } else if (job.budgetMax != null) {
      budgetText = 'Max ${job.budgetMax!.toStringAsFixed(0)}₺';
    } else {
      budgetText = 'Bütçe belirtilmemiş';
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => JobDetailPage(job: job),
          ),
        );
      },
      borderRadius: BorderRadius.circular(18),

      // Burada önceki Card içeriğin aynısını kullan:
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ... ÖNCEKİ job kartındaki içerik aynen buraya ...
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.assignment_outlined,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          job.category,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${job.city} / ${job.district}',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.schedule_outlined, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    job.urgency,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 16,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    budgetText,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                job.description,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
