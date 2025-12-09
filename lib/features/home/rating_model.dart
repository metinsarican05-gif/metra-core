// lib/features/home/rating_model.dart

/// Puanlama modeli
class Rating {
  final String id;              // Rating ID
  final String professionalId;  // Puan verilen usta
  final String customerId;      // Puanı veren kullanıcı
  final String jobId;           // Hangi iş / ilan sonrası verildi
  final int score;              // 1–5 arası puan
  final String? comment;        // Opsiyonel yorum
  final DateTime createdAt;     // Puanın tarihi

  Rating({
    required this.id,
    required this.professionalId,
    required this.customerId,
    required this.jobId,
    required this.score,
    this.comment,
    required this.createdAt,
  });
}
