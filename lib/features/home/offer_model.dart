// lib/features/home/offer_model.dart

/// Teklif durumu
enum OfferStatus {
  pending,   // Beklemede
  accepted,  // Kabul edildi
  rejected,  // Reddedildi
}

/// İlanlara verilen teklifler için model
class Offer {
  final String id;
  final String jobId;             // Hangi ilana ait
  final String jobTitle;          // İlan başlığı (listelemede göstermek için)
  final String professionalId;    // Teklifi veren profesyonelin ID'si
  final String professionalName;  // Teklifi verenin adı
  final double price;             // Teklif edilen fiyat
  final String estimatedDuration; // Örn: "3 gün", "1 hafta"
  final String note;              // Kısa not
  final OfferStatus status;       // Durum
  final DateTime createdAt;       // Teklif tarihi

  Offer({
    required this.id,
    required this.jobId,
    required this.jobTitle,
    required this.professionalId,
    required this.professionalName,
    required this.price,
    required this.estimatedDuration,
    required this.note,
    this.status = OfferStatus.pending,
    required this.createdAt,
  });
}
