// lib/features/home/create_offer_page.dart
import 'package:flutter/material.dart';
import 'job_model.dart';

class CreateOfferPage extends StatefulWidget {
  final Job job;

  const CreateOfferPage({super.key, required this.job});

  @override
  State<CreateOfferPage> createState() => _CreateOfferPageState();
}

class _CreateOfferPageState extends State<CreateOfferPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _priceController.dispose();
    _durationController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submitOffer() {
    if (!_formKey.currentState!.validate()) return;

    // Gerçekte burada Offer modeli oluşturup backend'e göndereceğiz.
    // Şimdilik sadece "başarılı" mesajı gösteriyoruz.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Teklif gönderildi (şimdilik sahte).'),
      ),
    );

    Navigator.pop(context); // Teklif sayfasını kapat
    Navigator.pop(context); // İlan detay sayfasını da kapatmak istersen, bunu tutabilirsin
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teklif Ver'),
         
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // İlan bilgisi
              Text(
                widget.job.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${widget.job.city} / ${widget.job.district} • ${widget.job.category}',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),

              // Fiyat
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Teklif Fiyatı (₺)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Lütfen bir fiyat gir.';
                  }
                  if (double.tryParse(value.replaceAll(',', '.')) == null) {
                    return 'Geçerli bir sayı yaz.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Tahmini süre
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(
                  labelText: 'Tahmini Süre',
                  hintText: 'Ör: 3 gün, 1 hafta',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Lütfen tahmini süreyi yaz.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Not
              TextFormField(
                controller: _noteController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Kısa Not',
                  hintText:
                  'İşi nasıl yapacağını, fiyatın neyi kapsadığını, önemli gördüğün detayları yaz...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitOffer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Teklifi Gönder',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
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
}
