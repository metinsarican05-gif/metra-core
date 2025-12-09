// lib/features/home/job_model.dart

/// İlan / ihale durumları
enum JobStatus {
  open,        // İlan açık, teklif bekliyor
  inProgress,  // İş başladı
  completed,   // İş tamamlandı
  cancelled,   // İptal edildi
}

/// Nexira ilan / ihale modeli
class Job {
  final String id;
  final String ownerId;        // İlanı açan kullanıcının ID'si
  final String title;          // Başlık
  final String description;    // Açıklama
  final String category;       // Meslek / kategori
  final String city;           // İl
  final String district;       // İlçe
  final double? budgetMin;     // Minimum bütçe (opsiyonel)
  final double? budgetMax;     // Maksimum bütçe (opsiyonel)
  final String urgency;        // "Acil", "Bu hafta" gibi
  final JobStatus status;      // İlan durumu

  const Job({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.description,
    required this.category,
    required this.city,
    required this.district,
    this.budgetMin,
    this.budgetMax,
    required this.urgency,
    this.status = JobStatus.open,
  });
}
