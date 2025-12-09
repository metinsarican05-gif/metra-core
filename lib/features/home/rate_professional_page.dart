// lib/features/home/rate_professional_page.dart

import 'package:flutter/material.dart';

class RateProfessionalPage extends StatefulWidget {
  final String professionalName;

  const RateProfessionalPage({
    super.key,
    required this.professionalName,
  });

  @override
  State<RateProfessionalPage> createState() => _RateProfessionalPageState();
}

class _RateProfessionalPageState extends State<RateProfessionalPage> {
  double _rating = 4.0;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Puan Ver"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.professionalName,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Bu profesyonel için puan ver ve istersen kısa bir yorum yaz.",
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Column(
                  children: [
                    Text(
                      "${_rating.toStringAsFixed(1)} / 5",
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      children: List.generate(5, (index) {
                        final starIndex = index + 1;
                        return IconButton(
                          onPressed: () {
                            setState(() {
                              _rating = starIndex.toDouble();
                            });
                          },
                          icon: Icon(
                            starIndex <= _rating
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            size: 32,
                            color: Colors.amber.shade700,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Yorum (opsiyonel)",
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _commentController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "İşin kalitesi, iletişim, zamanlama vb. hakkında yazabilirsin.",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitRating,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    "Puanı Gönder",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitRating() {
    // Şimdilik sahte işlem: backend yok.
    // Burada normalde API'ye rating gönderilir.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Puanın kaydedildi: ${_rating.toStringAsFixed(1)}",
        ),
      ),
    );
    Navigator.of(context).pop(); // Profil sayfasına geri dön
  }
}

