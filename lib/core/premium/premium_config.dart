import 'package:flutter/material.dart';

/// Ustanın paket tipi
enum UstaTier {
  standard,
  pro,
  vitrin,
  sponsor,
}

/// Her paket için görsel / rozet ayarları
class UstaTierConfig {
  /// Rozet ismi: Standart / Pro / Vitrin / Sponsor
  final String name;

  /// Kartın dış çerçeve rengi
  final Color borderColor;

  /// Kartın arka plan rengi (yoksa null)
  final Color? backgroundColor;

  /// Sağ üst rozetin arka plan rengi
  final Color? badgeColor;

  /// Rozet yazısının rengi
  final Color? badgeTextColor;

  /// Kart hafif vurgulansın mı (gölge vb. için)
  final bool highlightCard;

  UstaTierConfig({
    required this.name,
    required this.borderColor,
    this.backgroundColor,
    this.badgeColor,
    this.badgeTextColor,
    this.highlightCard = false,
  });

  /// Seçilen pakete göre ayarları döndür
  static UstaTierConfig of(BuildContext context, UstaTier tier) {
    switch (tier) {
      case UstaTier.standard:
        return UstaTierConfig(
          name: 'Standart',
          borderColor: Colors.grey, // sade gri çerçeve
          backgroundColor: Colors.white,
          badgeColor: null, // rozet yok
          badgeTextColor: null,
          highlightCard: false,
        );

      case UstaTier.pro:
        return UstaTierConfig(
          name: 'Pro',
          borderColor: const Color(0xFF00B5E2),
          backgroundColor: const Color(0xFFE0F8FF),
          badgeColor: const Color(0xFFE0F8FF),
          badgeTextColor: const Color(0xFF00B5E2),
          highlightCard: true,
        );

      case UstaTier.vitrin:
        return UstaTierConfig(
          name: 'Vitrin',
          borderColor: const Color(0xFFFFC857),
          backgroundColor: const Color(0xFFFFF7E3),
          badgeColor: const Color(0xFFFFF7E3),
          badgeTextColor: const Color(0xFFCC8A00),
          highlightCard: true,
        );

      case UstaTier.sponsor:
        return UstaTierConfig(
          name: 'Sponsor',
          borderColor: const Color(0xFFB388FF),
          backgroundColor: const Color(0xFFF3E8FF),
          badgeColor: const Color(0xFFF3E8FF),
          badgeTextColor: const Color(0xFF7C4DFF),
          highlightCard: true,
        );
    }
  }
}
