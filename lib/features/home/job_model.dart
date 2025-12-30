// lib/features/home/job_model.dart
import 'package:flutter/material.dart';

/// Müşterinin açtığı ilan / ihale modelimiz (şimdilik sadece UI-demo için).
class JobModel {
  final String id;
  final String title;            // "Banyo tadilatı" gibi
  final String description;      // Detay açıklama
  final String category;         // "Tadilat", "Elektrik", "Dekorasyon" vs.
  final String location;         // "Dörtyol / Hatay"
  final String createdAgoText;   // "3 saat önce", "Dün" gibi
  final int minBudget;           // Tahmini minimum bütçe (₺)
  final int maxBudget;           // Tahmini maksimum bütçe (₺)
  final bool isUrgent;           // "Acil" mi?
  final bool isVerified;         // "Doğrulanmış ilan" (ileride kimlik vs.)
  final int offerCount;          // Kaç teklif geldi (ileride gerçek olacak)

  /// İlan fotoğrafları (detay sayfasında galeri, kartta ilk foto önizleme)
  final List<String> imageUrls;

  const JobModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    required this.createdAgoText,
    required this.minBudget,
    required this.maxBudget,
    required this.isUrgent,
    required this.isVerified,
    required this.offerCount,
    this.imageUrls = const [],
  });

  /// Bütçeyi ekranda göstermek için hazır metin.
  String get budgetText =>
      '${_formatMoney(minBudget)} - ${_formatMoney(maxBudget)} ₺';

  /// Demo amaçlı basit para formatı.
  String _formatMoney(int value) {
    final str = value.toString();
    if (str.length <= 3) return str;
    // 45000 -> 45.000
    final buffer = StringBuffer();
    final chars = str.split('').reversed.toList();
    for (int i = 0; i < chars.length; i++) {
      if (i != 0 && i % 3 == 0) buffer.write('.');
      buffer.write(chars[i]);
    }
    return buffer.toString().split('').reversed.join();
  }
}
