import 'package:flutter/material.dart';

/// Ustanın paket tipi (görsel/rozet seviyesi)
enum UstaTier {
  standard,
  pro,
  vitrin,
  sponsor,
}

/// Premium'da kilitlenebilir özellikler (V1 + V2 hazırlık)
enum PremiumFeature {
  // Kartvizit
  digitalBusinessCard, // paylaşılabilir kartvizit linki
  qrCode,

  // Rozetler / görünüm
  professionalBadge,
  showcaseBadge,
  sponsorBadge,
  showcaseHighlight,

  // Keşfet / listeleme davranışı
  priorityListing, // dengeleyici öne çıkma

  // Portföy
  beforeAfterLimit, // limit mantığı ayrı fonksiyonla verilecek
  videoUpload, // V2 (V1'de kapalı)

  // ✅ En kritik satış gerekçesi (V1)
  inboxPriority, // mesajlarda / konuşmalarda daha görünür olma
  offerPriority, // teklif listelerinde daha görünür olma
}

/// Her paket için görsel / rozet ayarları (UI tarafı)
class UstaTierConfig {
  /// Rozet ismi: Standart / Pro / Vitrin / Sponsor
  final String name;

  /// Kartın dış çerçeve rengi
  final Color borderColor;

  /// Kartın ana arka plan rengi (gradient için temel renk)
  final Color? backgroundColor;

  /// Sağ üst rozetin arka plan rengi
  final Color? badgeColor;

  /// Rozet yazısının rengi
  final Color? badgeTextColor;

  /// Kart hafif vurgulansın mı (gölge vb. için)
  final bool highlightCard;

  /// Kart karanlık tema gibi mi davranıyor? (Yazı renklerini ayarlamak için)
  final bool darkCard;

  const UstaTierConfig({
    required this.name,
    required this.borderColor,
    this.backgroundColor,
    this.badgeColor,
    this.badgeTextColor,
    this.highlightCard = false,
    this.darkCard = false,
  });

  /// Seçilen pakete göre görsel ayarları döndür (UI)
  static UstaTierConfig of(BuildContext context, UstaTier tier) {
    switch (tier) {
      case UstaTier.standard:
        return const UstaTierConfig(
          name: 'Standart',
          borderColor: Color(0xFFB0BEC5), // gri çerçeve
          backgroundColor: Color(0xFFF5F7FA), // çok açık gri
          badgeColor: null,
          badgeTextColor: null,
          highlightCard: false,
          darkCard: false,
        );

      case UstaTier.pro:
        return const UstaTierConfig(
          name: 'Pro',
          borderColor: Color(0xFF00C8FF),
          backgroundColor: Color(0xFF022438),
          badgeColor: Color(0xFF00C8FF),
          badgeTextColor: Colors.white,
          highlightCard: true,
          darkCard: true,
        );

      case UstaTier.vitrin:
        return const UstaTierConfig(
          name: 'Vitrin',
          borderColor: Color(0xFFB8860B),
          backgroundColor: Color(0xFF5C3A00),
          badgeColor: Color(0xFFFFD54F),
          badgeTextColor: Color(0xFF4E2C00),
          highlightCard: true,
          darkCard: true,
        );

      case UstaTier.sponsor:
        return const UstaTierConfig(
          name: 'Sponsor',
          borderColor: Color(0xFFB388FF),
          backgroundColor: Color(0xFF2B1848),
          badgeColor: Color(0xFFE1BEE7),
          badgeTextColor: Color(0xFF4A148C),
          highlightCard: true,
          darkCard: true,
        );
    }
  }
}

/// Ürün mantığı: hangi tier hangi premium özelliklere sahip? (TEK KAYNAK)
class PremiumPolicy {
  PremiumPolicy._();

  /// V1 kararı: Sponsor tier UI'da görünebilir ama satın alınabilirlik ayrı yönetilecek.
  /// Bu sınıf sadece "özellik erişimi" verir.

  static const Set<PremiumFeature> _standard = {
    PremiumFeature.beforeAfterLimit,
    // İletişim (WhatsApp/arama/mesaj) burada TANIMLANMAZ -> asla kilitlenmeyecek
  };

  static const Set<PremiumFeature> _pro = {
    PremiumFeature.digitalBusinessCard,
    PremiumFeature.qrCode,
    PremiumFeature.professionalBadge,
    PremiumFeature.priorityListing,
    PremiumFeature.beforeAfterLimit,

    // ✅ V1 satış çekirdeği
    PremiumFeature.inboxPriority,
    PremiumFeature.offerPriority,
  };

  static const Set<PremiumFeature> _vitrin = {
    PremiumFeature.digitalBusinessCard,
    PremiumFeature.qrCode,
    PremiumFeature.showcaseBadge,
    PremiumFeature.showcaseHighlight,
    PremiumFeature.priorityListing,
    PremiumFeature.beforeAfterLimit,

    // ✅ V1 satış çekirdeği
    PremiumFeature.inboxPriority,
    PremiumFeature.offerPriority,

    // videoUpload V2’de AÇILACAK (şimdilik kapalı)
    // PremiumFeature.videoUpload,
  };

  static const Set<PremiumFeature> _sponsor = {
    // V1: sponsor satışta yok. Ama ileride açılırsa diye hazır.
    PremiumFeature.sponsorBadge,
    PremiumFeature.digitalBusinessCard,
    PremiumFeature.qrCode,
    PremiumFeature.priorityListing,
    PremiumFeature.beforeAfterLimit,
    PremiumFeature.inboxPriority,
    PremiumFeature.offerPriority,
  };

  static bool hasFeature(UstaTier tier, PremiumFeature feature) {
    final set = switch (tier) {
      UstaTier.standard => _standard,
      UstaTier.pro => _pro,
      UstaTier.vitrin => _vitrin,
      UstaTier.sponsor => _sponsor,
    };
    return set.contains(feature);
  }

  /// Öncesi–sonrası limiti (V1 kilit)
  /// - Standart: 3
  /// - Pro: 8
  /// - Vitrin: sınırsız
  static int beforeAfterLimit(UstaTier tier) {
    switch (tier) {
      case UstaTier.standard:
        return 3;
      case UstaTier.pro:
        return 8;
      case UstaTier.vitrin:
        return 999999; // pratikte sınırsız
      case UstaTier.sponsor:
        return 999999;
    }
  }

  /// Video yükleme (V2): şimdilik herkes için kapalı.
  /// V2’de açarken: (tier == pro || tier == vitrin) true yapacağız.
  static bool canUploadVideo(UstaTier tier) {
    // V1: kapalı
    return false;
  }

  /// Inbox/Offer boost katsayısı (sıralama motorunda kullanacağız)
  /// Dengeleyici: lokasyon+puan ana belirleyici kalacak.
  static double inboxBoost(UstaTier tier) {
    if (!hasFeature(tier, PremiumFeature.inboxPriority)) return 0.0;
    switch (tier) {
      case UstaTier.standard:
        return 0.0;
      case UstaTier.pro:
        return 0.10;
      case UstaTier.vitrin:
        return 0.18;
      case UstaTier.sponsor:
        return 0.20;
    }
  }

  static double offerBoost(UstaTier tier) {
    if (!hasFeature(tier, PremiumFeature.offerPriority)) return 0.0;
    switch (tier) {
      case UstaTier.standard:
        return 0.0;
      case UstaTier.pro:
        return 0.10;
      case UstaTier.vitrin:
        return 0.18;
      case UstaTier.sponsor:
        return 0.20;
    }
  }
}
